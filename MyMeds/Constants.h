//
//  Constants.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 4/26/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Constants : NSObject

+ (CGFloat)window_height;
+ (CGFloat)window_width;

+ (BOOL)compareDate:(NSDate*)date1 withOtherdate:(NSDate*)date2;

+ (void)setupNavbar:(UIViewController*)parentController;
+ (void)setupMailNavBar;
+ (UIColor*)getNavBarColor;

+ (NSInteger)getCurrentHour;
+ (NSInteger)getCurrentMinute;
+ (int)getCurrentDay;
+ (NSString*)getCurrentDayFromDate:(NSDate*)date;

+ (NSString*)convertTimeToString:(float)t;


+ (void)addTextViewBorder:(UITextField*)textView withColor:(UIColor*)color;
+ (void)addButtonBorder:(UIButton*)button;

@end
