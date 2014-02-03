//
//  EntryPointView.m
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 30/01/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "EntryPointView.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "SynchronizeWithCodeView.h"
#import "ApiDelegate.h"

@implementation EntryPointView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLoginWithFacebook:) name:@"UserDidLoginWithFacebook" object:nil];
    
    if (![[ApiDelegate sharedDelegate] token]) {
        self.connexionWaitingAlert = [[UIAlertView alloc] initWithTitle:@"Connexion..." message:@"Connexion à internet..." delegate:self cancelButtonTitle:nil otherButtonTitles:0, nil];
    
        [self.connexionWaitingAlert show];
    }
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ApiConnectionOpened object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self.connexionWaitingAlert dismissWithClickedButtonIndex:0 animated:YES];
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


- (void)userDidLoginWithFacebook:(NSNotification *)notification {
    NSLog(@"View responds !");
}

@end
