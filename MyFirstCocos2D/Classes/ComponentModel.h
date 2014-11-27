//
//  ComponentModel.h
//  MyFirstCocos2D
//
//  Created by Balagurubaran on 05/08/2014.
//  Copyright (c) 2014 First. All rights reserved.
//

#import "CCScene.h"
#import "cocos2d.h"

@interface ComponentModel : NSObject{
    
}

@property(nonatomic)int     count;
@property(nonatomic)BOOL    isSelected;
@property(nonatomic)int     type;
@property(nonatomic) CCSprite *numberHolderSprite;
@property(nonatomic) CCSprite *numberSprite;


@end
