//
//  Constant.h
//  MyFirstCocos2D
//
//  Created by Balagurubaran on 31/07/2014.
//  Copyright (c) 2014 First. All rights reserved.
//



#ifndef MyFirstCocos2D_Constant_h
#define MyFirstCocos2D_Constant_h

#define TILESIZE 75

#define EMPTY    100
#define BLOCKED  101

#define KING     1000
#define QUEEN    1001
#define ROOK     1002
#define KNIGHT   1003
#define BISHOP   1004
#define PAWN     1005



#define KING_O     3000
#define QUEEN_O    3001
#define BISHOP_O   3002
#define PAWN_O     3003
#define KNIGHT_O   3004
#define ROOK_O     3005

#define COLUMNS     8
#define ROWS        8

#define TOTALLEVELS 24
#define DESELECTED 2000

#define CLICKSOUND @"clicksound.mp3"

NSMutableArray *tileArray;
NSMutableArray *componentArray;
int             selectedComponent;
int             heroIndex;
BOOL            isCheckMate;
int             selectedLevel;
int             unlockedLevel;
NSString        *errorMsg;

float           screenRatioX;
float           screenRatioY;
#define         DEMO 1

#endif
