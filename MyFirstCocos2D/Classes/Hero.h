//
//  Hero.h
//  MyFirstCocos2D
//
//  Created by Balagurubaran on 07/08/2014.
//  Copyright (c) 2014 First. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hero : NSObject{
    
}

@property(nonatomic) int heroPosition;
@property(nonatomic) NSMutableArray *aroundTileStatus;
@property(nonatomic) NSMutableArray *aroundTileIndex;


+ (Hero *)sharedInstance;
@end
