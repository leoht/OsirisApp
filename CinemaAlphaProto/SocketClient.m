//
//  SocketClient.m
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 31/01/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "SocketClient.h"
#import "Constants.h"
#import "ApiDelegate.h"

@implementation SocketClient

BOOL isSocketOpen = false;

- (void) openWithUrl:(NSString *)urlString {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:request];
    self.webSocket.delegate = self;
    [self.webSocket open];
}

#pragma mark - SRWebSocketDelegate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"Received message : %@", (NSString *)message);
    NSData *messageData = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    
    NSDictionary *messageArray = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:messageData options:kNilOptions error:&error];
   
    NSString *messageName = (NSString *)[messageArray objectForKey:@"name"];
    NSDictionary *data = (NSDictionary *)[messageArray objectForKey:@"data"];
    
    if ([messageName isEqualToString:ApiAssociatedWithToken]) {
        [[ApiDelegate sharedDelegate] setToken:[data objectForKey:@"token"]];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:messageName object:nil userInfo:data];
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    isSocketOpen = true;
    
    NSLog(@"Websocket connected.");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ApiConnectionOpened object:nil];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    
}

@end
