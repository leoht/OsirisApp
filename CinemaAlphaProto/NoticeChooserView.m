//
//  NoticeChooserView.m
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 14/03/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "NoticeChooserView.h"

@interface NoticeChooserView () <WebViewInterface>

@property WebViewDelegate *webViewDelegate;
@property (weak, nonatomic) IBOutlet UILabel *introTextLabel;

@end

@implementation NoticeChooserView

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    [self.introTextLabel setFont:[UIFont fontWithName:@"Aller-Light" size:16]];
    [self.introTextLabel setTextColor:Rgb2UIColor(136, 136, 136)];
    
    [self.skipButton.titleLabel setFont:[UIFont fontWithName:@"Aller-Light" size:18]];
    BorderedButton(self.skipButton, ScopeBlue);
    
    
    StylizeWithScopeFont(self.chooserTitle, 32);
    
    self.webViewDelegate = [[WebViewDelegate alloc] initWithWebView:self.webView withWebViewInterface:self];
	self.webView.scrollView.scrollEnabled = false;
	[self.webViewDelegate loadPage:@"notice_chooser.html" fromFolder:@"www"];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:WebViewLoaded object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self.webViewDelegate.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"ROOT_API_URL = '%@'; loadNotices();", ApiWebUrl]];
    }];
    
    [VideoController togglePlayPause];
    [VideoController setPaused:NO];
    NSLog(@"Web player now playing.");
    
//    [VideoController togglePlayPause];
}

- (id) processFunctionFromJS:(NSString *)name withArgs:(NSArray *)args error:(NSError *__autoreleasing *)error {
    
    if ([name compare:@"yes" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
//        [[NoticeManager sharedManager] ]
    }
    
    if ([name compare:@"no" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        
    }
    
    if ([name compare:@"goToMovieView" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        PushView(@"MovieSummaryView");
    }
    
    return nil;
}

- (IBAction)skip:(id)sender {
//    [[NoticeManager sharedManager] enableAllNotices];
    NSLog(@"SKIP");
    PushView(@"MovieSummaryView");
}

@end
