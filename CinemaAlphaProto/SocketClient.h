//
//  SocketClient.h
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 31/01/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"

@interface SocketClient : NSObject <SRWebSocketDelegate>

@property (strong, nonatomic) SRWebSocket *webSocket;

- (void)openWithUrl:(NSString *)urlString;

@end
