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
    // adapt storyboard if it is a 4-inch iPhone
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone
            && screenBounds.size.height > 480) {
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone_large" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"EntryPointViewLarge"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nav;
    }
    
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

@end
