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
#import "RTWalkthroughViewController.h"
#import "RTWalkthroughPageViewController.h"

@interface SettingsViewController
: BOTableViewController <MFMailComposeViewControllerDelegate,
LTHPasscodeViewControllerDelegate,
RTWalkthroughPageViewControllerDelegate,
RTWalkthroughViewControllerDelegate>

- (void)showButtonAlert;
- (void)showPrivacyPolicy;
- (void)showTermsConditions;
- (void)addTutorial;

@property(weak, nonatomic) IBOutlet BOButtonTableViewCell *buttonCell;
@property(weak, nonatomic) IBOutlet BOButtonTableViewCell *privacyCell;
@property(weak, nonatomic) IBOutlet BOButtonTableViewCell *termsCell;
@property(weak, nonatomic) IBOutlet BOButtonTableViewCell *securityCell;
@property(weak, nonatomic) IBOutlet BOButtonTableViewCell *tutorialCell;

@end
