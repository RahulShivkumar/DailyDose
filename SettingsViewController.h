//
//  SettingsViewController.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 7/11/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "BOTableViewController.h"
#import "LTHPasscodeViewController.h"
#import "Constants.h"
#import "Bohr.h"
#import "SVWebViewController.h"

@interface SettingsViewController : BOTableViewController <MFMailComposeViewControllerDelegate, LTHPasscodeViewControllerDelegate>

- (void)showButtonAlert;
- (void)showPrivacyPolicy;
- (void)showTermsConditions;

@property (weak, nonatomic) IBOutlet BOButtonTableViewCell *buttonCell;
@property (weak, nonatomic) IBOutlet BOButtonTableViewCell *privacyCell;
@property (weak, nonatomic) IBOutlet BOButtonTableViewCell *termsCell;
@property (weak, nonatomic) IBOutlet BOButtonTableViewCell *securityCell;

@end
