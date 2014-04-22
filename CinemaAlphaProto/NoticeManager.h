//
//  NoticeManager.h
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 14/03/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NoticeManager : NSObject

@property NSInteger lastNoticeTimecode;

+ (NoticeManager *)sharedManager;
- (BOOL)isAcceptingNoticeType:(NSString *)type;
- (void)pushNotice:(NSMutableDictionary *)noticeData;
- (void)answered:(BOOL)answer toNoticeWithId:(NSString *)noticeId;
- (void)enableAllNotices;
- (void)sendNotice:(Notice *)notice toWebview:(UIWebView *)webView;

@end
