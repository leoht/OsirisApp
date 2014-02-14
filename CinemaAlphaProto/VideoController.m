//
//  VideoController.m
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 14/02/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//


@implementation VideoController

static BOOL isPaused = YES;

+ (BOOL)isPaused {
    return isPaused;
}

+ (void)togglePlayPause {
    if (isPaused) {
        [ApiDelegate sendMessageNamed:ApiRequestPlay withData:nil];
    } else {
        [ApiDelegate sendMessageNamed:ApiRequestPause withData:nil];
    }
    
    isPaused = !isPaused;
}

+ (void)setVolume:(float)volume {
    
    if (volume < 0) {
        volume = 0.0;
    } else if (volume > 1) {
        volume = 1.0;
    }
    
    NSString *volumeString = [NSString stringWithFormat:@"%f", volume];
    [ApiDelegate sendMessageNamed:ApiSetVolume
                         withData:[NSDictionary dictionaryWithObject:volumeString forKey:@"volume"]];
}



@end
