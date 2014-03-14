//
//  Macros.h
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 31/01/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define ScopeBlue Rgb2UIColor(4, 229, 232)

#define BorderedButton(button, uiColor) [[button layer] setBorderWidth:1.0f];  \
                                        [[button layer] setMasksToBounds:YES]; \
                                        [[button layer] setBorderColor:uiColor.CGColor];

#define StylizeWithScopeFont(view, s)   [view setFont:[UIFont fontWithName:@"Twofaced-Bold" size:s]]

#define PushView(VIEW)                  UIViewController *nextViewController = \
                                        [self.storyboard instantiateViewControllerWithIdentifier:VIEW]; \
                                        [self.navigationController pushViewController:nextViewController animated:YES];

#define PopView(VIEW)                   UIViewController *nextViewController = \
                                        [self.storyboard instantiateViewControllerWithIdentifier:VIEW]; \
                                        [self.navigationController popToViewController:nextViewController animated:YES];

#define SegueTo(SEGUE)                  [self performSegueWithIdentifier:SEGUE sender:self];