//
//  SynchronizeWithCodeView.m
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 30/01/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//


@implementation SynchronizeWithCodeView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (IBAction)backButtonTouched:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)onCodeEntered:(id)sender {
    NSString *code = self.synchronizeCodeField.text;
    
    [ApiDelegate requestForTokenWithCode:code];
    
    self.synchronizeCodeField.hidden = true;
    self.validateCodeButton.hidden = true;
    self.backButton.hidden = true;
    
    self.connexionWaitingAlert = [[UIAlertView alloc] initWithTitle:@"Connexion" message:@"Connexion en cours..." delegate:self cancelButtonTitle:nil otherButtonTitles:0, nil];
    
    [self.connexionWaitingAlert show];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ApiAssociatedWithToken object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        [self.connexionWaitingAlert dismissWithClickedButtonIndex:0 animated:YES];
        
        MovieSummaryView *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MovieSummaryView"];
        NSString *token = [[ApiDelegate sharedDelegate] token];
        nextViewController.token = [NSString stringWithFormat:@"Got token : %@", token];
        [self.navigationController pushViewController:nextViewController animated:YES];
    }];
}

- (void)dismissKeyboard {
    [self.synchronizeCodeField resignFirstResponder];
}

@end
