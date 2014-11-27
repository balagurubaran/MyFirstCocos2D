//
//  GameLogic.h
//  MyFirstCocos2D
//
//  Created by Balagurubaran on 31/07/2014.
//  Copyright (c) 2014 First. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCScene.h"

@interface GameLogic : NSObject{
    int currentPosition;
}

+ (id) gameLogicSharedInstance;
- (BOOL) blockBasedOnComponent:(int)chessObject position:(int)index;
- (void) placeChessComponent:(CCScene*)scene;
- (void) checkMate;
- (void) moveComponent:(CGPoint)position;
@end
