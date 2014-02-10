//
//  AppDelegate.m
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 30/01/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "AppDelegate.h"
#import "ApiDelegate.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [self adaptStoryboardForScreen];
    [self initializeSlideMenu];
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        [FacebookConnectionManager initializeFacebookSession];
    }
    
    [ApiDelegate connect];
    
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
    [FBSession.activeSession close];
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
        
        sb = [UIStoryboard storyboardWithName:@"Main_iPhone_Large" bundle:nil];
        vc = [sb instantiateViewControllerWithIdentifier:@"EntryPointViewLarge"];
    }
    
    // classic iphone
    else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone
          && screenBounds.size.height <= 480) {
        
        sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        vc = [sb instantiateViewControllerWithIdentifier:@"EntryPointView"];
    }
    
    
    nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    PKRevealController *revealController = [PKRevealController revealControllerWithFrontViewController:nav leftViewController:nil];
    
    self.revealController.delegate = self;
    self.revealController.animationDuration = 0.25;
    
    self.window.rootViewController = revealController;
}



- (void) initializeSlideMenu {

	
}

@end
