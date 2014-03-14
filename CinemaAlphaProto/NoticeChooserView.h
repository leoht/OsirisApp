//
//  NoticeChooserView.h
//  CinemaAlphaProto
//
//  Created by HETSCH Leonard on 14/03/14.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeChooserView : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UILabel *chooserTitle;

@end
