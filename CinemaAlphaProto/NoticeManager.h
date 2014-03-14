//
//  NoticeManager.h
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 14/03/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeManager : NSObject

+ (NoticeManager *)sharedManager;
- (BOOL)isAcceptingNoticeType:(NSString *)type;
- (void)pushNotice:(NSMutableDictionary *)noticeData;
- (void)answered:(BOOL)answer toNoticeWithId:(NSString *)noticeId;
- (void)enableAllNotices;

@end
