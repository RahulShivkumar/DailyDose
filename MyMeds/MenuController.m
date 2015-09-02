//
//  MenuController.m
//
//
//  Created by Rahul Shivkumar on 9/11/14.
//  Copyright (c) 2015 Rahul Shivkumar. All rights reserved.
//

#import "MenuController.h"
#import "CalendarButton.h"
#import "TodayViewController.h"

@implementation MenuController

@synthesize menuColor = _menuColor;
@synthesize isOpen = _isOpen;

#pragma mark Init

- (MenuController*)initWithDate:(NSDate *)start andCurrentDate:(NSDate *)current andView:(UIView*)view andVC:(TodayViewController*)viewController
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    _backgroundMenuView = [[UIView alloc] init];
    _menuColor = [UIColor whiteColor];
   _buttonList = [[NSMutableArray alloc] initWithCapacity:7];
    _vc = viewController;
    
    int index = 0;
    while (index < 7)
    {
        NSDate *buttonDate = [start dateByAddingTimeInterval: + index * 86400.0];
        CalendarButton *button = [[CalendarButton alloc] initWithDate:buttonDate andFrame:CGRectMake(0, view.frame.size.height/28.4 + (view.frame.size.height/7.1 * index), 90, view.frame.size.height/9.46)];
        
        //Default have first view Highlighted
        if(index == 0){
            [button addHighlight];
        }

        button.tag = index;
        [button addTarget:self action:@selector(onMenuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonList addObject:button];
  
        ++index;
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMenu)];
    [view addGestureRecognizer:singleTap];
    
    for (UIButton *button in _buttonList)
    {
        
        [_backgroundMenuView addSubview:button];
    }
    
    _dimView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    [_dimView setBackgroundColor:[UIColor blackColor]];
    [_dimView setAlpha:0.6];
    [view addSubview:_dimView];
    [_dimView setHidden:YES];
    _backgroundMenuView.frame = CGRectMake(view.frame.size.width, 0, 90, view.frame.size.height);
    _backgroundMenuView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0f];
    [view addSubview:_backgroundMenuView];
    
    return self;
}

#pragma mark Menu button action

- (void)dismissMenuWithSelection:(CalendarButton*)button
{
//    [UIView animateWithDuration:0.3f
//                          delay:0.0f
//         usingSpringWithDamping:.2f
//          initialSpringVelocity:10.f
//                        options:0 animations:^{
//                            button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
//                        }
//                     completion:^(BOOL finished) {
//                         [self dismissMenu];
//                     }];
    //Remove the highlighted button
    for(int i =0; i < 7; i++){
        CalendarButton * but = [_buttonList objectAtIndex:i];
        if(but.selected){
            [but removeHighlight];
        }
    }
    [button addHighlight];
    [self dismissMenu];
}

- (void)dismissMenu
{
    if (_isOpen)
    {
        _isOpen = !_isOpen;
       [self performDismissAnimation];
    }
}

- (void)showMenu
{
    if (!_isOpen)
    {
        _isOpen = !_isOpen;
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        [self hideTabBar:_vc.tabBarController];
    }
    else{
        [self dismissMenu];
    }
}

- (void)onMenuButtonClick:(CalendarButton*)button
{
    if ([self.delegate respondsToSelector:@selector(menuButtonClicked:)])
        [self.delegate menuButtonClicked:(int)button.tag];
    [self dismissMenuWithSelection:button];
}

#pragma mark - Animations

- (void)performDismissAnimation
{
    [UIView animateWithDuration:0.2 animations:^{
        _backgroundMenuView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    }
    completion:^(BOOL finished) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        [_dimView setHidden:YES];
        [self showTabBar:_vc.tabBarController];
    }];
}

- (void)performOpenAnimation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            _backgroundMenuView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -90, 0);
        }];
    });
//    for (UIButton *button in _buttonList)
//    {
//        [NSThread sleepForTimeInterval:0.02f];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            button.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 20, 0);
//            [UIView animateWithDuration:0.3f
//                                  delay:0.3f
//                 usingSpringWithDamping:.3f
//                  initialSpringVelocity:10.f
//                                options:0 animations:^{
//                                    button.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
//                                }
//                             completion:^(BOOL finished) {
//                             }];
//        });
//    }
}
#pragma mark - Dismiss Tab
- (void)hideTabBar:(UITabBarController *)tabbarcontroller
{
    [_vc.medsView setFrame:CGRectMake(0, 0, _vc.medsView.frame.size.width, _vc.medsView.frame.size.height + 74)];
    [UIView animateWithDuration:0.1 animations:^{
        for (UIView *view in tabbarcontroller.view.subviews) {
            if ([view isKindOfClass:[UITabBar class]]) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+49.f, view.frame.size.width, view.frame.size.height)];
            }
            else {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height+49.f)];
            }
        }
    } completion:^(BOOL finished) {
        //do smth after animation finishes
        [_dimView setHidden:NO];
        [self performSelectorInBackground:@selector(performOpenAnimation) withObject:nil];
        tabbarcontroller.tabBar.hidden = YES;
    }];
}
- (void)showTabBar:(UITabBarController *)tabbarcontroller
{
    [_vc.medsView setFrame:CGRectMake(0, 0, _vc.medsView.frame.size.width, _vc.medsView.frame.size.height - 74)];
    tabbarcontroller.tabBar.hidden = NO;
    [UIView animateWithDuration:0.1 animations:^{
        for (UIView *view in tabbarcontroller.view.subviews) {
            if ([view isKindOfClass:[UITabBar class]]) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y-49.f, view.frame.size.width, view.frame.size.height)];
            }
            else {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height-49.f)];
            }
        }
    } completion:^(BOOL finished) {
        //do smth after animation finishes
    }];
}

#pragma mark - Compare Dates 
-(BOOL)compareDate:(NSDate*)date1 withOtherdate:(NSDate*)date2{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:date1];
    NSDate *firstDate = [cal dateFromComponents:components];
    components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:date2];
    NSDate *otherDate = [cal dateFromComponents:components];
    
    if([firstDate isEqualToDate:otherDate]) {
        return YES;
    }
    return NO;
}

@end
