//
//  AppDelegate.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 1/26/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DBAccess/DBAccess.h>
#import "RTWalkthroughPageViewController.h"
#import "RTWalkthroughViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, DBDelegate>

@property(strong, nonatomic) UIWindow *window;
@property(strong, nonatomic) UINavigationController *navController;

- (NSString *)getUserID;

@end
