//
//  FacebookConnectionManager.h
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 30/01/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//


@interface FacebookConnectionManager : NSObject<NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSMutableData *responseData;

+ (FacebookConnectionManager *)sharedManager;

+ (BOOL)isSessionOpened;
+ (void)initializeFacebookSession;
+ (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error;
+ (NSMutableDictionary *)userInfo;
+ (void) setUserInfo:(NSMutableDictionary *)info;
+ (NSString *) getUserImageUrl;
+ (NSString *) getUserName;

@end
