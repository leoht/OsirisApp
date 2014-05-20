//
//  Notice.m
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 11/04/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "Notice.h"

@implementation Notice

+ (Notice *)createFromDictionnary:(NSDictionary *)dictionnary {
    Notice *notice = [[Notice alloc] init];
    notice.id = [dictionnary objectForKey:@"id"];
    notice.title = [dictionnary objectForKey:@"title"];
    notice.shortContent = [dictionnary objectForKey:@"short_content"];
    notice.content = [dictionnary objectForKey:@"content"];
    notice.timecode = [dictionnary objectForKey:@"timecode"];
    notice.endTimecode = [dictionnary objectForKey:@"end_timecode"];
    notice.category = [dictionnary objectForKey:@"category_nicename"];
    notice.categoryTitle = [dictionnary objectForKey:@"category_title"];
    notice.color = [dictionnary objectForKey:@"color"];
    
    return notice;
}

@end
