//
//  FacebookConnectionManager.m
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 30/01/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "FacebookConnectionManager.h"

@implementation FacebookConnectionManager

+ (BOOL)isSessionOpened {
    return FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended;
}

+ (void)initializeFacebookSession {
    [FBSession.activeSession openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        [self sessionStateChanged:session state:status error:error];
    }];
}

+ (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error {
    
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        
        NSLog(@"Session opened");
        
//        NSURL *graphUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@", session.accessTokenData.accessToken]];
//        
//        NSLog(@"Sending request...");
//        
//        URLConnectionDelegate *connectionDelegate = [URLConnectionDelegate sharedDelegate];
//        
//        NSURLRequest *request = [NSURLRequest requestWithURL:graphUrl];
//        [[NSURLConnection alloc] initWithRequest:request delegate:connectionDelegate];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserDidLoginWithFacebook" object:nil];
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        [FBSession.activeSession close];
        NSLog(@"Session closed : %@", [FBSession activeSession]);
        
    }
    
    // Handle errors
    if (error){
        NSLog(@"ERROR");
    }

}

@end
