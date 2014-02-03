//
//  FacebookConnectionManager.h
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 30/01/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "URLConnectionDelegate.h"

@interface FacebookConnectionManager : NSObject

+ (BOOL)isSessionOpened;
+ (void)initializeFacebookSession;
+ (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error;

@end
