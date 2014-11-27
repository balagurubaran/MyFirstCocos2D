//
//  ComponentHolder.h
//  MyFirstCocos2D
//
//  Created by Balagurubaran on 01/08/2014.
//  Copyright (c) 2014 First. All rights reserved.
//

#import "CCScene.h"
#import "cocos2d.h"


@interface ComponentHolder : CCScene{

}

// -----------------------------------------------------------------------
+ (ComponentHolder *)scene;
- (void) updateRemaingingCoins;
- (void) hideTickMarker:(NSDictionary *) notification;

@end
