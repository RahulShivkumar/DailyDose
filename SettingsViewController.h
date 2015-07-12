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
#import "Constants.h"
#import "Bohr.h"

@interface SettingsViewController : BOTableViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet BOButtonTableViewCell *buttonCell;

@end
