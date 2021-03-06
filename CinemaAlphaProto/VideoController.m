//
//  VideoController.m
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 14/02/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//


@implementation VideoController

static BOOL isPaused = YES;

static NSMutableDictionary *movieInfo;

+ (void)start {
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ApiMovieInfo object:nil queue:nil usingBlock:^(NSNotification *note) {
        movieInfo = (NSMutableDictionary *) note.userInfo;
    }];
}

+ (BOOL)isPaused {
    return isPaused;
}

+ (void)setPaused:(BOOL)paused {
    isPaused = paused;
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

+ (void)toggleFastForward {
    [ApiDelegate sendMessageNamed:ApiFastForward withData:nil];
}

+ (void)toggleFastRewind {
    [ApiDelegate sendMessageNamed:ApiFastRewind withData:nil];
}

+ (void)prevChapter {
    [ApiDelegate sendMessageNamed:ApiPrevChapter withData:nil];
}

+ (void)nextChapter {
    [ApiDelegate sendMessageNamed:ApiNextChapter withData:nil];
}

+ (void)setMovieInfo:(NSMutableDictionary *)info {
    movieInfo = info;
}

+ (NSMutableDictionary *)movieInfo {
    return movieInfo;
}

@end
