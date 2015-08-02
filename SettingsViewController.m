//
//  SettingsViewController.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 7/11/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)setup {
    [Constants setupNavbar:self];
    [self.navigationItem setTitle:@"Settings"];
    
    
    [self.securityCell setTarget:self action:@selector(securityToggle)];
    [self setSecurityTitle];

    [self.buttonCell setTarget:self action:@selector(showButtonAlert)];
    self.buttonCell.defaultFooterTitle = @"© Klinik Solutions";
    
    
    
    [self.tableView setScrollEnabled:NO];
}


- (void)showButtonAlert {
    if ([MFMailComposeViewController canSendMail]) {
        [Constants setupMailNavBar];
        
        MFMailComposeViewController *composeViewController = [MFMailComposeViewController new];
        [composeViewController setMailComposeDelegate:self];
        NSArray *recipients = [NSArray arrayWithObjects:@"feedback@klinik.io", nil];
        [composeViewController setToRecipients:recipients];
        [composeViewController setSubject:@"Feedback"];
        [composeViewController.navigationBar setTintColor:[UIColor whiteColor]];
        
        [self presentViewController:composeViewController animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];

    }
}


- (void)securityToggle {
    LTHPasscodeViewController *pvc = [LTHPasscodeViewController sharedUser];
    pvc.delegate = self;
    if ([LTHPasscodeViewController doesPasscodeExist] &&
        [LTHPasscodeViewController didPasscodeTimerEnd]) {
        [pvc showForDisablingPasscodeInViewController:self asModal:NO];
    }else{
        [pvc showForEnablingPasscodeInViewController:self asModal:NO];
    }
}

- (void)setSecurityTitle {
    if ([LTHPasscodeViewController doesPasscodeExist] &&
        [LTHPasscodeViewController didPasscodeTimerEnd]) {
        self.securityCell.textLabel.text = @"Disable Security Lock";
    }else{
        self.securityCell.textLabel.text = @"Enable Security Lock";
    }
}




# pragma mark - LTHPasscodeViewController Delegates

- (void)passcodeViewControllerWillClose {
    [self setSecurityTitle];
}



#pragma mark - Mail Delegate 
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    //Add an alert in case of failure
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
