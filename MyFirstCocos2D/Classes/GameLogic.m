//
//  GameLogic.m
//  MyFirstCocos2D
//
//  Created by Balagurubaran on 31/07/2014.
//  Copyright (c) 2014 First. All rights reserved.
//

#import "GameLogic.h"
#import "CCSprite.h"
#import "TileData.h"
#import "ComponentModel.h"
#import "Hero.h"


@implementation GameLogic{
    CCSprite *selectedSprite;
    BOOL isPlaced;
    Hero *hero;
}

static GameLogic *sharedInstance;


+ (id) gameLogicSharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sharedInstance == NULL){
            sharedInstance = [[super allocWithZone:NULL] init];
            sharedInstance->hero = [Hero sharedInstance];
        }
    });
    return sharedInstance;
}

/*
- (id) init{
    self = [super init];
    if (!self) return(nil);
    isPlaced = NO;
    //aroundKingsPosition = [[NSMutableArray alloc] init];
    hero = [Hero sharedInstance];
    
    return self;
}
 */

- (BOOL) blockBasedOnComponent:(int)chessObject position:(int) index{
    isPlaced = YES;
     currentPosition = index;
    if(selectedComponent == BISHOP){
        
        if(![self checkAvailability]){
            /*UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Bishop is already place in same color" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    
            
           [alertView show];*/
            isPlaced = NO;
            return isPlaced;
        }
        
    }
   
    
    CCSprite *tempSprite = [tileArray objectAtIndex:currentPosition];
    TileData *tempTileData = tempSprite.userObject;
    tempTileData.tileContent = chessObject;
    selectedSprite = NULL;
    
    if(chessObject == PAWN){
        selectedSprite = [CCSprite spriteWithImageNamed:@"pawn_black-hd.png"];
        [self blockPawntype];
    }else if(chessObject == QUEEN){
        selectedSprite = [CCSprite spriteWithImageNamed:@"queen_black-hd.png"];
        [self queenMove];
    }else if(chessObject == BISHOP){
        selectedSprite = [CCSprite spriteWithImageNamed:@"bishop_black-hd.png"];
        [self bishopMove];
    }else if(chessObject == ROOK){
        selectedSprite = [CCSprite spriteWithImageNamed:@"rook_black-hd.png"];
        [self blockVeri_HoriMove];
    }else if(chessObject == KING){
        selectedSprite = [CCSprite spriteWithImageNamed:@"king_black-hd.png"];
        [self kingMove];
    }else if(chessObject == KNIGHT){
        selectedSprite = [CCSprite spriteWithImageNamed:@"knight_black-hd.png"];
        [self blockKnightMove];
    }
    
     tempTileData.addedSprite = selectedSprite;
    
    return isPlaced;
}

- (void) kingMove{
    [self blockPawntype];
    [self blockNeighbours];
}

- (void) queenMove{
    [self blockDiagonalMove];
    [self blockVeri_HoriMove];
}

- (void) bishopMove{
    [self blockDiagonalMove];
}

- (void) blockVeri_HoriMove{
    float divide = currentPosition%COLUMNS;
    
    for(int i = 0 ; i <= divide;i++){
        if(currentPosition - i >= 0 && currentPosition != currentPosition - i){
            [self blockTile:currentPosition - i];
        }
        
    }
    
    for(int i = 0 ; i < COLUMNS - divide;i++){
        if(currentPosition + i < ROWS*COLUMNS && currentPosition != currentPosition + i){
            [self blockTile:currentPosition + i];
        }
    }

    divide = currentPosition/COLUMNS;
    
    for(int i = 0 ; i <= divide;i++){
        if(currentPosition - i*ROWS >= 0 && currentPosition != currentPosition - i*ROWS){
            [self blockTile:currentPosition - i*ROWS];
        }
        
    }
    
    for(int i = 0 ; i < COLUMNS - divide;i++){
        if(currentPosition + i*ROWS < ROWS*COLUMNS && currentPosition != currentPosition + i*ROWS){
            [self blockTile:currentPosition + i*ROWS];
        }
    }
}

- (void) blockDiagonalMove{
    float divide = currentPosition%COLUMNS;
    
    
    for(int i = 0 ; i <= divide;i++){
        if(currentPosition - (ROWS+1)*i >= 0 && currentPosition != currentPosition - (ROWS+1)*i){
          [self blockTile:currentPosition - (ROWS+1)*i];
        }
        
    }
    
    for(int i = 0 ; i < COLUMNS - divide;i++){
        if(currentPosition + (ROWS+1)*i < ROWS*COLUMNS && currentPosition != currentPosition + (ROWS+1)*i){
            [self blockTile:currentPosition + (ROWS+1)*i];
        }
    }
    
    for(int i = 0 ; i <= divide;i++){
        if(currentPosition + (ROWS-1)*i < ROWS*COLUMNS && currentPosition != currentPosition + (ROWS-1)*i){
           [self blockTile:currentPosition + (ROWS-1)*i];
        }
    }
    
    for(int i = 0 ; i < COLUMNS - divide;i++){
        if(currentPosition - (ROWS-1)*i > 0 && currentPosition != currentPosition - (ROWS-1)*i){
            [self blockTile:currentPosition - (ROWS-1)*i];
        }
    }
}

- (void) blockPawntype{
    if(currentPosition-ROWS-1 > 0)
        [self blockTile:currentPosition-ROWS-1];
    
    if(currentPosition-ROWS+1 > 0)
        [self blockTile:currentPosition-ROWS+1];
    
    if(currentPosition+ROWS-1 < 64)
        [self blockTile:currentPosition+ROWS-1];
    
    if(currentPosition+ROWS+1 < 64)
        [self blockTile:currentPosition+ROWS+1];
}

- (void) blockNeighbours{
    if(currentPosition+1 < 64)
        [self blockTile:currentPosition+1];
    if(currentPosition-1 > 0)
        [self blockTile:currentPosition-1];
    if(currentPosition+ROWS < 64)
        [self blockTile:currentPosition+ROWS];
    if(currentPosition-ROWS > 0)
        [self blockTile:currentPosition-ROWS];
}

- (void) blockKnightMove{
    int rowIndex = 2;
    for(int i = 1 ; i <= 2;i++){
        if(currentPosition - i > 0){
            if((currentPosition - i) + (rowIndex*ROWS) > 0 && (currentPosition - i) + (rowIndex*ROWS) < 64){
                [self blockTile:(currentPosition - i) + (rowIndex*ROWS)];
            }
            
            if((currentPosition - i) - (rowIndex*ROWS) > 0 && (currentPosition - i) - (rowIndex*ROWS) < 64){
                [self blockTile:(currentPosition - i) - (rowIndex*ROWS)];
            }
            
            rowIndex--;
        }
    }
    
    
    rowIndex = 2;
    for(int i = 1 ; i <= 2;i++){
        if(currentPosition + i < 64){
            if((currentPosition + i) + (rowIndex*ROWS) > 0 && (currentPosition + i) + (rowIndex*ROWS) < 64){
                [self blockTile:(currentPosition + i) + (rowIndex*ROWS)];
            }
            
            if((currentPosition + i) - (rowIndex*ROWS) > 0 && (currentPosition + i) - (rowIndex*ROWS) < 64){
                [self blockTile:(currentPosition + i) - (rowIndex*ROWS)];
            }
            rowIndex--;
        }
    }

}

- (void) placeChessComponent:(CCScene*)scene{

    selectedSprite.position =  ((CCSprite*)[tileArray objectAtIndex:currentPosition]).position;;
    selectedSprite.scale = .4 * screenRatioY;
    [scene addChild:selectedSprite];
    
    for (int i = 0; i < [componentArray count]; i++) {
        CCSprite *tempSprite =  [componentArray objectAtIndex:i];
        ComponentModel *tempModel = tempSprite.userObject;
        tempModel.isSelected = NO;
        if(tempModel.count > 0 && tempModel.type == selectedComponent){
            tempModel.count--;
            if(tempModel.count == 0){
                tempModel.isSelected = NO;
                selectedComponent = DESELECTED;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hideTickMarker" object:nil userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:0] forKey:@"opacity"]];
            }
        }
    }
}

-(BOOL) checkAvailability{
    BOOL isAvail = YES;
    
    CCSprite *selectedTile = [tileArray objectAtIndex:currentPosition];
    TileData *selectedTileData = selectedTile.userObject;
    
    for (int i = 0; i < [tileArray count]; i++) {
        CCSprite *tempSprite =  [tileArray objectAtIndex:i];
        TileData *tempModel = tempSprite.userObject;
        if(tempModel.tileContent == BISHOP && [tempModel.tileColor isEqualToString:selectedTileData.tileColor ]){
            isAvail = NO;
        }
    }
    return isAvail;
}

- (void) blockTile:(int) index{
    CCSprite *tempSprite = [tileArray objectAtIndex:index];
    TileData *tempTileData = tempSprite.userObject;
    if(tempTileData.tileContent != KING_O){
        tempTileData.tileContent = BLOCKED;
        tempTileData.blockedCount++;
    }
    
}

- (void) checkMate{
    
    [hero.aroundTileStatus removeAllObjects];
    [hero.aroundTileIndex removeAllObjects];
    
    if(heroIndex + 1 < 64 && heroIndex/8 == (heroIndex + 1)/8){
        [hero.aroundTileStatus addObject:[NSNumber numberWithInt:[self getTileContent:heroIndex + 1]]];
        
        int newIndex = (heroIndex+1)+8;
        if(newIndex < 64)
            [hero.aroundTileStatus addObject:[NSNumber numberWithInt:[self getTileContent:newIndex]]];
        
        newIndex = (heroIndex+1)-8;
        
        if(newIndex > 0)
            [hero.aroundTileStatus addObject:[NSNumber numberWithInt:[self getTileContent:newIndex]]];
    }
    
    if(heroIndex - 1 > 0 && heroIndex/8 == (heroIndex - 1)/8){
        [hero.aroundTileStatus addObject:[NSNumber numberWithInt:[self getTileContent:heroIndex - 1]]];
        
        int newIndex = (heroIndex-1)+8;
        if(newIndex < 64)
            [hero.aroundTileStatus addObject:[NSNumber numberWithInt:[self getTileContent:newIndex]]];
        
        newIndex = (heroIndex-1)-8;
        
        if(newIndex > 0)
            [hero.aroundTileStatus addObject:[NSNumber numberWithInt:[self getTileContent:newIndex]]];
        
    }
    
    if(heroIndex - 8 > 0){
        [hero.aroundTileStatus addObject:[NSNumber numberWithInt:[self getTileContent:heroIndex - 8]]];
    }
    
    if(heroIndex + 8 < 64){
        [hero.aroundTileStatus addObject:[NSNumber numberWithInt:[self getTileContent:heroIndex + 8]]];
    }
    

    isCheckMate = YES;
}

- (int) getTileContent:(int)index{
    [hero.aroundTileIndex addObject:[NSNumber numberWithInt:index]];
    CCSprite *tempSprite = [tileArray objectAtIndex:index];
    TileData *tempTileData = tempSprite.userObject;
    return tempTileData.blockedCount;
    
}
@end
