//
//  Constants.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 4/26/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "Constants.h"

#define kNavBarColor                                                           \
[UIColor colorWithRed:229 / 255.0 green:98 / 255.0 blue:92 / 255.0 alpha:1.0]

@implementation Constants

#pragma mark - Get height and width of window
+ (CGFloat)window_height {
    return [UIScreen mainScreen].applicationFrame.size.height;
}

+ (CGFloat)window_width {
    return [UIScreen mainScreen].applicationFrame.size.width;
}

#pragma mark - Compare Dates
+ (BOOL)compareDate:(NSDate *)date1 withOtherdate:(NSDate *)date2 {
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components =
    [cal components:(NSCalendarUnitEra | NSCalendarUnitYear |
                     NSCalendarUnitMonth | NSCalendarUnitDay)
           fromDate:date1];
    NSDate *firstDate = [cal dateFromComponents:components];
    
    components = [cal components:(NSCalendarUnitEra | NSCalendarUnitYear |
                                  NSCalendarUnitMonth | NSCalendarUnitDay)
                        fromDate:date2];
    NSDate *otherDate = [cal dateFromComponents:components];
    
    if ([firstDate isEqualToDate:otherDate]) {
        return YES;
    }
    return NO;
}

#pragma mark - Setup NavBar
+ (void)setupNavbar:(UIViewController *)parentController {
    [parentController.navigationController.navigationBar setTranslucent:NO];
    [parentController.navigationController.navigationBar
     setBarStyle:UIBarStyleDefault];
    [parentController.navigationController.navigationBar
     setBarTintColor:kNavBarColor];
    [parentController.navigationController.navigationBar
     setTintColor:[UIColor whiteColor]];
}

+ (void)setupMailNavBar {
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    [[UINavigationBar appearance] setBarTintColor:kNavBarColor];
    [UINavigationBar appearance].titleTextAttributes =
    [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                forKey:NSForegroundColorAttributeName];
}
#pragma mark - Get NavBarColor
+ (UIColor *)getNavBarColor {
    return kNavBarColor;
}

#pragma mark - Get Current Hour
+ (NSInteger)getCurrentHour {
    NSDateComponents *components = [[NSCalendar currentCalendar]
                                    components:NSCalendarUnitHour | NSCalendarUnitMinute |
                                    NSCalendarUnitSecond
                                    fromDate:[NSDate date]];
    
    return [components hour];
}

+ (NSInteger)getCurrentMinute {
    NSDateComponents *components = [[NSCalendar currentCalendar]
                                    components:NSCalendarUnitHour | NSCalendarUnitMinute |
                                    NSCalendarUnitSecond
                                    fromDate:[NSDate date]];
    
    return [components minute];
}

+ (int)getCurrentDay {
    NSCalendar *cal = [[NSCalendar alloc]
                       initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp =
    [cal components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    return (int)[comp weekday];
}

+ (NSString *)getCurrentDayFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    return [dateFormatter stringFromDate:date];
}
#pragma mark - Convert Time to String
+ (NSString *)convertTimeToString:(float)t {
    
    int t2 = t;
    
    if (t2 > 12.5) {
        t2 -= 12;
    }
    
    NSString *timeString = [NSString stringWithFormat:@"%d", (int)t2];
    
    if (t == (int)t) {
        timeString = [timeString stringByAppendingString:@":00"];
    } else {
        timeString = [timeString stringByAppendingString:@":30"];
    }
    
    if (t >= 12) {
        timeString = [timeString
                      stringByAppendingString:[@" " stringByAppendingString:@"PM"]];
    } else {
        timeString = [timeString
                      stringByAppendingString:[@" " stringByAppendingString:@"AM"]];
    }
    
    return timeString;
}

#pragma mark - Add borders

+ (void)addTextViewBorder:(UITextField *)textView withColor:(UIColor *)color {
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, textView.frame.size.height - 1,
                                    textView.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = color.CGColor;
    [textView.layer addSublayer:bottomBorder];
}

+ (void)addButtonBorder:(UIButton *)button {
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, button.frame.size.height - 1,
                                    button.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor whiteColor].CGColor;
    [button.layer addSublayer:bottomBorder];
}

@end
