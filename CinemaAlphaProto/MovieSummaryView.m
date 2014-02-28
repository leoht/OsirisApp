//
//  MovieSummaryView.m
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 31/01/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//


@interface MovieSummaryView ()
    @property WebViewDelegate *webViewDelegate;
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
    
    StylizeWithScopeFont(self.timecodeLabel, 20);
    
    // load html timeline view
    self.webViewDelegate = [[WebViewDelegate alloc] initWithWebView:self.timelineWebView withWebViewInterface:self];
    
	self.timelineWebView.scrollView.scrollEnabled = false;
	[self.webViewDelegate loadPage:@"home.html" fromFolder:@"www"];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ApiPlayingAtTimecode object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *timecodeString = [NSString stringWithFormat:@"%@", [note.userInfo objectForKey:@"timecode"]];
        [self.timecodeLabel setText:timecodeString];
        [ApiDelegate requestForNoticeAtTimecode:timecodeString];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ApiNoticeAtTimecode object:nil queue:nil usingBlock:^(NSNotification *note) {
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)togglePlayPause:(id)sender {

    [VideoController togglePlayPause];
    
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/me/gobelins_crma_cinema:discover?access_token=%@&method=POST&movie=http%%3A%%2F%%2Fsamples.ogp.me%%2F453907197960619", FBSession.activeSession.accessTokenData.accessToken]];
//    
//    NSLog(@"%@", url);
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (id) processFunctionFromJS:(NSString *)name withArgs:(NSArray *)args error:(NSError *__autoreleasing *)error {
    if ([name compare:@"togglePlayPause" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        [VideoController togglePlayPause];
    }
    
    if ([name compare:@"toggleFastForward" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        [VideoController toggleFastForward];
    }
    
    if ([name compare:@"toggleFastRewind" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        [VideoController toggleFastRewind];
    }
    
    return nil;
}

@end
