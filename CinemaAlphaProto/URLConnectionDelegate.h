//
//  URLConnectionDelegate.h
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 30/01/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 *
 * URLConnectionDelegate takes care of every HTTP connection response,
 * which can be used for Facebook connection or API calls.
 *
 */

@interface URLConnectionDelegate : NSObject<NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSMutableData *responseData;

+ (URLConnectionDelegate *)sharedDelegate;

@end
