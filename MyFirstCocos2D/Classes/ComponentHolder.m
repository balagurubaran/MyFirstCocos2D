//
//  ComponentHolder.m
//  MyFirstCocos2D
//
//  Created by Balagurubaran on 01/08/2014.
//  Copyright (c) 2014 First. All rights reserved.
//

#import "ComponentHolder.h"
#import "ComponentModel.h"

@implementation ComponentHolder{
    CCSprite *_sprite;
    CCSprite *_sprite1,*tickMark;
    
    CGSize sceneSize;

}

+ (ComponentHolder *)scene
{
    
    return [[self alloc] init];
}

- (id) init {
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    componentArray = [[NSMutableArray alloc] init];
    
    self.position = ccp(670*screenRatioX,110*screenRatioY);
    CGSize s = [[CCDirector sharedDirector] viewSize];
    self.scaleX = s.width/1024 * .3 / screenRatioX;
    self.scaleY = s.height/768 * .50 / screenRatioY;
    
    //sceneSize = CGSizeMake(( s.width/1024 * .3)*s.width, (s.height/768 * .6)*s.height);
    
    //[self setContentSize:CGSizeMake((s.width/1024 * .3)*s.width, (s.height/768 * .6)*s.height)];

    
    // *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:.5f]];
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    //[self addChild:background];
    [self placeComponenet];
    
    tickMark = [CCSprite spriteWithImageNamed:@"tick.gif"];
    tickMark.position  = ccp(-10,0);
    tickMark.scale = 0;
    [self addChild:tickMark];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideTickMarker:) name:@"hideTickMarker" object:nil];
	return self;
}

- (void) placeComponenet{
    
    NSArray *imageArray = [NSArray arrayWithObjects:@"king_black.png",@"queen_black.png",@"rook_black.png",@"knight_black.png",@"bishop_black.png",@"pawn_black.png", nil];
    NSArray *componentType = [NSArray arrayWithObjects:[NSNumber numberWithInt:KING],[NSNumber numberWithInt:QUEEN],[NSNumber numberWithInt:ROOK],[NSNumber numberWithInt:KNIGHT],[NSNumber numberWithInt:BISHOP],[NSNumber numberWithInt:PAWN], nil];
    
    int xIncrement = 0;
    int yIncrement = 0;
    for(int i = 0 ; i < [imageArray count];i++){
        CCSprite *_spriteComponent = [CCSprite spriteWithImageNamed:[imageArray objectAtIndex:i]];
        _spriteComponent.position  = ccp((220 + xIncrement*300)*screenRatioX,self.contentSize.height - (265 + yIncrement * 400)*screenRatioY);
        
        ComponentModel *cmtModel = [[ComponentModel alloc] init];
        cmtModel.type = (int)[[componentType objectAtIndex:i] integerValue];
        _spriteComponent.userObject = cmtModel;
        [self addChild:_spriteComponent];
        [componentArray addObject:_spriteComponent];
        xIncrement++;
        if(xIncrement == 3){
            xIncrement = 0;
            yIncrement++;
        }
    }
    
    int x = 1000;
    CGPoint tickerPosition;
    for(int i = 0; i < [componentArray count]; i++){
        CCSprite *temp = [componentArray objectAtIndex:i];
        CCSprite *numberHolder = [CCSprite spriteWithImageNamed:@"numberHolder.png"];
        
        ComponentModel *tempModel = temp.userObject;
        numberHolder.position  = ccp(temp.position.x - 50*screenRatioX,temp.position.y - 120*screenRatioY);
        numberHolder.userObject = [NSString stringWithFormat:@"%d",x];
        numberHolder.scale *= screenRatioY;
        tempModel.numberHolderSprite = numberHolder;
        [self addChild:tempModel.numberHolderSprite];
        x++;
    }
    CCActionMoveTo *actionMoveTo = [CCActionMoveTo actionWithDuration:.5 position:tickerPosition];
    [tickMark runAction:actionMoveTo];
    
    [self scaleit];
}

- (void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];
    
    for (int i = 0; i < [componentArray count]; i++) {
        if (CGRectContainsPoint( [[componentArray objectAtIndex:i]  boundingBox], touchLoc)) {
            CCSprite *tempSprite =  [componentArray objectAtIndex:i];
            ComponentModel *tempModel = tempSprite.userObject;
            tempModel.isSelected = NO;
            
            for(int j = 0 ; j < [[tempSprite children] count];j++){
                [[[tempSprite children] objectAtIndex:j] removeFromParent];
            }
            if(tempModel.count > 0){
                tempModel.isSelected = YES;
                selectedComponent = tempModel.type;
                CCActionMoveTo *actionMoveTo = [CCActionMoveTo actionWithDuration:.5 position:tempSprite.position];
                [tickMark runAction:actionMoveTo];
                
                tickMark.scale = 0.6f * screenRatioY;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hideTickMarker" object:nil userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:1.0] forKey:@"opacity"]];
                //[self addGlowEffect:tempSprite color:[CCColor colorWithRed:255 green:255 blue:0] size:CGSizeMake(tempSprite.contentSize.width, tempSprite.contentSize.height)];
            }
        }
    }
}

- (void) scaleit{
    for(int i =0 ; i < [componentArray count];i++){
        CCSprite *sprite = [componentArray objectAtIndex:i];
        sprite.scale = 1.8 * screenRatioY;
    }
}

- (void) update:(CCTime)delta{
    for (int i = 0; i < [componentArray count]; i++) {
        CCSprite *tempSprite =  [componentArray objectAtIndex:i];
        ComponentModel *tempModel = tempSprite.userObject;
        if(tempModel.count == 0){
            tempSprite.opacity = .3;
            tempModel.numberHolderSprite.opacity = 0.3f;
        }else{
            tempSprite.opacity = 1.0;
            tempModel.numberHolderSprite.opacity = 1.0f;
        }
    }
}

- (void) updateRemaingingCoins{
    for (int i = 0; i < [componentArray count]; i++) {
        CCSprite *tempSprite =  [componentArray objectAtIndex:i];
        ComponentModel *tempModel = tempSprite.userObject;
            
        if(tempModel.numberSprite){
            [tempModel.numberSprite removeFromParent];
        }
        [self drawNumber:tempModel];
        
    }
}

- (void) drawNumber:(ComponentModel*)model{
    int firstDigit = (model.count)/10;
    int secondDigit = (model.count)%10;
    CGPoint position = model.numberHolderSprite.position;
    
    CCSprite *firstDigitNumber;
    
    CCSprite *secondDigitSprite = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"%d.png",secondDigit]];
    secondDigitSprite.userObject = @"remove";
    [self addChild:secondDigitSprite];
    secondDigitSprite.scale = 1.5 * screenRatioY;
    model.numberSprite = secondDigitSprite;
    
    if(firstDigit >= 1){
        firstDigitNumber = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"%d.png",firstDigit]];
        firstDigitNumber.scale = 1.5 * screenRatioY;
        
        secondDigitSprite.position = ccp(position.x + firstDigitNumber.contentSize.width/2, position.y);
        firstDigitNumber.position = ccp(position.x - firstDigitNumber.contentSize.width/2, position.y);
        [self addChild:firstDigitNumber];
    }else{
        secondDigitSprite.position = position;
        
    }
}

- (void) addGlowEffect:(CCSprite*)sprite color:(CCColor*)color size:(CGSize)size{
    
    CGPoint pos = ccp(sprite.contentSize.width / 2,
                      
                      sprite.contentSize.height / 2);
    
    
    
    CCSprite* glowSprite = [CCSprite spriteWithSpriteFrame:sprite.spriteFrame];
    
    [glowSprite setColor:color];
    
    [glowSprite setPosition:pos];
    
    glowSprite.rotation = sprite.rotation;
    
    
    
    struct _ccBlendFunc f = {GL_ONE, GL_ONE};
    
    glowSprite.blendFunc = f;
    
    [sprite addChild:glowSprite z:-1];
    
    
    
    // Run some animation which scales a bit the glow
    
    CCActionSequence * s1 = [CCActionSequence actions:[CCActionScaleTo actionWithDuration:.9f scale:1.0],[CCActionScaleTo actionWithDuration:.9f scale:1.9], nil];
    
   /* CCSequence* s1 = CCSequence::actionOneTwo(
                                              
                                              CCScaleTo::actionWithDuration(0.9f, size.width, size.height),
                                              
                                              CCScaleTo::actionWithDuration(0.9f, size.width*0.75f, size.height*0.75f));*/
    
    CCActionRepeatForever *r = [CCActionRepeatForever actionWithAction:s1];
    [glowSprite runAction:r];
    
    
    /*
    CCRepeatForever* r = CCRepeatForever::actionWithAction(s1);
    
    glowSprite->runAction(r);*/
    
}

- (void) hideTickMarker:(NSNotification *) notification{
    NSDictionary *userInfo = notification.userInfo;
    tickMark.opacity = [[userInfo objectForKey:@"opacity"] floatValue];

}


@end
