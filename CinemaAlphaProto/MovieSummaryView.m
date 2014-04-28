//
//  MovieSummaryView.m
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 31/01/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//


@interface MovieSummaryView () <UIAlertViewDelegate>
    @property WebViewDelegate *webViewDelegate;
    @property UIAlertView *movieInfoWaitingAlert;
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
    
    // FACEBOOK OPEN GRAPH POST DISCOVER
    
//    [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session, NSError *error) {
//        if (error) {
//            NSLog(@"Error");
//        }
//    }];
    
    
    
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/me/gobelins_crma_cinema:discover?access_token=%@&movie=108250085865894", FBSession.activeSession.accessTokenData.accessToken]];
//    
//    NSLog(@"%@", url);
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    [request setHTTPMethod:@"POST"];
//    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
//    StylizeWithScopeFont(self.secondTimecodeLabel, 20);
    [self.secondTimecodeLabel setFont:[UIFont fontWithName:@"Aller-Italic" size:16]];
    
    // load html timeline view
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    self.webViewDelegate = [[WebViewDelegate alloc] initWithWebView:self.timelineWebView withWebViewInterface:self];
    
	self.timelineWebView.scrollView.scrollEnabled = false;
	[self.webViewDelegate loadPage:@"home.html" fromFolder:@"www"];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ApiPlayingAtTimecode object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *timecodeString = [NSString stringWithFormat:@"%@", [note.userInfo objectForKey:@"timecode"]];
        [self setCurrentTimecode:timecodeString];
        [self.secondTimecodeLabel setText:[self formatTimecode:timecodeString]];
        [ApiDelegate requestForNoticeAtTimecode:timecodeString withMovieId:[[VideoController movieInfo] objectForKey:@"movie_id"]];
        [ApiDelegate requestForCommentAtTimecode:timecodeString withMovieId:[[VideoController movieInfo] objectForKey:@"movie_id"]];

        [self.webViewDelegate.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setTimecode('%@')", [note.userInfo objectForKey:@"timecode"]]];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ApiNoticeAtTimecode object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSLog(@"Notice ! %@", note.userInfo);
        
        Notice *notice = [Notice createFromDictionnary:note.userInfo];
        [[NoticeManager sharedManager] sendNotice:notice toWebview:self.webViewDelegate.webView];
        [[NoticeManager sharedManager] setLastNoticeTimecode:[note.userInfo objectForKey:@"timecode"]];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ApiCommentAtTimecode object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self.webViewDelegate.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"onNewComment('%@', '%@', '%@');",
                        [note.userInfo objectForKey:@"comment"],
                        [note.userInfo objectForKey:@"author"],
                        [note.userInfo objectForKey:@"timecode"]
        ]];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:WebViewLoaded object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSMutableDictionary * info = [VideoController movieInfo];
        [self.webViewDelegate.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"ROOT_API_URL = '%@'; setMovieInfo('%@', '%@','%@'); movieDuration = %@; ",
                ApiWebUrl,
                [info objectForKey:@"movie_id"],
                [info objectForKey:@"title"],
                [info objectForKey:@"author"],
                [info objectForKey:@"duration"]
                
        ]];
        
        // If the user is logged in, retrieve FB info to display it in view
        if ([FacebookConnectionManager isSessionOpened]) {
            NSLog(@"Logged with FB");
            NSMutableDictionary *userInfo = [FacebookConnectionManager userInfo];
            [self.webViewDelegate.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setUserInfo('%@', '%@ %@', '%@');",
                [userInfo objectForKey:@"id"],
                [userInfo objectForKey:@"first_name"], [userInfo objectForKey:@"last_name"],
                [FacebookConnectionManager getUserImageUrl]
            ]];
        }
        
        [VideoController togglePlayPause];
        [VideoController setPaused:NO];
        NSLog(@"Web player now playing.");
        [self.webViewDelegate.webView stringByEvaluatingJavaScriptFromString:@"onPlay();"];
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ApiRequestPlay object:nil queue:nil usingBlock:^(NSNotification *note) {
        [VideoController setPaused:NO];
        NSLog(@"Web player now playing.");
        [self.webViewDelegate.webView stringByEvaluatingJavaScriptFromString:@"onPlay();"];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ApiRequestPause object:nil queue:nil usingBlock:^(NSNotification *note) {
        [VideoController setPaused:NO];
        NSLog(@"Web player now paused.");
        [self.webViewDelegate.webView stringByEvaluatingJavaScriptFromString:@"onPause();"];
    }];
    
    if ([[VideoController movieInfo] count] == 0) {
        self.movieInfoWaitingAlert = [[UIAlertView alloc] initWithTitle:@"Chargement" message:@"Chargement des données du film..." delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    }
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ApiMovieInfo object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self.movieInfoWaitingAlert dismissWithClickedButtonIndex:0 animated:YES];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ApiToggleFastForward object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self.webViewDelegate.webView stringByEvaluatingJavaScriptFromString:@"FAST_FORWARD = !FAST_FORWARD;"];
        NSLog(@"Toggle FFWD");
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ApiToggleFastRewind object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self.webViewDelegate.webView stringByEvaluatingJavaScriptFromString:@"FAST_REWIND = !FAST_REWIND;"];
        NSLog(@"Toggle FRWD");
    }];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)togglePlayPause:(id)sender {

    [VideoController togglePlayPause];
}

- (NSString *) formatTimecode:(NSString *)timecode {
    NSInteger s = [timecode intValue];
    NSInteger m = s / 60;
    s %= 60;
    NSInteger h = m / 60;
    m %= 60;
    
    return [NSString stringWithFormat:@"%d:%02d:%02d", h, m, s];
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
    
    if ([name compare:@"goHome" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        [self.secondTimecodeLabel setHidden:NO];
    }
    
    if ([name compare:@"profileMenuDisplayed" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        [self.secondTimecodeLabel setHidden:YES];
    }
    
    if ([name compare:@"profileMenuHidden" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        [self.secondTimecodeLabel performSelector:@selector(setHidden:) withObject:NO afterDelay:0.2f];
    }
    
    if ([name compare:@"goSocial" options:NSCaseInsensitiveSearch] == NSOrderedSame
        || [name compare:@"goDoc" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        [self.secondTimecodeLabel setHidden:YES];
    }
    
    if ([name compare:@"shareNotice" options:NSCaseInsensitiveSearch] == NSOrderedSame && args.count > 0) {
        NSString *serviceType = [[args objectAtIndex:0] isEqualToString:@"facebook"] ? SLServiceTypeFacebook : SLServiceTypeTwitter;
        SLComposeViewController *composeVc = [SLComposeViewController composeViewControllerForServiceType:serviceType];
        
        [composeVc setInitialText:@"Je viens de découvrir une notice sur le film Métropolis grâce à l'application Scope, jetez-y un coup d'oeil !"];
        [composeVc addURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.scope.dev/notices/%@.html", [args objectAtIndex:1]]]];
        [composeVc addImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"www/images/samples/notices/%@_big.jpg", [args objectAtIndex:1]]]];
        
        [self presentViewController:composeVc animated:YES completion:nil];
    }
    if ([name compare:@"postMessage" options:NSCaseInsensitiveSearch] == NSOrderedSame && args.count > 0) {
        
        if (![FacebookConnectionManager isSessionOpened]) {
            NSLog(@"Not logged into FB");
            return nil;
        }
        
        NSLog(@"%@", args);
        NSString *message = [NSString stringWithFormat:@"%@",[args objectAtIndex:0]];
        NSString *movieId = (NSString *)[[VideoController movieInfo] objectForKey:@"movie_id"];
        NSString *facebookId = [[FacebookConnectionManager userInfo] objectForKey:@"id"];
        
        NSMutableDictionary *data = [NSMutableDictionary
                                     dictionaryWithObjects:@[movieId, facebookId, message, [self currentTimecode]]
                                     forKeys:@[@"movie_id", @"facebook_id", @"message", @"timecode"]];
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
//        [FBSession.activeSession closeAndClearTokenInformation];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
