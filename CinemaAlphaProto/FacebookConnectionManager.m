//
//  FacebookConnectionManager.m
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 30/01/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//


@implementation FacebookConnectionManager

static NSURLConnection *connection;
static FacebookConnectionManager *sharedObject;

+ (BOOL)isSessionOpened {
    return FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended;
}

+ (void)initializeFacebookSession {
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        return;
    }
    
        [FBSession.activeSession openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        [self sessionStateChanged:session state:status error:error];
//        [FBSession.activeSession closeAndClearTokenInformation];
    }];
}

+ (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error {
    
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        
        NSLog(@"Session opened");
        
        NSURL *graphUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/me/?access_token=%@", session.accessTokenData.accessToken]];
        
        NSLog(@"Sending request...");
        
        
        NSURLRequest *request = [NSURLRequest requestWithURL:graphUrl];
        connection = [[NSURLConnection alloc] initWithRequest:request delegate:[self sharedManager] startImmediately:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLoginWithFacebook object:nil];
        
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

+ (FacebookConnectionManager *)sharedManager {
    if (sharedObject != nil) {
        return sharedObject;
    }
    
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedObject = [[FacebookConnectionManager alloc] init];
    });
    
    return sharedObject;
}


#pragma mark NSURLConnection Delegate Methods

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.responseData = [[NSMutableData alloc] init];
    [self.responseData setLength:0];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
        // convert to JSON
    NSError *error = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&error];
    
    NSString *facebookId = (NSString *) [res objectForKey:@"id"];
    [ApiDelegate requestForTokenWithFacebookId:facebookId];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}


@end
