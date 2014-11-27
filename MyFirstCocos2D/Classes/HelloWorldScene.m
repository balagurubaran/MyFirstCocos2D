//
//  HelloWorldScene.m
//  MyFirstCocos2D
//
//  Created by Balagurubaran on 29/07/2014.
//  Copyright First 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "HelloWorldScene.h"
#import "IntroScene.h"
#import "GCCShapeCache.h"
#import  "TileData.h"
#import  "GameLogic.h"
#import  "ComponentHolder.h"
#import "fileManager.h"
#import "Hero.h"
#import "AppDelegate.h"
#import "Sound.h"

// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

@implementation HelloWorldScene
{
    CCSprite *_sprite;
    CCPhysicsNode *_physicsWorld;
    
    GameLogic      *gameLogic;
    fileManager   *fManager;
    CCSprite *hero_Sprite;
    CCSprite *levelEndScreen;
    CCNodeColor *levelEndBGScreen;
    CCLabelTTF* levelStatus;
    
    BOOL islevelFailed;
    
    ComponentHolder *cmpHolder;
    CCLabelTTF *errorLbl;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (HelloWorldScene *)scene
{
    return [[self alloc] init];
}


- (void)spawnSprite:(NSString *)name atPos:(CGPoint)pos index:(int)index
{
    CCSprite *sprite = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"%@.png", name]];
    sprite.position = pos;
    sprite.scale = TILESIZE * .02 * screenRatioY;
    
    TileData *tile = [[TileData alloc] init];
    tile.index = index;
    tile.tileContent = EMPTY;
    tile.tileColor = name;//(white or black)
    tile.addedSprite = NULL;
    sprite.userObject = tile;
    
    [tileArray addObject:sprite];
    
    [self addChild:sprite];
}

// -----------------------------------------------------------------------

- (id)init
{
    
    
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self)
        return(nil);
    
    fManager = [[fileManager alloc] init];

    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    // Add a sprite
    _sprite = [CCSprite spriteWithImageNamed:@"background.jpeg"];
    _sprite.position  = ccp(self.contentSize.width/2,self.contentSize.height/2);
    [self addChild:_sprite];
    
    // Setup physics world
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,-900);
    //_physicsWorld.debugDraw = YES;
    //[self addChild:_physicsWorld];
    
    // Load shapes
    [[GCCShapeCache sharedShapeCache] addShapesWithFile:@"Shapes.plist"];
    
    tileArray = [[NSMutableArray alloc] init];
    int StatingPosition = 90;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
    {
        StatingPosition = 180;
        if(UIScreenOverscanCompensationScale == 1136/640){
            
        }
    }
    
    int index = 0;
    for(int row = 0 ; row < ROWS; row++){
        for(int column = 0 ; column < COLUMNS; column++){
            
            if(row %2 == 0 ){
                if(column %2 != 0){
                    [self spawnSprite:@"white" atPos:ccp((StatingPosition + (row*TILESIZE)) * screenRatioY,(140 +(column*TILESIZE)) * screenRatioY) index:index];
                }else
                    [self spawnSprite:@"brown" atPos:ccp((StatingPosition + (row*TILESIZE)) * screenRatioY,(140 +(column*TILESIZE)) * screenRatioY) index:index];
            }else{
                if(column %2 == 0){
                    [self spawnSprite:@"white" atPos:ccp((StatingPosition + (row*TILESIZE)) * screenRatioY,(140 +(column*TILESIZE)) * screenRatioY) index:index];
                }else
                    [self spawnSprite:@"brown" atPos:ccp((StatingPosition + (row*TILESIZE)) * screenRatioY,(140 +(column*TILESIZE)) * screenRatioY) index:index];
            }
            index++;
        }
    }
    
    CCSprite *boardBg = [CCSprite spriteWithImageNamed:@"frame.png"];
    CCSprite *_tempSprite = ((CCSprite*)[tileArray objectAtIndex:28]);
    CGPoint pos = _tempSprite.position;
    float scale = TILESIZE * .02 * screenRatioY;
    
    boardBg.position  = ccp(pos.x + (_tempSprite.contentSize.width*scale)/2,pos.y - (_tempSprite.contentSize.height*scale)/2);
    boardBg.scale = TILESIZE * .02 * screenRatioY;
    [self addChild:boardBg];
    
    
    [self initInsideGameMenu];
    
    [self resetGame];
    
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [app showBannerView];
    
    return self;
}

- (void) initInsideGameMenu{
    gameLogic = [GameLogic gameLogicSharedInstance];
    
    
    CCSprite *sprite = [CCSprite spriteWithImageNamed:@"Checkmate.png"];
    
    // Create a back button
    CCButton *checkButton = [CCButton buttonWithTitle:@"" spriteFrame:sprite.spriteFrame];
    checkButton.positionType = CCPositionTypeNormalized;
    checkButton.position = ccp(0.65f, .80f);
    checkButton.scale = .76 * screenRatioY;
    [checkButton setTarget:self selector:@selector(checkMate)];
    [self addChild:checkButton];
    
    sprite = [CCSprite spriteWithImageNamed:@"Reset1.png"];
    CCButton *resetButton = [CCButton buttonWithTitle:@"" spriteFrame:sprite.spriteFrame];
    resetButton.positionType = CCPositionTypeNormalized;
    resetButton.position = ccp(0.89f, .80f);
    resetButton.scale = .76 * screenRatioY;
    [resetButton setTarget:self selector:@selector(resetGame)];
    [self addChild:resetButton];
    
    sprite = [CCSprite spriteWithImageNamed:@"Back.png"];
    
    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"" spriteFrame:sprite.spriteFrame];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.79f, .93f);
    backButton.scale = .76 * screenRatioY ;
    [backButton setTarget:self selector:@selector(backPressed)];
    [self addChild:backButton];

    
    backButton.position = ccp(0.80f, .87f);
    resetButton.position = ccp(0.80f, .77f);
    checkButton.position = ccp(0.80f, .67f);
    
    cmpHolder = [ComponentHolder scene];
    
    [self addChild:cmpHolder];
    
    levelEndScreen = [CCSprite spriteWithImageNamed:@"menu.png"];
    levelEndScreen.position = ccp(self.contentSize.width/2,self.contentSize.height/2);
    //levelEndScreen.scale = screenRatioY;
    levelEndBGScreen = [CCNodeColor nodeWithColor:[CCColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:.5f]];
    levelEndBGScreen.position = ccp(0,0);
    
    [self initErrorLabel];
    // done
    
}

- (void) resetGame{
    
    [levelEndBGScreen removeFromParent];
    [levelEndScreen removeFromParent];
    [levelStatus removeFromParent];
    
    [hero_Sprite removeFromParent];
    for(int i = 0; i < [tileArray count];i++){
        CCSprite *tempSprite = [tileArray objectAtIndex:i];
        TileData *tempTileData = tempSprite.userObject;
        [tempTileData.addedSprite removeFromParent];
        tempTileData.tileContent = EMPTY;
        tempTileData.blockedCount = 0;
        tempTileData.addedSprite = NULL;
        //tempTileData = NULL;
    }
    [self loadLevel:selectedLevel];
    [self placeHero:heroIndex];
    [cmpHolder updateRemaingingCoins];
    
    selectedComponent = DESELECTED;
    
    [[Sound sharedInstance] playClickSound];
}

- (void) loadLevel:(int)levelNumber{
    NSString *fileName = [NSString stringWithFormat:@"level%d",levelNumber];
    [fManager readFile:fileName];
}

- (void) placeHero:(int)index{
    
    hero_Sprite = [CCSprite spriteWithImageNamed:@"king_white-hd.png"];
    hero_Sprite.position =  ((CCSprite*)[tileArray objectAtIndex:index]).position;
    hero_Sprite.scale = .4 * screenRatioY;
    
    CCSprite *tempSprite = [tileArray objectAtIndex:index];
    TileData *tempTileData = tempSprite.userObject;
    tempTileData.tileContent = KING_O;
    
    [self addChild:hero_Sprite];
}


// -----------------------------------------------------------------------

- (void)dealloc
{
    // clean up code goes here
}

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
}

// -----------------------------------------------------------------------

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];
    
    // Log touch location
    //CCLOG(@"Move sprite to @ %@",NSStringFromCGPoint(touchLoc));
    
    for (int i = 0; i < [tileArray count]; i++) {
        if (CGRectContainsPoint( [[tileArray objectAtIndex:i]  boundingBox], touchLoc)) {
            
            CCSprite *tempSprite = [tileArray objectAtIndex:i];
            TileData *tempTileData = tempSprite.userObject;
            if((tempTileData.tileContent == EMPTY || tempTileData.tileContent == BLOCKED) && selectedComponent != DESELECTED){

                if([gameLogic blockBasedOnComponent:selectedComponent position:tempTileData.index]){
                    [gameLogic placeChessComponent:self];
                    [cmpHolder updateRemaingingCoins];
                }
            }
        }
    }
}

- (void) update:(CCTime)delta{
    
    if(isCheckMate){
        [self checkHeroPosition];
        isCheckMate = NO;
    }
    
   // errorLbl.string = errorMsg;
}

- (void) checkHeroPosition{
    Hero *hero = [Hero sharedInstance];
    islevelFailed = NO;
    for(int i = 0; i < [hero.aroundTileStatus count]; i++){
        //NSLog(@"%ld",(long)[[hero.aroundTileStatus objectAtIndex:i] integerValue]);
        if([[hero.aroundTileStatus objectAtIndex:i] integerValue] == 0){
            int index = (int)[[hero.aroundTileIndex objectAtIndex:i] integerValue];
            
            CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:1.0f position:((CCSprite*)[tileArray objectAtIndex:index]).position];
            [hero_Sprite runAction:actionMove];
            
            if(index > 0 && index < 64){
                CCSprite *cutChesscomponent = [tileArray objectAtIndex:index];
                TileData *tempTileData = cutChesscomponent.userObject;
                if(tempTileData.addedSprite){
                    CCActionScaleTo *actionScale = [CCActionScaleTo actionWithDuration:1.0 scale:0];
                    [tempTileData.addedSprite runAction:actionScale];
                }
            }
            islevelFailed = YES;
            
            [self performSelector:@selector(levelFailedScreen) withObject:nil afterDelay:2.0];
            return;
        }
    }
    if(unlockedLevel == selectedLevel){
        unlockedLevel++;
        [self storeSettings];
    }
    
   [self levelFailedScreen];
    
}

- (void)levelFailedScreen{
    [self addChild:levelEndBGScreen];
    [self addChild:levelEndScreen];
    
    if(islevelFailed){
        levelStatus =[[CCLabelTTF alloc] initWithString:@"Level Failed" fontName:@"TrebuchetMS-Bold" fontSize:36.0f/screenRatioY];
        //  CCLabelTTF::create("Hello World", "Helvetica", 12,CCSizeMake(245, 32), kCCTextAlignmentCenter);
        [levelEndScreen addChild:levelStatus];
        
        
        levelStatus.positionType = CCPositionTypeNormalized;
        levelStatus.position = ccp(.5,.7);
        levelStatus.scale *= screenRatioY;
        
        CCSprite *sprite = [CCSprite spriteWithImageNamed:@"Reset.png"];
        CCButton *resetButton = [CCButton buttonWithTitle:@"" spriteFrame:sprite.spriteFrame];
        resetButton.positionType = CCPositionTypeNormalized;
        resetButton.position = ccp(0.5f, .5f);
        //resetButton.scale *= screenRatioY;
        [resetButton setTarget:self selector:@selector(resetGame)];
        [levelEndScreen addChild:resetButton];
        
        sprite = [CCSprite spriteWithImageNamed:@"Menu1.png"];
        
        // Create a back button
        CCButton *backButton = [CCButton buttonWithTitle:@"" spriteFrame:sprite.spriteFrame];
        backButton.positionType = CCPositionTypeNormalized;
        backButton.position = ccp(0.5f, .3f);
        //backButton.scale *= screenRatioY;
        [backButton setTarget:self selector:@selector(backPressed)];
        [levelEndScreen addChild:backButton];
    }else{//sucess
        
        levelStatus =[[CCLabelTTF alloc] initWithString:@"Level Passed" fontName:@"TrebuchetMS-Bold" fontSize:36.0f/screenRatioY];
        //  CCLabelTTF::create("Hello World", "Helvetica", 12,CCSizeMake(245, 32), kCCTextAlignmentCenter);
        [levelEndScreen addChild:levelStatus];

        levelStatus.positionType = CCPositionTypeNormalized;
        levelStatus.position = ccp(.5,.7);
        levelStatus.scale *= screenRatioY;
        
        CCSprite *sprite = [CCSprite spriteWithImageNamed:@"Nextlevel.png"];
        CCButton *NextlevelButton = [CCButton buttonWithTitle:@"" spriteFrame:sprite.spriteFrame];
        NextlevelButton.positionType = CCPositionTypeNormalized;
        NextlevelButton.position = ccp(0.5f, .5f);
        //NextlevelButton.scale *= screenRatioY;
        [NextlevelButton setTarget:self selector:@selector(Nextlevel)];
        if(selectedLevel != TOTALLEVELS){
            [levelEndScreen addChild:NextlevelButton];
        }
        
        sprite = [CCSprite spriteWithImageNamed:@"Menu1.png"];
        
        // Create a back button
        CCButton *menuButton = [CCButton buttonWithTitle:@"" spriteFrame:sprite.spriteFrame];
        menuButton.positionType = CCPositionTypeNormalized;
        menuButton.position = ccp(0.5f, .3f);
        [menuButton setTarget:self selector:@selector(backPressed)];
        //menuButton.scale *= screenRatioY;
        [levelEndScreen addChild:menuButton];
    }
}

- (void) initErrorLabel{
    errorLbl = [CCLabelTTF labelWithString:@"posiripjkndfih" fontName:@"" fontSize:18];
    errorLbl.position = ccp(self.contentSize.width - 300*screenRatioX,130*screenRatioY);
    
    //[self addChild:errorLbl];
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)checkMate
{
    [gameLogic checkMate];
    [[Sound sharedInstance] playClickSound];
}

- (void)backPressed {
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]];
     [self storeSettings];
    [[Sound sharedInstance] playClickSound];
}

- (void) Nextlevel {
    selectedLevel++;
    [self storeSettings];
    [self resetGame];
    [[Sound sharedInstance] playClickSound];
    
}

- (void) storeSettings {
    NSMutableDictionary *settingDic = [[NSMutableDictionary alloc] init];
    [settingDic setObject:[NSString stringWithFormat:@"%d",unlockedLevel] forKey:@"unlocked"];
    [fManager storeDataToFile:settingDic fileName:@"settings.json"];
}

// -----------------------------------------------------------------------
@end
