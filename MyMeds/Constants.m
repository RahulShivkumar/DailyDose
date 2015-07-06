//
//  Constants.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 4/26/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "Constants.h"

#define kNavBarColor [UIColor colorWithRed:195/255.0 green:76/255.0 blue:60/255.0 alpha:1.0]

@implementation Constants

#pragma mark - Get height and width of window
+(CGFloat)window_height {
    return [UIScreen mainScreen].applicationFrame.size.height;
}


+(CGFloat)window_width {
    return [UIScreen mainScreen].applicationFrame.size.width;
}


#pragma mark - Compare Dates
+(BOOL)compareDate:(NSDate*)date1 withOtherdate:(NSDate*)date2 {
    
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


#pragma mark - Get NavBarColor
+ (UIColor*)getNavBarColor {
    return kNavBarColor;
}


#pragma mark - Get Current Hour
+ (NSInteger)getCurrentHour {
     NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
    
    return [components hour];
}


+ (NSInteger)getCurrentMinute {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
    
    return [components minute];
}

#pragma mark - Convert Time to String 
+ (NSString*)convertTimeToString:(float)t {
    
    int t2 = t;
    
    if(t2 > 12.5){
        t2 -= 12;
    }
    
    NSString *timeString = [NSString stringWithFormat:@"%d",(int)t2];
    
    
    if(t == (int)t){
        timeString = [timeString stringByAppendingString:@":00"];
    } else {
        timeString = [timeString stringByAppendingString:@":30"];
    }
    
    if (t >= 12){
        timeString = [timeString stringByAppendingString:[@" " stringByAppendingString:@"PM"]];
    } else{
        timeString = [timeString stringByAppendingString:[@" " stringByAppendingString:@"AM"]];
    }
    
    return timeString;
}

@end
