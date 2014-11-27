//
//  readFile.m
//  MyFirstCocos2D
//
//  Created by Balagurubaran on 05/08/2014.
//  Copyright (c) 2014 First. All rights reserved.
//

#import "fileManager.h"
#import "ComponentModel.h"
#import "cocos2d.h"
#import "TileData.h"

@implementation fileManager{
     NSError *error;
    NSFileManager *fileMgr;
    NSString *documentsDirectory;
}

- (id) init{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Create file manager
    fileMgr = [NSFileManager defaultManager];
    
    // Point to Document directory
     documentsDirectory = [NSHomeDirectory()
                                    stringByAppendingPathComponent:@"Documents"];
    
    return self;
}

- (void) readFile:(NSString *)levelName{
    NSError *error1 = NULL;
    NSString *filepath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",levelName] ofType:@"json"];
    NSString *helpDetail = [[NSString alloc] initWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error1];
    
    NSData* data = [helpDetail dataUsingEncoding: NSUTF8StringEncoding];
    
    error1 = NULL;
    if(data){
        NSDictionary *levelDataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error1];
        if (error)
            NSLog(@"JSONObjectWithData error: %@", error);
        else{
            BOOL isSet = YES;
            for(NSString *keys in [levelDataDic allKeys]){
                NSArray *tempEachComponentArray = [levelDataDic objectForKey:keys];
                if([keys isEqualToString:@"HERO"]){
                    heroIndex = [[tempEachComponentArray objectAtIndex:0] intValue];
                }
                int count         = [[tempEachComponentArray objectAtIndex:0] intValue];
                int componentType = [[tempEachComponentArray objectAtIndex:1] intValue];
                
                
                for(int  i = 0 ; i < [componentArray count];i++){
                    
                    CCSprite *tempSprite =  [componentArray objectAtIndex:i];
                    ComponentModel *tempModel = tempSprite.userObject;
                    if(tempModel.type == componentType){
                        tempModel.count = count;
                        if(count && isSet){
                            
                        }
                    }
                    
                }
                
                if([tempEachComponentArray count] > 2){
                    int type = [[tempEachComponentArray objectAtIndex:2] intValue];
                    for(int i = 3 ; i < [tempEachComponentArray count] ; i++){
                        CCSprite *tempSprite = [tileArray objectAtIndex:i];
                        TileData *tempTileData = tempSprite.userObject;
                        tempTileData.tileContent = type;
                        tempTileData.index = [[tempEachComponentArray objectAtIndex:i] intValue];
                    }
                    
                }
            }
        }
    }
}

- (void) storeDataToFile:(NSDictionary*)data fileName:(NSString *)name{
    NSString *filePath = [documentsDirectory
                          stringByAppendingPathComponent:name];
    [data writeToFile:filePath atomically:YES];
}

- (NSDictionary*) readData:(NSString *)fileName{
    
    
    NSMutableDictionary *fileContent;
    NSString *filePath = [documentsDirectory
                          stringByAppendingPathComponent:fileName];
    
    if([fileMgr fileExistsAtPath:filePath]){
        fileContent = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
    }else{
        fileContent = [[NSMutableDictionary alloc] init];
        [fileContent setValue:@"Error" forKey:@"Error"];
    }
    return fileContent;
}

@end
