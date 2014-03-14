//
//  SynchronizeWithCodeView.h
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 30/01/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//


@interface SynchronizeWithCodeView : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *validateCodeButton;

@property (strong, nonatomic) UIAlertView *connexionWaitingAlert;

@property (weak, nonatomic) IBOutlet UIButton *helpButton;
@property (weak, nonatomic) IBOutlet UITextField *codeLabelA;
@property (weak, nonatomic) IBOutlet UITextField *codeLabelB;
@property (weak, nonatomic) IBOutlet UITextField *codeLabelC;
@property (weak, nonatomic) IBOutlet UITextField *codeLabelD;

@end
