//
//  EntryPointView.h
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 30/01/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//


/*
 * The app entry point view.
 */

@interface EntryPointView : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *connectionChooser;
@property (strong, nonatomic) UIAlertView *connexionWaitingAlert;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *synchronizeWithCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signoutButton;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

- (IBAction)doFacebookLogin:(id)sender;

@end
