//
//  TryView.m
//  practice_iuview
//
//  Created by Tyler Ponder on 8/8/15.
//  Copyright (c) 2015 Tyler Ponder. All rights reserved.
//

#import "PermissionView.h"

@implementation PermissionView


-(instancetype)init{
    
    int width = [UIScreen mainScreen].bounds.size.width;
    int height = [UIScreen mainScreen].bounds.size.height;
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(width/2-140, height/2-210, 280, 400)];
    view.backgroundColor = [UIColor clearColor];
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    
    UIView *body = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 355)];
    body.backgroundColor = [UIColor whiteColor];
    
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 356, 120, 43)];
    [cancel setTitle:@"Don't Use" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    cancel.backgroundColor = [UIColor whiteColor];
    [cancel setShowsTouchWhenHighlighted:true];
    [cancel addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *allow = [[UIButton alloc] initWithFrame:CGRectMake(121, 356, 159, 43)];
    [allow setTitle:@"Use Notifications" forState:UIControlStateNormal];
    [allow setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    allow.backgroundColor = [UIColor whiteColor];
    [allow setShowsTouchWhenHighlighted:true];
    [allow addTarget:self action:@selector(allowClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *title =[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 260, 20)];
    title.text = @"Local Notifications";
    
    UITextView *message = [[UITextView alloc] initWithFrame:CGRectMake(10, 30, 260, 70)];
    message.text = @"Upon adding your first medication, we suggest that you allow local notifications. Swiping left on notifications allows you to control the app without unlocking your phone.";
    
    UIImage *screenImage = [UIImage imageNamed:@"screen.png"];
    UIImageView *screenImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, 260, 180)];
    screenImageView.image = screenImage;
    
    
    
    UIImage *swipeImage = [UIImage imageNamed:@"swipe.png"];
    UIImageView *swipeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 285, 260, 60)];
    swipeImageView.image = swipeImage;
    
    
    
    [body addSubview:screenImageView];
    [body addSubview:swipeImageView];
    [body addSubview:title];
    [body addSubview:message];
    
    
    [view addSubview:body];
    [view addSubview:cancel];
    [view addSubview:allow];
    
    
    
    UIButton  *hi = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 20)];
    [view addSubview:hi];
    
    [self addSubview:view];
    
    self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    
    
    
    
    return self;
}



-(void)show{
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self];
}

-(void)cancelClicked{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    }];
    //[showMeOrNot setFalse];
    [self.delegate PermissionViewIsClosing];
}

-(void)allowClicked{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    }];
    //if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge
                                                                                                              categories:nil]];
        
    //}
    [showMeOrNot setFalse];
    [self.delegate PermissionViewIsClosing];
}


+(BOOL)showMe{
    return [showMeOrNot getValue];
}




@end











@implementation showMeOrNot

@dynamic showMe;

+(void)setTrue{
    
}

+(void)setFalse{
    showMeOrNot *smon = [showMeOrNot new];
    smon.showMe = false;
    [smon commit];
}

+(BOOL)getValue{
    int falsenum = [[[showMeOrNot query] where:@"showMe=0"] count];
    if (falsenum>0){
        return false;
    }
    return true;
}


@end

