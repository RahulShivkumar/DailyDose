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
    
    
    [self.privacyCell setTarget:self action:@selector(showPrivacyPolicy)];
    [self.termsCell setTarget:self action:@selector(showTermsConditions)];
    self.privacyCell.defaultFooterTitle = @"© Klinik Solutions";
    
    [self.tutorialCell setTarget:self action:@selector(addTutorial)];
    
    [self.tableView setScrollEnabled:YES];
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

    } else {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Emailed Not Enabled"
                                                           message:@"Please enable your enable email through the default mail app"
                                                          delegate:nil
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"Continue", nil];
        [theAlert show];
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


- (void)showTermsConditions {
    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:@"http://klinik.io/terms.html"];
    [self.navigationController pushViewController:webViewController animated:YES];

}

- (void)showPrivacyPolicy {
    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:@"http://klinik.io/privacy.html"];
    [self.navigationController pushViewController:webViewController animated:YES];
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


#pragma mark - Add Tutorial

- (void)addTutorial {
    UIStoryboard *stb = [UIStoryboard storyboardWithName:@"Walkthrough" bundle:nil];
    RTWalkthroughViewController *walkthrough = [stb instantiateViewControllerWithIdentifier:@"walk"];
    
    RTWalkthroughPageViewController *pageOne = [stb instantiateViewControllerWithIdentifier:@"walk1"];
    RTWalkthroughPageViewController *pageTwo = [stb instantiateViewControllerWithIdentifier:@"walk2"];
    RTWalkthroughPageViewController *pageThree = [stb instantiateViewControllerWithIdentifier:@"walk3"];
    
    walkthrough.delegate = self;
    [walkthrough addViewController:pageOne];
    [walkthrough addViewController:pageTwo];
    [walkthrough addViewController:pageThree];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"walkthrough"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self presentViewController:walkthrough animated:YES completion:nil];
}

- (void)walkthroughControllerDidClose:(RTWalkthroughViewController *)controller {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
