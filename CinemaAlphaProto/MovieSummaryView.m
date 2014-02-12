//
//  MovieSummaryView.m
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 31/01/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "Constants.h"
#import "MovieSummaryView.h"
#import "EntryPointView.h"
#import "AppDelegate.h"
#import "ApiDelegate.h"

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
    
    [self.revealController setLeftViewController:[self leftViewController]];
    [self.revealController setMinimumWidth:60.0 maximumWidth:60.0 forViewController:self];
    [self.revealController setAllowsOverdraw:NO];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ApiPlayingAtTimecode object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *timecodeString = [NSString stringWithFormat:@"%@", [note.userInfo objectForKey:@"timecode"]];
        self.timecodeLabel.text = timecodeString;
        
        [ApiDelegate requestForNoticeAtTimecode:timecodeString];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ApiNoticeAtTimecode object:nil queue:nil usingBlock:^(NSNotification *note) {
        self.timecodeLabel.text = (NSString *) [note.userInfo objectForKey:@"content"];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backHomeButtonTouched:(id)sender {
    
}


#pragma mark - Helpers

- (UIViewController *)leftViewController
{
    UIViewController *leftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenu"];
    

    
    return leftViewController;
}

@end
