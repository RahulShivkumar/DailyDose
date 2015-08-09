//
//  TryView.h
//  practice_iuview
//
//  Created by Tyler Ponder on 8/8/15.
//  Copyright (c) 2015 Tyler Ponder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DBAccess/DBAccess.h>
#import "NotificationScheduler.h"

@protocol PermissionViewDelegate <NSObject>

//@required
-(void)PermissionViewIsClosing;

@end

@interface PermissionView : UIView

@property (nonatomic, weak) id <PermissionViewDelegate> delegate;

-(void)show;

-(void)cancelClicked;

-(void)allowClicked;

+(BOOL)showMe;

@end



@interface showMeOrNot : DBObject

@property BOOL showMe;

+(void)setTrue;

+(void)setFalse;

+(BOOL)getValue;

@end
