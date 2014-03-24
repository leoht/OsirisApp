//
//  MovieSummaryView.h
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 31/01/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

@interface MovieSummaryView : UIViewController<WebViewInterface>

@property (strong, nonatomic) NSString *token;

@property (weak, nonatomic) IBOutlet UIWebView *timelineWebView;
@property (weak, nonatomic) IBOutlet UILabel *timecodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTimecodeLabel;

@end
