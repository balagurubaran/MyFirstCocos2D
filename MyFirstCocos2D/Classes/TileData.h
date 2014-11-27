//
//  TileData.h
//  MyFirstCocos2D
//
//  Created by Balagurubaran on 31/07/2014.
//  Copyright (c) 2014 First. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface TileData : NSObject{
    
}
@property(nonatomic) int tileContent;
@property(nonatomic) NSString *tileColor;
@property(nonatomic) int index;
@property(nonatomic) int blockedCount;
@property(nonatomic) CCSprite *addedSprite;



@end
