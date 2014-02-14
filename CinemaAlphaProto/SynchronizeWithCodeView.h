//
//  SynchronizeWithCodeView.h
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 30/01/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//


@interface SynchronizeWithCodeView : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *synchronizeCodeField;
@property (weak, nonatomic) IBOutlet UIButton *validateCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (strong, nonatomic) UIAlertView *connexionWaitingAlert;


@end
