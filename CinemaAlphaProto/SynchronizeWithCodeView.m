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
    
    NSArray *codeLabels = [NSArray arrayWithObjects:self.codeLabelA, self.codeLabelB, self.codeLabelC, self.codeLabelD, nil];
    
    for (UITextField * label in codeLabels) {
        [label setBorderStyle:UITextBorderStyleNone];
        [label.layer setBackgroundColor:[UIColor whiteColor].CGColor];
        [label.layer setCornerRadius:0.1f];
        [label setFont:[UIFont fontWithName:@"Twofaced-Bold" size:28]];
        
    }
    
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
    NSString *code = [NSString stringWithFormat:@"%@%@%@%@",
                       self.codeLabelA.text,
                       self.codeLabelB.text,
                       self.codeLabelC.text,
                       self.codeLabelD.text
                      ];
    
    [ApiDelegate requestForTokenWithCode:code];
    
    self.codeLabelA.hidden = true;
    self.validateCodeButton.hidden = true;
    self.backButton.hidden = true;
    
    self.connexionWaitingAlert = [[UIAlertView alloc] initWithTitle:@"Connexion" message:@"Connexion en cours..." delegate:self cancelButtonTitle:nil otherButtonTitles:0, nil];
    
    [self.connexionWaitingAlert show];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ApiAssociatedWithToken object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        [self.connexionWaitingAlert dismissWithClickedButtonIndex:0 animated:YES];
        
        PushView(@"MovieSummaryView");
    }];
}

- (void)dismissKeyboard {
    [self.codeLabelA resignFirstResponder];
    [self.codeLabelB resignFirstResponder];
    [self.codeLabelC resignFirstResponder];
    [self.codeLabelD resignFirstResponder];
}

@end
