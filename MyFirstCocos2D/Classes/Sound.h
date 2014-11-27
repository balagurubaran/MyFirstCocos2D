//
//  Sound.h
//  MyFirstCocos2D
//
//  Created by Balagurubaran on 13/08/2014.
//  Copyright (c) 2014 First. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectAL.h"

@interface Sound : NSObject{
    OALSimpleAudio *audioPlayer;

}

+ (id) sharedInstance;
- (void) playClickSound;

@end
