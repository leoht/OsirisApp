//
//  ApiDelegate.m
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 31/01/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

@implementation ApiDelegate

static ApiDelegate *sharedObject;
static NSString *token;

/**
 * Get the shared delegate.
 */
+ (ApiDelegate *)sharedDelegate {
    if (sharedObject != nil) {
        return sharedObject;
    }
    
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedObject = [[ApiDelegate alloc] init];
        sharedObject.client = [[SocketClient alloc] init];
    });
    
    return sharedObject;
}

/**
 * Initiates the websocket connection
 */
+ (void)connect {
    SocketClient *client = [[self sharedDelegate] client];
    [client openWithUrl:ApiConnectionUrl];
}

+ (void)requestForTokenWithCode:(NSString *)code {
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                ApiFromDeviceToPlayer,  @"direction",
                                ApiAssociateWithCode, @"name",
                                [NSDictionary dictionaryWithObjects:@[code] forKeys:@[@"code"]], @"data", nil];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
    
    NSLog(@"%@", jsonData);

    [[self sharedDelegate] sendData:jsonData];
}

+ (void)requestForTokenWithFacebookId:(NSString *)facebookId {
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          ApiFromDeviceToPlayer,  @"direction",
                          ApiAssociateWithFacebook, @"name",
                          [NSDictionary dictionaryWithObjects:@[facebookId] forKeys:@[@"facebook_id"]], @"data", nil];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
    
    [[self sharedDelegate] sendData:jsonData];
}

+ (void)requestForNoticeAtTimecode:(NSString *)timecode {
    NSString *token = [[ApiDelegate sharedDelegate] token];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          ApiFromDeviceToPlayer,  @"direction",
                          ApiRequestForNoticeAtTimecode, @"name",
                          token, @"token",
                          [NSDictionary dictionaryWithObjects:@[timecode] forKeys:@[@"timecode"]], @"data", nil];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
    
    [[self sharedDelegate] sendData:jsonData];
}

+ (void)sendMessageNamed:(NSString *)name withData:(id)data {
    NSString *token = [[ApiDelegate sharedDelegate] token];
    
    NSDictionary *message = [[NSDictionary alloc] initWithObjectsAndKeys:
                          ApiFromDeviceToPlayer,  @"direction",
                          name, @"name",
                          token, @"token",
                          data, @"data", nil];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:message options:0 error:nil];
    
    [[self sharedDelegate] sendData:jsonData];
}

- (void)sendData:(NSData *)data {
    NSString* jsonString = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
    NSLog(@"Sending data : %@", jsonString);
    [self.client.webSocket send:jsonString];
}

@end
