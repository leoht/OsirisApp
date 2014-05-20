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
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"home_bg.png"]];
    
    StylizeWithScopeFont(self.titleLabel, 60);
    
    BorderedButton(self.synchronizeWithCodeButton, ScopeBlue);
    
    BorderedButton(self.loginButton, ScopeBlue);
    
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"fb.png"] forState:UIControlStateNormal];
    
    [self.textLabel setFont:[UIFont fontWithName:@"Aller-Light" size:11]];
    [self.textLabel setTextColor:Rgb2UIColor(125, 125, 125)];
    
     NSMutableAttributedString *text2 = [[NSMutableAttributedString alloc] initWithAttributedString: self.textLabel.attributedText];
    [text2 addAttribute: NSForegroundColorAttributeName value:ScopeBlue range:NSMakeRange(80, 13)];
    [self.textLabel setAttributedText:text2];
    
    [self.loginButton setFont:[UIFont fontWithName:@"Aller-Light" size:14]];
    [self.synchronizeWithCodeButton setFont:[UIFont fontWithName:@"Aller-Light" size:14]];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ApiAssociatedWithToken object:nil queue:nil usingBlock:^(NSNotification *note) {
        PushView(@"NoticeChooserView");
    }];
     
    if (![[ApiDelegate sharedDelegate] token]) {
        self.connexionWaitingAlert = [[UIAlertView alloc] initWithTitle:@"Connexion..." message:@"Connexion à Scope..." delegate:self cancelButtonTitle:nil otherButtonTitles:0, nil];
    
        [self.connexionWaitingAlert show];
    }
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ApiConnectionOpened object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self.connexionWaitingAlert dismissWithClickedButtonIndex:0 animated:YES];
        if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
            [FacebookConnectionManager initializeFacebookSession];
            if ([FacebookConnectionManager isSessionOpened]) {
                [self.signoutButton setHidden:NO];
            }
            
            

        }
    }];
    
    // If logged in with FB but association has not been started on the website
    [[NSNotificationCenter defaultCenter] addObserverForName:ApiAssociationRefused object:nil queue:nil usingBlock:^(NSNotification *note) {
        if ([FacebookConnectionManager isSessionOpened]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Choisir un film" message:@"Choisissez un film sur le site web Scope pour pouvoir utiliser l'application" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [errorAlert show];
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

- (IBAction)signout:(id)sender {
    [FBSession.activeSession closeAndClearTokenInformation];
    self.signoutButton.hidden = YES;
}

- (IBAction)doSynchronizeWithCode:(id)sender {
    PushView(@"SynchronizeWithCodeView");
}


@end
