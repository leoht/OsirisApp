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
    
    [self.titleLabel setFont:[UIFont fontWithName:@"Twofaced-Bold" size:40]];
    [self.titleLabel setTextColor:[UIColor colorWithRed:0.2 green:0.4 blue:0.8 alpha:1]];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"UserDidLoginWithFacebook" object:nil queue:nil usingBlock:^(NSNotification *note) {
        MovieSummaryView *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MovieSummaryView"];
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

- (IBAction)didChooseFacebookOrCode:(id)sender {
    NSInteger index = [self.connectionChooser selectedSegmentIndex];
    
    if (index == 0) { // facebook
        if (false == [FacebookConnectionManager isSessionOpened]) {
            [FacebookConnectionManager initializeFacebookSession];
        }
    } else {
        SynchronizeWithCodeView *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SynchronizeWithCodeView"];
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
}


@end
