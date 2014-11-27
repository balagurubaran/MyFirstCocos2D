//
//  MainMeu.m
//  MyFirstCocos2D
//
//  Created by Balagurubaran on 11/08/2014.
//  Copyright (c) 2014 First. All rights reserved.
//

#import "MainMeu.h"
#import "IntroScene.h"
#import "AppDelegate.h"
#import "Sound.h"
#import "CCParticleSystem.h"

@implementation MainMeu{
    
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (MainMeu *)scene
{
	return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (!self)
        return(nil);

    
    screenRatioX = self.contentSize.width/1024;
    screenRatioY = self.contentSize.height/768;
    
    [self createMenu];
    
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    //[app showBannerView];
    
    return self;
}

- (void) createMenu{
    
    CCSprite *background = [CCSprite spriteWithImageNamed:@"background.jpeg"];
    background.position  = ccp(self.contentSize.width/2,self.contentSize.height/2);
    [self addChild:background];

    
    NSArray *menuImages = [NSArray arrayWithObjects:@"easy",@"medium",@"hard",nil];
    
    for(int i =0;i < [menuImages count];i++){
        CCSprite *sprite = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"%@.png",[menuImages objectAtIndex:i]]];
        
        // Create a back button
        CCButton *menuButton = [CCButton buttonWithTitle:@"" spriteFrame:sprite.spriteFrame];
        menuButton.positionType = CCPositionTypeNormalized;
        menuButton.position = ccp(0.25f +(i*.25),0.5f);
        menuButton.scale = .45 * screenRatioY;
        [menuButton  setUserObject: [menuImages objectAtIndex:i]];
        [menuButton setTarget:self selector:@selector(moveToLevelScreen:)];
        [self addChild:menuButton];
    }
    
    /*
    for(int i = 0; i < 20; i++){
        CCParticleExplosion *exp = [[CCParticleExplosion alloc] initWithTotalParticles:100];
        exp.gravity = CGPointMake(0, -50);
        
        float x = [self getRandomNumberBetween:0 to:self.contentSize.width];
        float y = [self getRandomNumberBetween:0 to:self.contentSize.height];
        exp.position = ccp(x,y);
        [exp setTexture:[CCTexture textureWithFile:@"numberHolder.png"]];
        exp.startColor = [CCColor colorWithRed:1.0f green:1.0f blue:0.0f];
        exp.endColor = [CCColor colorWithRed:1.0f green:1.0f blue:0.0f];
        exp.life = 1.0f;
        [self addChild:exp];
    }
    */
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);
}

- (void) moveToLevelScreen:(id)sender{
    [[Sound sharedInstance] playClickSound];
    
    CCButton *tempBtn = (CCButton*)sender;
    if([tempBtn.userObject isEqualToString:@"easy"])
        [[CCDirector sharedDirector] replaceScene:[IntroScene scene]];
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Levels are under construction" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
    }
}

@end
