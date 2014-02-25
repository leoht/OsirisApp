//
//  VideoController.h
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 14/02/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//


@interface VideoController : NSObject

+ (BOOL)isPaused;
+ (void)togglePlayPause;
+ (void)toggleFastForward;
+ (void)toggleFastRewind;

@end
