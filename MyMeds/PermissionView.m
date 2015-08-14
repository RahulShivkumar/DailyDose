//
//  TryView.m
//  practice_iuview
//
//  Created by Tyler Ponder on 8/8/15.
//  Copyright (c) 2015 Tyler Ponder. All rights reserved.
//

#import "PermissionView.h"

@implementation PermissionView


- (instancetype)init{
    
    int width = [UIScreen mainScreen].bounds.size.width;
    int height = [UIScreen mainScreen].bounds.size.height;
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    
    view = [[UIView alloc] initWithFrame:CGRectMake(width/2-140, height/2-210, 280, 400)];
    view.backgroundColor = [UIColor clearColor];
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    
    UIView *body = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 355.5)];
    body.backgroundColor = [UIColor whiteColor];
    
    UICustomButton *cancel = [[UICustomButton alloc] initWithFrame:CGRectMake(0, 356, 120, 43)];
    [cancel setTitle:@"Don't Use" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    cancel.backgroundColor = [UIColor whiteColor];
    [cancel addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
    
    //UIButton *allow = [[UIButton alloc] initWithFrame:CGRectMake(121, 356, 159, 43)];
    UICustomButton *allow = [[UICustomButton alloc] initWithFrame:CGRectMake(0, 356, 280, 43)];
    [allow setTitle:@"Continue" forState:UIControlStateNormal];
    [allow setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    allow.backgroundColor = [UIColor whiteColor];
    [allow addTarget:self action:@selector(allowClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *title =[[UILabel alloc] initWithFrame:CGRectMake(10, 20, 260, 20)];
    title.text = @"Local Notifications";
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:18.0];
    
    UITextView *message = [[UITextView alloc] initWithFrame:CGRectMake(10, 40, 260, 60)];
    message.text = @"We suggest allowing notifications. This allows us to send you reminders & gives you better control over your meds!";
    message.textAlignment = NSTextAlignmentCenter;
    message.font = [UIFont systemFontOfSize:12.0];
    message.selectable = false;
    
    UIImage *screenImage = [UIImage imageNamed:@"screen.png"];
    UIImageView *screenImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 110, 260, 160)];
    screenImageView.image = screenImage;
    
    UIImage *swipeImage = [UIImage imageNamed:@"swipe.png"];
    UIImageView *swipeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 275, 260, 73)];
    swipeImageView.image = swipeImage;
    
    [body addSubview:screenImageView];
    [body addSubview:swipeImageView];
    [body addSubview:title];
    [body addSubview:message];
    
    [view addSubview:body];
    //[view addSubview:cancel];
    [view addSubview:allow];
    
    [self addSubview:view];
    
    self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    
    return self;
}



-(void)show{
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self];
}

-(void)cancelClicked{
    [showMeOrNot setFalse];
    [self.delegate PermissionAllowed:false];
}

-(void)allowClicked{
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge
                                                                                                              categories:nil]];
        
    }
    [showMeOrNot setFalse];
    [self.delegate PermissionAllowed:true];
}


+ (BOOL)showPermissionView{
    return [showMeOrNot getValue];
}

+ (void)neverShowPermissionView{
    [showMeOrNot setFalse];
}


@end






@implementation UICustomButton

-(void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.backgroundColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.9 alpha:1.0];

    }
    else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end


@implementation showMeOrNot

@dynamic showMe;

+ (void)setTrue{
    
}

+ (void)setFalse{
    showMeOrNot *smon = [showMeOrNot new];
    smon.showMe = false;
    [smon commit];
}

+ (BOOL)getValue{
    
    
    BOOL remoteNotificationsEnabled = false, noneEnabled,alertsEnabled, badgesEnabled, soundsEnabled;
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        // iOS8+
        remoteNotificationsEnabled = [UIApplication sharedApplication].isRegisteredForRemoteNotifications;
        
        UIUserNotificationSettings *userNotificationSettings = [UIApplication sharedApplication].currentUserNotificationSettings;
        
        noneEnabled = userNotificationSettings.types == UIUserNotificationTypeNone;
        alertsEnabled = userNotificationSettings.types & UIUserNotificationTypeAlert;
        badgesEnabled = userNotificationSettings.types & UIUserNotificationTypeBadge;
        soundsEnabled = userNotificationSettings.types & UIUserNotificationTypeSound;
        
    } else {
        // iOS7 and below
        UIRemoteNotificationType enabledRemoteNotificationTypes = [UIApplication sharedApplication].enabledRemoteNotificationTypes;
        
        noneEnabled = enabledRemoteNotificationTypes == UIRemoteNotificationTypeNone;
        alertsEnabled = enabledRemoteNotificationTypes & UIRemoteNotificationTypeAlert;
        badgesEnabled = enabledRemoteNotificationTypes & UIRemoteNotificationTypeBadge;
        soundsEnabled = enabledRemoteNotificationTypes & UIRemoteNotificationTypeSound;
    }
    
    if (!noneEnabled){
        return false;
    }
    
    int falsenum = [[[showMeOrNot query] where:@"showMe=0"] count];
    if (falsenum>0){
        return false;
    }
    return true;
}


@end




