//
//  VideoController.h
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 14/02/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface VideoController : NSObject

+ (void)start;
+ (BOOL)isPaused;
+ (void)togglePlayPause;
+ (void)toggleFastForward;
+ (void)toggleFastRewind;
+ (void)setMovieInfo:(NSMutableDictionary *)info;
+ (NSMutableDictionary *)movieInfo;

@end
