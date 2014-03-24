//
//  MovieSummaryView.m
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 31/01/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//


@interface MovieSummaryView ()
    @property WebViewDelegate *webViewDelegate; @end

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
    StylizeWithScopeFont(self.secondTimecodeLabel, 20);
    
    // load html timeline view
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    self.webViewDelegate = [[WebViewDelegate alloc] initWithWebView:self.timelineWebView withWebViewInterface:self];
    
	self.timelineWebView.scrollView.scrollEnabled = false;
	[self.webViewDelegate loadPage:@"home.html" fromFolder:@"www"];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ApiPlayingAtTimecode object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *timecodeString = [NSString stringWithFormat:@"%@", [note.userInfo objectForKey:@"timecode"]];
        [self.timecodeLabel setText:timecodeString];
        [self.secondTimecodeLabel setText:timecodeString];
        [ApiDelegate requestForNoticeAtTimecode:timecodeString withMovieId:[[VideoController movieInfo] objectForKey:@"movie_id"]];
        [self.webViewDelegate.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setTimecode('%@')", [note.userInfo objectForKey:@"timecode"]]];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ApiNoticeAtTimecode object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSLog(@"Notice !");
        
        [self.webViewDelegate.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"onNewNotice('%@', '%@', '%@', '%@');",
                                            [note.userInfo objectForKey:@"id"],
                                            [note.userInfo objectForKey:@"title"],
                                            [note.userInfo objectForKey:@"short_content"],
                                            [note.userInfo objectForKey:@"category_nicename"]
        ]];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:WebViewLoaded object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSMutableDictionary * info = [VideoController movieInfo];
        [self.webViewDelegate.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setMovieInfo('%@','%@'); movieDuration = %@",
                                                                              [info objectForKey:@"title"],
                                                                              [info objectForKey:@"author"],
                                                                              [info objectForKey:@"duration"]
                                                                              ]];
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
    
    if ([name compare:@"nextChapter" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        [VideoController nextChapter];
    }
    
    if ([name compare:@"prevChapter" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        [VideoController prevChapter];
    }
    
    if ([name compare:@"goTimeline" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        [self.timecodeLabel setHidden:YES];
        [self.secondTimecodeLabel setHidden:NO];
    }
    
    if ([name compare:@"goHome" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        [self.timecodeLabel setHidden:NO];
        [self.secondTimecodeLabel setHidden:YES];
    }
    
    if ([name compare:@"quit" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        [ApiDelegate clearToken];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    return nil;
}

@end
