//
//  Hero.m
//  MyFirstCocos2D
//
//  Created by Balagurubaran on 07/08/2014.
//  Copyright (c) 2014 First. All rights reserved.
//

#import "Hero.h"

@implementation Hero{
    
}
@synthesize heroPosition;
@synthesize aroundTileIndex;
@synthesize aroundTileStatus;

static Hero *sharedInstance = nil;

+ (Hero *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
        sharedInstance.aroundTileStatus = [[NSMutableArray alloc] init];
        sharedInstance.aroundTileIndex = [[NSMutableArray alloc] init];
    }
    
    return sharedInstance;
}

@end
