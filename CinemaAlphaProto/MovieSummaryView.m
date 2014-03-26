//
//  MovieSummaryView.m
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 31/01/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//


@interface MovieSummaryView () <UIAlertViewDelegate>
    @property WebViewDelegate *webViewDelegate;
    @property NSString *currentTimecode;
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
    
    [self setCurrentTimecode:@"0"];
    
    StylizeWithScopeFont(self.timecodeLabel, 16);
    StylizeWithScopeFont(self.secondTimecodeLabel, 20);
    
    // load html timeline view
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    self.webViewDelegate = [[WebViewDelegate alloc] initWithWebView:self.timelineWebView withWebViewInterface:self];
    
	self.timelineWebView.scrollView.scrollEnabled = false;
	[self.webViewDelegate loadPage:@"home.html" fromFolder:@"www"];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ApiPlayingAtTimecode object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *timecodeString = [NSString stringWithFormat:@"%@", [note.userInfo objectForKey:@"timecode"]];
        [self setCurrentTimecode:timecodeString];
        [self.timecodeLabel setText:timecodeString];
        [self.secondTimecodeLabel setText:timecodeString];
        [ApiDelegate requestForNoticeAtTimecode:timecodeString withMovieId:[[VideoController movieInfo] objectForKey:@"movie_id"]];
        [ApiDelegate requestForCommentAtTimecode:timecodeString withMovieId:[[VideoController movieInfo] objectForKey:@"movie_id"]];

        [self.webViewDelegate.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setTimecode('%@')", [note.userInfo objectForKey:@"timecode"]]];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ApiNoticeAtTimecode object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSLog(@"Notice ! %@", note.userInfo);
        
        NSString *id = (NSMutableString *)[note.userInfo objectForKey:@"id"];
        NSString *title = (NSMutableString *)[note.userInfo objectForKey:@"title"];
        NSString *content = (NSMutableString *)[note.userInfo objectForKey:@"short_content"];
        NSString *category = (NSMutableString *)[note.userInfo objectForKey:@"category_nicename"];
        
        [self.webViewDelegate.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"onNewNotice('%@', '%@', '%@', '%@');",
                        [id stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"],
                        [title stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"],
                        [content stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"],
                        [category stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"]
        ]];
    }];
    
//    [[NSNotificationCenter defaultCenter] addObserverForName:ApiCommentAtTimecode object:nil queue:nil usingBlock:^(NSNotification *note) {
//        [self.webViewDelegate.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"onNewComment('%@');",
//                        [note.userInfo objectForKey:@"comment"]
//                                                                              ]];
//    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:WebViewLoaded object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSMutableDictionary * info = [VideoController movieInfo];
        [self.webViewDelegate.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setMovieInfo('%@','%@'); movieDuration = %@",
                [info objectForKey:@"title"],
                [info objectForKey:@"author"],
                [info objectForKey:@"duration"]
        ]];
        
        // If the user is logged in, retrieve FB info to display it in view
        if ([FacebookConnectionManager isSessionOpened]) {
            NSLog(@"Logged with FB");
            NSMutableDictionary *userInfo = [FacebookConnectionManager userInfo];
            [self.webViewDelegate.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setUserInfo('%@ %@', '%@');",
                [userInfo objectForKey:@"first_name"], [userInfo objectForKey:@"last_name"],
                [FacebookConnectionManager getUserImageUrl]
            ]];
        }
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

- (void) showExitConfirmAlert {
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:@"Retour à l'accueil"];
    [alert setMessage:@"Voulez-vous vraiment quitter ce film ?"];
    [alert setDelegate:self];
    [alert addButtonWithTitle:@"Oui"];
    [alert addButtonWithTitle:@"Non"];
    [alert show];
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
    
    if ([name compare:@"goSocial" options:NSCaseInsensitiveSearch] == NSOrderedSame
        || [name compare:@"goDoc" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        [self.timecodeLabel setHidden:YES];
        [self.secondTimecodeLabel setHidden:YES];
    }
    
    if ([name compare:@"postMessage" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        NSLog(@"%@", args);
        NSString *message = (NSString *)[args firstObject];
        NSString *movieId = (NSString *)[[VideoController movieInfo] objectForKey:@"movie_id"];
        NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjects:@[movieId, message, [self currentTimecode]]
                                                                       forKeys:@[@"movie_id", @"message", @"timecode"]];
        [ApiDelegate sendMessageNamed:ApiPostMessage withData:data];
    }
    
    if ([name compare:@"quit" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        [self showExitConfirmAlert];
    }
    
    return nil;
}


#pragma mark - UIAlertView delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [ApiDelegate clearToken];
        if (![VideoController isPaused]) {
            [VideoController togglePlayPause];
        }
        [FBSession.activeSession closeAndClearTokenInformation];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
