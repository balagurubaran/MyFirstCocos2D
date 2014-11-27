//
//  Sound.m
//  MyFirstCocos2D
//
//  Created by Balagurubaran on 13/08/2014.
//  Copyright (c) 2014 First. All rights reserved.
//

#import "Sound.h"


@implementation Sound{
    
}

static Sound *soundSharedInstance;

+ (id) sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (soundSharedInstance == NULL){
            soundSharedInstance = [[super allocWithZone:NULL] init];
            // access audio object
            soundSharedInstance->audioPlayer = [OALSimpleAudio sharedInstance];
            [soundSharedInstance->audioPlayer preloadEffect:CLICKSOUND];
        }
    });
    return soundSharedInstance;
}
                                        
- (void) playClickSound{
    [soundSharedInstance->audioPlayer playEffect:CLICKSOUND];
}

@end
