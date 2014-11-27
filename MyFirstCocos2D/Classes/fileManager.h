//
//  readFile.h
//  MyFirstCocos2D
//
//  Created by Balagurubaran on 05/08/2014.
//  Copyright (c) 2014 First. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCScene.h"

@interface fileManager : NSObject{
    
}
- (void) readFile:(NSString *)levelName;

- (NSDictionary*) readData:(NSString *)fileName;
- (void) storeDataToFile:(NSDictionary*)data fileName:(NSString *)name;
@end
