//
//  TimelineView.m
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 14/02/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "TimelineView.h"

@interface TimelineView ()

@end

@implementation TimelineView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 500, 10)];
//    view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:view];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ApiPlayingAtTimecode object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *timecodeString = (NSString *) [note.userInfo objectForKey:@"timecode"];
        int seconds = [timecodeString intValue];
        int minutes = seconds / 60;
        seconds %= 60;
        int hours = minutes / 60;
        minutes %= 60;
        
        NSString *timecode = [NSString stringWithFormat:@"%02d : %02d : %02d", hours, minutes, seconds];
        
        self.timecodeLabel.text = timecode;
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
