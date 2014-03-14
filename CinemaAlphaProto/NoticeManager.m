//
//  NoticeManager.m
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 14/03/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "NoticeManager.h"

@interface NoticeManager ()

@property NSMutableArray *acceptedNoticeTypes;
@property NSMutableArray *receivedNotices;

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

- (BOOL)isAcceptingNoticeType:(NSString *)type {
    if ([[self acceptedNoticeTypes] containsObject:type]) {
        return YES;
    } else return NO;
}

- (void)pushNotice:(NSMutableDictionary *)noticeData {
    [self.receivedNotices addObject:noticeData];
}

- (void)answered:(BOOL)answer toNoticeWithId:(NSString *)noticeId {
//    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObject:@[noticeId] forKey:@[@"notice_id"]];
    
//    if (answer == YES) {
//        [ApiDelegate sendMessageNamed:ApiChooseNoticeSaidYes withData:data];
//    } else {
//        [ApiDelegate sendMessageNamed:ApiChooseNoticeSaidNo withData:data];
//    }
}

- (void)enableAllNotices {
    [self setAcceptedNoticeTypes:(NSMutableArray *)@[@"impact", @"themes", @"analyse", @"anecdotes"]];
}

@end
