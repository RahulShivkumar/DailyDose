//
//  Constants.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 4/26/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "Constants.h"

#define kNavBarColor [UIColor colorWithRed:180/255.0 green:12/255.0 blue:3/255.0 alpha:1.0]

@implementation Constants
+(CGFloat)window_height{
    return [UIScreen mainScreen].applicationFrame.size.height;
}


+(CGFloat)window_width{
    return [UIScreen mainScreen].applicationFrame.size.width;
}


#pragma mark - Compare Dates
+(BOOL)compareDate:(NSDate*)date1 withOtherdate:(NSDate*)date2{
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:date1];
    NSDate *firstDate = [cal dateFromComponents:components];
    
    components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:date2];
    NSDate *otherDate = [cal dateFromComponents:components];
    
    if([firstDate isEqualToDate:otherDate]) {
        return YES;
    }
    return NO;
}


#pragma mark - Setup NavBar
+ (void)setupNavbar:(UIViewController*)parentController {
    [parentController.navigationController.navigationBar setTranslucent:NO];
    [parentController.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [parentController.navigationController.navigationBar setBarTintColor:kNavBarColor];
    [parentController.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}
@end
