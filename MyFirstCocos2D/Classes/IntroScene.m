//
//  IntroScene.m
//  MyFirstCocos2D
//
//  Created by Balagurubaran on 29/07/2014.
//  Copyright First 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "IntroScene.h"
#import "HelloWorldScene.h"
#import "GADBannerView.h"
#import "fileManager.h"
#import "MainMeu.h"
#import "Sound.h"

// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------

@implementation IntroScene

fileManager *fileMgr;

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (IntroScene *)scene
{
    
    
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    self.userInteractionEnabled = YES;
    // Add a sprite
    CCSprite *background = [CCSprite spriteWithImageNamed:@"background.jpeg"];
    background.position  = ccp(self.contentSize.width/2,self.contentSize.height/2);
    [self addChild:background];
    
    fileMgr = [[fileManager alloc] init];
    [self readSettings];
    menuContent = [[NSMutableArray alloc] init];
    [self drawMenu];
    CCSprite *sprite = [CCSprite spriteWithImageNamed:@"Back.png"];
    
    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"" spriteFrame:sprite.spriteFrame];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.81f, .95f);
    backButton.scale = .75 * screenRatioY ;
    [backButton setTarget:self selector:@selector(backPressed)];
    [self addChild:backButton];
    
    // done
	return self;
}

- (void) drawMenu{
    int nextRow = 0;
    int nextColumn = 0;
    for(int i = 0 ;i < 24; i++){
        
        CCSprite *menuIcon;
        
        if(i < unlockedLevel){
            menuIcon = [CCSprite spriteWithImageNamed:@"Blank.png"];
            menuIcon.position  = ccp(160*screenRatioX + (nextColumn*140*screenRatioX),(self.contentSize.height - 150*screenRatioY)-(nextRow*140*screenRatioY));
            [self addChild:menuIcon];
            [self drawNumber:menuIcon.position level:i];
        }else{
            menuIcon = [CCSprite spriteWithImageNamed:@"Level-Locked.png"];
            menuIcon.position  = ccp(160*screenRatioX + (nextColumn*140*screenRatioX),(self.contentSize.height - 150*screenRatioY)-(nextRow*140*screenRatioY));
            [self addChild:menuIcon];
        }
        menuIcon.scale = screenRatioY;
        menuIcon.userObject = [NSString stringWithFormat:@"%d",i];
        
        
        [menuContent addObject:menuIcon];
        nextColumn++;
        if(nextColumn % 6 == 0 && i != 0){
            nextRow++;
            nextColumn = 0;
        }
    }
}

- (void) readSettings{
    NSDictionary *settingContent = [fileMgr readData:@"settings.json"];
    if(settingContent && [settingContent objectForKey:@"Error"]){
        unlockedLevel = 1;
    }else{
        unlockedLevel = [[settingContent objectForKey:@"unlocked"] intValue];
        if(DEMO){
            unlockedLevel = 20;
        }
    }
}

- (void) drawNumber:(CGPoint)position level:(int)level{
    int firstDigit = (level + 1)/10;
    int secondDigit = (level + 1)%10;
    CCSprite *firstDigitNumber;
    
    CCSprite *secondDigitSprite = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"%d.png",secondDigit]];
    [self addChild:secondDigitSprite];
    secondDigitSprite.userObject = [NSString stringWithFormat:@"%d",level];
    secondDigitSprite.scale = 1.5 * screenRatioY;
    [menuContent addObject:secondDigitSprite];
    
    if(firstDigit >= 1){
        firstDigitNumber = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"%d.png",firstDigit]];
        [self addChild:firstDigitNumber];
        firstDigitNumber.userObject = [NSString stringWithFormat:@"%d",level];
        firstDigitNumber.scale = 1.5 * screenRatioY;
        [menuContent addObject:firstDigitNumber];
        
        secondDigitSprite.position = ccp(position.x + firstDigitNumber.contentSize.width/2, position.y);
        firstDigitNumber.position = ccp(position.x - firstDigitNumber.contentSize.width/2, position.y);

    }else{
        secondDigitSprite.position = position;
    }
}

- (void)backPressed
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[MainMeu scene]];
    [[Sound sharedInstance] playClickSound];
}


// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];
    
    for (int i = 0; i < [menuContent count]; i++) {
        if (CGRectContainsPoint( [[menuContent objectAtIndex:i]  boundingBox], touchLoc)) {
            CCSprite *tempMenuIcon = [menuContent objectAtIndex:i];
            if([tempMenuIcon.userObject intValue] < unlockedLevel){
                selectedLevel = [tempMenuIcon.userObject intValue] + 1;
                [[CCDirector sharedDirector] replaceScene:[HelloWorldScene scene]];
                [[Sound sharedInstance] playClickSound];//change to wood knoking sound
                return;
            }
        }
    }
}


// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInteractionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
    
}

// -----------------------------------------------------------------------

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onSpinningClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[HelloWorldScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

// -----------------------------------------------------------------------
@end
