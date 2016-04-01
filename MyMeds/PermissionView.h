//
//  TryView.h
//  practice_iuview
//
//  Created by Tyler Ponder on 8/8/15.
//  Copyright (c) 2015 Tyler Ponder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationScheduler.h"

@protocol PermissionViewDelegate <NSObject>

@required
- (void)PermissionAllowed:(BOOL)allowed;

@end

@interface PermissionView : UIView <UIApplicationDelegate> {
    UIView *view;
}
@property(nonatomic, weak) id<PermissionViewDelegate> delegate;

- (void)show;

- (void)cancelClicked;

- (void)allowClicked;

+ (BOOL)showPermissionView;

+ (void)neverShowPermissionView;

@end

@interface UICustomButton : UIButton

@end

@interface showMeOrNot : DBObject <UIApplicationDelegate>

@property BOOL showMe;

+ (void)setTrue;

+ (void)setFalse;

+ (BOOL)getValue;

@end
