//
//  MovieSummaryView.m
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 31/01/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//


@interface MovieSummaryView ()

@end

@implementation MovieSummaryView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self.movieWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:ApiWebUrl]]];
    
    MainMenuView *menu = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenu"];
    [self.revealController setLeftViewController:menu];
    [self.revealController setMinimumWidth:100.0 maximumWidth:120.0 forViewController:menu];
    [self.revealController setAllowsOverdraw:NO];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ApiPlayingAtTimecode object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *timecodeString = [NSString stringWithFormat:@"%@", [note.userInfo objectForKey:@"timecode"]];
        [ApiDelegate requestForNoticeAtTimecode:timecodeString];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ApiNoticeAtTimecode object:nil queue:nil usingBlock:^(NSNotification *note) {
//        self.timecodeLabel.text = (NSString *) [note.userInfo objectForKey:@"content"];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backHomeButtonTouched:(id)sender {
    
}

- (IBAction)togglePlayPause:(id)sender {
    
    if ([VideoController isPaused]) {
        self.playPauseButton.titleLabel.text = @"Pause";
    } else {
        self.playPauseButton.titleLabel.text = @"Lecture";
    }
    
    [VideoController togglePlayPause];
    
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/me/gobelins_crma_cinema:discover?access_token=%@&method=POST&movie=http%%3A%%2F%%2Fsamples.ogp.me%%2F453907197960619", FBSession.activeSession.accessTokenData.accessToken]];
//    
//    NSLog(@"%@", url);
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"Received response");
}

- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer {
    NSLog(@"pinch");
   
}

@end
