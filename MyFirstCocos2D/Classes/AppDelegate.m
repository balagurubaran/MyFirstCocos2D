//
//  AppDelegate.m
//  MyFirstCocos2D
//
//  Created by Balagurubaran on 29/07/2014.
//  Copyright First 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "AppDelegate.h"
#import "MainMeu.h"
#import "InAppHandler.h"

@implementation AppDelegate

// 
-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// This is the only app delegate method you need to implement when inheriting from CCAppDelegate.
	// This method is a good place to add one time setup code that only runs when your app is first launched.
	
	// Setup Cocos2D with reasonable defaults for everything.
	// There are a number of simple options you can change.
	// If you want more flexibility, you can configure Cocos2D yourself instead of calling setupCocos2dWithOptions:.
	[self setupCocos2dWithOptions:@{
		// Show the FPS and draw call label.
		CCSetupShowDebugStats: @(NO),
		
		// More examples of options you might want to fiddle with:
		// (See CCAppDelegate.h for more information)
		
		// Use a 16 bit color buffer: 
//		CCSetupPixelFormat: kEAGLColorFormatRGB565,
		// Use a simplified coordinate system that is shared across devices.
//		CCSetupScreenMode: CCScreenModeFixed,
		// Run in portrait mode.
//		CCSetupScreenOrientation: CCScreenOrientationPortrait,
		// Run at a reduced framerate.
//		CCSetupAnimationInterval: @(1.0/30.0),
		// Run the fixed timestep extra fast.
//		CCSetupFixedUpdateInterval: @(1.0/180.0),
		// Make iPad's act like they run at a 2x content scale. (iPad retina 4x)
//		CCSetupTabletScale2X: @(YES),
	}];
	//[self createAdmobAds];
    
    static dispatch_once_t once;
    static InAppHandler * inAppHelper;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"iapps061",
                                      nil];
        inAppHelper = [[InAppHandler alloc] initWithProductIdentifiers:productIdentifiers];
        
        
        [inAppHelper requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            if (success) {
                NSLog(@"Removed");
            }
        }];
        
    });
    
    
    
	return YES;
}

-(CCScene *)startScene
{
	// This method should return the very first scene to be run when your app starts.
	return [MainMeu scene];
}


-(void)createAdmobAds
{
    mBannerType = BANNER_TYPE;
    
    if(mBannerType <= kBanner_Portrait_Bottom)
        mBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    else
        mBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerLandscape];
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    
    mBannerView.adUnitID = ADMOB_BANNER_UNIT_ID;
    
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    
    mBannerView.rootViewController = self.navController;
    [self.navController.view addSubview:mBannerView];
    
    #ifdef DEBUG
        GADRequest *request = [GADRequest request];
        request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID, nil];
    #endif
    
    
    // Initiate a generic request to load it with an ad.
    [mBannerView loadRequest:[GADRequest request]];
    
    CGSize s = [[CCDirector sharedDirector] viewSize];
    
    CGRect frame = mBannerView.frame;
    
    off_x = 0.0f;
    on_x = 0.0f;
    
    switch (mBannerType)
    {
        case kBanner_Portrait_Top:
        {
            off_y = -frame.size.height;
            on_y = 0.0f;
        }
            break;
        case kBanner_Portrait_Bottom:
        {
            off_y = s.height;
            on_y = s.height-frame.size.height;
        }
            break;
        case kBanner_Landscape_Top:
        {
            off_y = -frame.size.height;
            on_y = 0.0f;
        }
            break;
        case kBanner_Landscape_Bottom:
        {
            off_y = s.height;
            on_y = s.height-frame.size.height;
        }
            break;
            
        default:
            break;
    }
    
    frame.origin.y = off_y;
    frame.origin.x = off_x;
    
    mBannerView.frame = frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    frame = mBannerView.frame;
    frame.origin.x = on_x;
    frame.origin.y = on_y;
    
    
    mBannerView.frame = frame;
    [UIView commitAnimations];
}


-(void)showBannerView
{
    return;
    if (mBannerView)
    {
        //banner on bottom
        {
            CGRect frame = mBannerView.frame;
            frame.origin.y = off_y;
            frame.origin.x = on_x;
            mBannerView.frame = frame;
            
            
            [UIView animateWithDuration:0.5
                                  delay:0.1
                                options: UIViewAnimationCurveEaseOut
                             animations:^
             {
                 CGRect frame = mBannerView.frame;
                 frame.origin.y = on_y;
                 frame.origin.x = on_x;
                 
                 mBannerView.frame = frame;
             }
                             completion:^(BOOL finished)
             {
             }];
        }
        //Banner on top
        //        {
        //            CGRect frame = mBannerView.frame;
        //            frame.origin.y = -frame.size.height;
        //            frame.origin.x = off_x;
        //            mBannerView.frame = frame;
        //
        //            [UIView animateWithDuration:0.5
        //                                  delay:0.1
        //                                options: UIViewAnimationCurveEaseOut
        //                             animations:^
        //             {
        //                 CGRect frame = mBannerView.frame;
        //                 frame.origin.y = 0.0f;
        //                 frame.origin.x = off_x;
        //                 mBannerView.frame = frame;
        //             }
        //                             completion:^(BOOL finished)
        //             {
        //                 
        //                 
        //             }];
        //        }
        
    }
    
}

@end
