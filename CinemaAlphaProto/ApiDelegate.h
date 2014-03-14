//
//  ApiDelegate.h
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 31/01/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

@interface ApiDelegate : NSObject

@property (strong, nonatomic) SocketClient *client;
@property (strong, nonatomic) NSString *token;

+ (ApiDelegate *)sharedDelegate;
+ (void)connect;
+ (void)clearToken;
+ (void)requestForTokenWithCode:(NSString *)code;
+ (void)requestForTokenWithFacebookId:(NSString *)facebookId;
+ (void)requestForNoticeAtTimecode:(NSString *)timecode withMovieId:(NSString *)movieId;

+ (void)sendMessageNamed:(NSString *)name
                withData:(id)data;

- (void)sendData:(NSData *)data;

@end
