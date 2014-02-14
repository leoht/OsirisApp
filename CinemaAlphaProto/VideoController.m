//
//  VideoController.m
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 14/02/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "VideoController.h"

@implementation VideoController

static BOOL isPaused = YES;

+ (BOOL)isPaused {
    return isPaused;
}

+ (void)togglePlayPause {
    if (isPaused) {
        [ApiDelegate sendPlaySignal];
    } else {
        [ApiDelegate sendPauseSignal];
    }
    
    isPaused = !isPaused;
}

@end
