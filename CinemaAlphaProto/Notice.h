//
//  Notice.h
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 11/04/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Notice : NSObject

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *timecode;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *shortContent;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *color;

+ (Notice *)createFromDictionnary:(NSDictionary *)dictionnary;

@end
