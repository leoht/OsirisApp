//
//  URLConnectionDelegate.m
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 30/01/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "URLConnectionDelegate.h"

@implementation URLConnectionDelegate

static URLConnectionDelegate *sharedObject;

+ (URLConnectionDelegate *)sharedDelegate {
    if (sharedObject != nil) {
        return sharedObject;
    }
    
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedObject = [[URLConnectionDelegate alloc] init];
    });
    
    return sharedObject;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.responseData = [NSMutableData data];
    }
    return self;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.responseData setLength:0];
    NSLog(@"Received response");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    NSDictionary *friends = [res objectForKey:@"data"];
    //NSLog(@"%@", friends);
    
    for(NSDictionary *friend in friends) {
        NSLog(@"%@", friend);
        //NSLog(@"https://graph.facebook.com/%d/picture?access_token=%@", (int)[friend objectForKey:@"id"], FBSession.activeSession.accessTokenData.accessToken);
    }
}

@end
