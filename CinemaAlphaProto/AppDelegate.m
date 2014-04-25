//
//  AppDelegate.m
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 30/01/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UIApplication sharedApplication].idleTimerDisabled = YES; // prevent sleep mode
    
    [self adaptStoryboardForScreen];
    
    [ApiDelegate connect];
    [VideoController start];
    
    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [FBSession.activeSession setStateChangeHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         [FacebookConnectionManager sessionStateChanged:session state:state error:error];
     }];
    
    
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:FBSession.activeSession];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    if (![VideoController isPaused]) {
        [VideoController togglePlayPause];
    }
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (void)adaptStoryboardForScreen {
    // adapt storyboard if it is a 4-inch iPhone
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    UIViewController * vc;
    UINavigationController *nav;
    UIStoryboard *sb;
    
    NSLog(@"%f", screenBounds.size.height);
    
    // 4-inch iphone
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone
        && screenBounds.size.height > 480) {
        
        sb = [UIStoryboard storyboardWithName:@"Main_iPhone_large" bundle:nil];
        vc = [sb instantiateViewControllerWithIdentifier:@"EntryPointViewLarge"];
    }
    
    // classic iphone
    else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone
          && screenBounds.size.height <= 480) {
        
        sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        vc = [sb instantiateViewControllerWithIdentifier:@"EntryPointView"];
    }
    
    // ipad
    else {
        sb = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        vc = [sb instantiateViewControllerWithIdentifier:@"EntryPointView"];
    }
    
    
    nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self.window setRootViewController:nav];
    
}


@end
