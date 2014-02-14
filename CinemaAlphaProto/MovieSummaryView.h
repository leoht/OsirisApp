//
//  MovieSummaryView.h
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 31/01/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

@interface MovieSummaryView : UIViewController<NSURLConnectionDataDelegate> 

@property (strong, nonatomic) NSString *token;

@property (weak, nonatomic) IBOutlet UIButton *backHomeButton;
@property (strong, nonatomic) IBOutlet UIWebView *movieWebView;
@property (strong, nonatomic) IBOutlet MainMenuView *menu;
@property (weak, nonatomic) IBOutlet UILabel *timecodeLabel;

@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;

- (IBAction)backHomeButtonTouched:(id)sender;

@end
