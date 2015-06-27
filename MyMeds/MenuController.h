//
//  MenuController.h
//  CDSideBar
//
//  Created by Rahul Shivkumar on 9/11/14.
//  Copyright (c) 2015 Rahul Shivkumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>




@protocol MenuControllerDelegate <NSObject>

- (void)menuButtonClicked:(int)index;

@end

@class TodayViewController;
@interface MenuController : NSObject
{
    UIView              *_backgroundMenuView;
    NSMutableArray      *_buttonList;
    TodayViewController *_vc;
    UIView              *_dimView;
    NSDate              *_startDate;
    NSDate              *_selectedDate;
}


@property (nonatomic, retain) UIColor *menuColor;
@property (nonatomic) BOOL isOpen;

@property (nonatomic, retain) id<MenuControllerDelegate> delegate;

- (MenuController*)initWithDate:(NSDate *)start andCurrentDate:(NSDate *)current andView:(UIView*)view andVC:(TodayViewController*)viewController;
- (void)showMenu;
- (void)dismissMenu;
-(BOOL)compareDate:(NSDate*)date1 withOtherdate:(NSDate*)date2;


@end
