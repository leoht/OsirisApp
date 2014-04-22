//
//  NoticeManager.m
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 14/03/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "NoticeManager.h"

@interface NoticeManager ()

@property (strong, nonatomic) NSMutableArray *acceptedNoticeTypes;
@property (strong, nonatomic) NSMutableArray *receivedNotices;

@end

@implementation NoticeManager

static NoticeManager *sharedObject;

+ (NoticeManager *)sharedManager {
    if (sharedObject != nil) {
        return sharedObject;
    }
    
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedObject = [[NoticeManager alloc] init];
    });
    
    return sharedObject;
}

- (id)init {
    self.lastNoticeTimecode = -1000;
    
    return self;
}

- (BOOL)isAcceptingNoticeType:(NSString *)type {
    if ([[self acceptedNoticeTypes] containsObject:type]) {
        return YES;
    } else return NO;
}

- (void)pushNotice:(NSMutableDictionary *)noticeData {
    [self.receivedNotices addObject:noticeData];
}

- (void)answered:(BOOL)answer toNoticeWithId:(NSString *)noticeId {
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObject:@[noticeId] forKey:@[@"notice_id"]];
    
    if (answer == YES) {
        [ApiDelegate sendMessageNamed:ApiChooseNoticeSaidYes withData:data];
    } else {
        [ApiDelegate sendMessageNamed:ApiChooseNoticeSaidNo withData:data];
    }
}

- (void)enableAllNotices {
    [self setAcceptedNoticeTypes:(NSMutableArray *)@[@"impact", @"themes", @"analyse", @"anecdotes"]];
}

- (void)sendNotice:(Notice *)notice toWebview:(UIWebView *)webView {
    
    NSInteger timecodeInt = [notice.timecode integerValue];
    
    NSLog(@"last timecode : %ld, current : %d", (long)timecodeInt, self.lastNoticeTimecode);
    
//    if (timecodeInt - self.lastNoticeTimecode > 60) {
        [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"onNewNotice('%@', '%@', %@, '%@', '%@', '%@', '%@');",
                                                         notice.timecode,
                                                         notice.endTimecode,
                                                         notice.id,
                                                         [notice.title stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"],
                                                         [notice.shortContent stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"],
                                                         notice.category,
                                                         notice.color
        ]];

//    } else {
////        notice.viewed = NO;
//    }
    
    [self.receivedNotices addObject:notice];
    
    self.lastNoticeTimecode = timecodeInt;
    
}

@end
