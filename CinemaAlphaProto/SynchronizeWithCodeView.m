//
//  SynchronizeWithCodeView.m
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 30/01/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

@interface SynchronizeWithCodeView () <UITextFieldDelegate>
{
}

@end

@implementation SynchronizeWithCodeView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    StylizeWithScopeFont(self.titleLabel, 80);
    BorderedButton(self.validateCodeButton, ScopeBlue);
    
    NSArray *codeLabels = [NSArray arrayWithObjects:self.codeLabelA, self.codeLabelB, self.codeLabelC, self.codeLabelD, nil];
    
    for (UITextField * label in codeLabels) {
        CGRect frameRect = label.frame;
        frameRect.size.height = 100;
        [label setFrame:frameRect];
        [label setBorderStyle:UITextBorderStyleLine];
        [label.layer setBorderWidth:1.0f];
        [label.layer setBackgroundColor:Rgb2UIColor(25, 34, 43).CGColor];
        [label.layer setCornerRadius:0.1f];
        [label.layer setBorderColor:[ScopeBlue CGColor]];
        [label setFont:[UIFont fontWithName:@"Twofaced-Bold" size:28]];
        [label.layer setMasksToBounds:YES];
        
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ApiAssociationRefused object:nil queue:nil usingBlock:^(NSNotification *note)
    {
        [self.connexionWaitingAlert dismissWithClickedButtonIndex:0 animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Association refusée, vérifiez le code de jumelage des appareils." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (IBAction)onCodeEntered:(id)sender {
    NSArray *codeLabels = [NSArray arrayWithObjects:self.codeLabelA, self.codeLabelB, self.codeLabelC, self.codeLabelD, nil];
    BOOL missingDigit = NO;
    
    for (UITextField * label in codeLabels) {
        if ([label.text  isEqual: @""]) {
            [label.layer setBorderColor:[UIColor redColor].CGColor];
            missingDigit = YES;
        }
    }
    
    if (missingDigit) return;
    
    
    NSString *code = [NSString stringWithFormat:@"%@%@%@%@",
                       self.codeLabelA.text,
                       self.codeLabelB.text,
                       self.codeLabelC.text,
                       self.codeLabelD.text
                      ];
    
    [ApiDelegate requestForTokenWithCode:code];
    
    self.connexionWaitingAlert = [[UIAlertView alloc] initWithTitle:@"Connexion" message:@"Connexion en cours..." delegate:self cancelButtonTitle:nil otherButtonTitles:0, nil];
    
    [self.connexionWaitingAlert show];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ApiAssociatedWithToken object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        [self.connexionWaitingAlert dismissWithClickedButtonIndex:0 animated:YES];
        
        PushView(@"NoticeChooserView");
    }];
}

- (void)dismissKeyboard {
    [self.codeLabelA resignFirstResponder];
    [self.codeLabelB resignFirstResponder];
    [self.codeLabelC resignFirstResponder];
    [self.codeLabelD resignFirstResponder];
}

- (IBAction)backHome:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)didEnterDigit:(id)sender {
    if (((UITextField *) sender).text.length == 0) return;
    
    if (sender == self.codeLabelA) {
        [self.codeLabelB becomeFirstResponder];
    }
    if (sender == self.codeLabelB) {
        [self.codeLabelC becomeFirstResponder];
    }
    if (sender == self.codeLabelC) {
        [self.codeLabelD becomeFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    int length = [textField.text length] ;
    if (length >= 1 && ![string isEqualToString:@""]) {
        textField.text = [textField.text substringToIndex:1];
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.codeLabelD) {
        [self onCodeEntered:nil];
        [textField resignFirstResponder];
        return NO;
    }
    
    return YES;
}

@end
