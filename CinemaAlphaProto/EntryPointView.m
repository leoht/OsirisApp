//
//  EntryPointView.m
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 30/01/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//


@implementation EntryPointView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: self.titleLabel.attributedText];
    [text addAttribute: NSForegroundColorAttributeName value:ScopeBlue range:NSMakeRange(2, 1)];
    [self.titleLabel setAttributedText: text];
    
    StylizeWithScopeFont(self.titleLabel, 80);
    
    StylizeWithScopeFont(self.synchronizeWithCodeButton.titleLabel, 20);
    BorderedButton(self.synchronizeWithCodeButton, ScopeBlue);
    
    BorderedButton(self.loginButton, ScopeBlue);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UserDidLoginWithFacebook object:nil queue:nil usingBlock:^(NSNotification *note) {
        MovieSummaryView *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NoticeChooserView"];
        [self.navigationController pushViewController:nextViewController animated:YES];
    }];
     
    if (![[ApiDelegate sharedDelegate] token]) {
        self.connexionWaitingAlert = [[UIAlertView alloc] initWithTitle:@"Connexion..." message:@"Connexion à internet..." delegate:self cancelButtonTitle:nil otherButtonTitles:0, nil];
    
        [self.connexionWaitingAlert show];
    }
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ApiConnectionOpened object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self.connexionWaitingAlert dismissWithClickedButtonIndex:0 animated:YES];
        if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
            [FacebookConnectionManager initializeFacebookSession];
        }
    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (IBAction)doFacebookLogin:(id)sender {
    if (false == [FacebookConnectionManager isSessionOpened]) {
        [FacebookConnectionManager initializeFacebookSession];
    }
}

- (IBAction)doCodeSynchronization:(id)sender {
    PushView(@"SynchronizeWithCodeView");
    
}

@end
