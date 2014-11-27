//
//  AppDelegate.h
//  MyFirstCocos2D
//
//  Created by Balagurubaran on 29/07/2014.
//  Copyright First 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "cocos2d.h"

#define ADMOB_BANNER_UNIT_ID  @"a1526f946910af0";
#define DEBUG 1

#import "GADBannerView.h"
typedef enum _bannerType
{
    kBanner_Portrait_Top,
    kBanner_Portrait_Bottom,
    kBanner_Landscape_Top,
    kBanner_Landscape_Bottom,
}CocosBannerType;

#define BANNER_TYPE kBanner_Landscape_Bottom

@interface AppDelegate : CCAppDelegate{
    CocosBannerType mBannerType;
    GADBannerView *mBannerView;
    float on_x, on_y, off_x, off_y;
}
-(void)hideBannerView;
-(void)showBannerView;
@end
