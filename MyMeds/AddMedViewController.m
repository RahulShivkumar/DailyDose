//
//  AddMedViewController.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 3/17/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "AddMedViewController.h"
#import "AZNotification.h"
#import <QuartzCore/QuartzCore.h>

@interface AddMedViewController ()

@end

#define uid @"uid"
#define kBGColor [UIColor colorWithRed:229/255.0 green:98/255.0 blue:92/255.0 alpha:1.0]


@implementation AddMedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - View Setup
//Method called to setupviews
- (void)setupViews {
    timePickers = [[NSMutableArray alloc] init];
    times = [[NSMutableArray alloc] init];
    amPm = [[NSMutableArray alloc] init];
    //[self.view setBackgroundColor:bgColor];
 
    [self.view setBackgroundColor:kBGColor];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.scrollView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Constants window_width], 50)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:headerView];
    
    cancel = [[UIButton alloc]initWithFrame:CGRectMake(0, 15, 60, 40)];
    [cancel.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
    [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancel.titleLabel setTextColor:[UIColor whiteColor]];
    [headerView addSubview:cancel];
    [cancel addTarget:self action:@selector(closeWindow:) forControlEvents:UIControlEventTouchUpInside];
    
    done = [[UIButton alloc]initWithFrame:CGRectMake([Constants window_width]-60, 15, 60, 40)];
    [addMed setTextAlignment:NSTextAlignmentRight];
    [done.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [done setTitle:@"Done" forState:UIControlStateNormal];
    [done.titleLabel setTextColor:[UIColor whiteColor]];
    [headerView addSubview:done];
    [done addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    
    addMed = [[UILabel alloc]initWithFrame:CGRectMake([Constants window_width]/2 -100, 15, 200, 40)];
    [addMed setTextAlignment:NSTextAlignmentCenter];
    [addMed setFont:[UIFont fontWithName:@"HelveticaNeue" size:18]];
    [addMed setText:@"New Medication"];
    [addMed setTextColor:[UIColor whiteColor]];
    [headerView addSubview:addMed];
    
    name = [[UILabel alloc]initWithFrame:CGRectMake(7, [Constants window_height] * 0.12, 150, 20)];
    [name setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    [name setText:@"Medication Name"];
    [name setTextColor:[UIColor whiteColor]];
    [self.scrollView addSubview:name];

    medName = [[UITextField alloc] initWithFrame:CGRectMake(0, [Constants window_height] * 0.12 + 20, [Constants window_width], [Constants window_height]/15)];
    [medName setBackgroundColor:[UIColor clearColor]];
    [medName setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:25]];
    [medName setTextColor:[UIColor whiteColor]];
    [medName setTintColor:[UIColor whiteColor]];
    [medName setDelegate:self];
    [medName.layer setSublayerTransform:CATransform3DMakeTranslation(7, 0, 0)];
    [self addTextViewBorder:medName];
    [self.scrollView  addSubview:medName];
    
    generic = [[UILabel alloc]initWithFrame:CGRectMake(7, [Constants window_height] * 0.23, 150, 20)];
    [generic setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    [generic setText:@"Chemical Name"];
    [generic setTextColor:[UIColor whiteColor]];
    [self.scrollView  addSubview:generic];
    
    chemName = [[UITextField alloc] initWithFrame:CGRectMake(0, [Constants window_height] * 0.23 + 20, [Constants window_width], [Constants window_height]/15)];
    [chemName setBackgroundColor:[UIColor clearColor]];
    [chemName setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:25]];
    [chemName setTintColor:[UIColor whiteColor]];
    [chemName setTextColor:[UIColor whiteColor]];
    [chemName.layer setSublayerTransform:CATransform3DMakeTranslation(7, 0, 0)];
    
    [chemName setDelegate:self];
    [self addTextViewBorder:chemName];
    [self.scrollView  addSubview:chemName];
    
    dosage = [[UILabel alloc]initWithFrame:CGRectMake(7, [Constants window_height] * 0.34, 150, 20)];
    [dosage setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    [dosage setText:@"Dosage"];
    [dosage setTextColor:[UIColor whiteColor]];
    [self.scrollView  addSubview:dosage];
    
    dosageNum = [[UITextField alloc] initWithFrame:CGRectMake(0, [Constants window_height] * 0.34 + 20, [Constants window_width], [Constants window_height]/15)];
    [dosageNum setBackgroundColor:[UIColor clearColor]];
    [dosageNum setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:25]];
    [dosageNum setTintColor:[UIColor whiteColor]];
    [dosageNum setTextColor:[UIColor whiteColor]];
    [dosageNum.layer setSublayerTransform:CATransform3DMakeTranslation(7, 0, 0)];
    [dosageNum setDelegate:self];
    [self addTextViewBorder:dosageNum];
    [self.scrollView  addSubview:dosageNum];
    
    days = [[UILabel alloc]initWithFrame:CGRectMake(7, [Constants window_height] * 0.45, 150, 20)];
    [days setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    [days setText:@"Days Taken"];
    [days setTextColor:[UIColor whiteColor]];
    [self.scrollView  addSubview:days];
    
    dayPicker = [[DayPicker alloc] initWithFrame:CGRectMake(0, [Constants window_height] * 0.45 + 20, [Constants window_width], [Constants window_height]/10)
                                           andBG:kBGColor
                                           andTc:[UIColor whiteColor]
                                          andHtc:kBGColor
                                           andHl:[UIColor whiteColor]
                                    andTextviews:[NSMutableArray arrayWithObjects:medName, chemName, dosageNum, nil]];
    [self.scrollView  addSubview:dayPicker];
    
    time = [[UILabel alloc]initWithFrame:CGRectMake(7, [Constants window_height] * 0.60, 150, 20)];
    [time setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    [time setText:@"Time Taken"];
    [time setTextColor:[UIColor whiteColor]];
    [self.scrollView  addSubview:time];
    
    timePicker = [[UIButton alloc] initWithFrame:CGRectMake(0, [Constants window_height] * 0.60 + 20, [Constants window_width], [Constants window_height]/10)];
    [timePicker setBackgroundColor:[UIColor whiteColor]];
    [timePicker setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [timePicker.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:30]];
    [timePicker setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [timePicker setContentEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
    [timePicker setTitle:@"Add Time" forState:UIControlStateNormal];
    [timePicker setTintColor:[UIColor whiteColor]];
    [timePicker setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [timePicker setBackgroundColor:[UIColor clearColor]];
    [timePicker setTag:0];
    [timePicker addTarget:self action:@selector(setDate:) forControlEvents:UIControlEventTouchUpInside];
    [self addButtonBorder:timePicker];
    
    datePicker = [RMDateSelectionViewController dateSelectionController];
    [datePicker setDelegate:self];
    datePicker.datePicker.datePickerMode = UIDatePickerModeTime;
     [self manipulateTime];
    [datePicker.datePicker setMinuteInterval:30];
    [timePickers addObject:timePicker];
    [self.scrollView  addSubview:timePicker];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                  initWithTarget:self
                                  action:@selector(dismissKeyboard)];
    
    [self.scrollView addGestureRecognizer:tap];
  //  [dayPicker addGestureRecognizer:tap];
}


- (void)addTextViewBorder:(UITextField*)textView {
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, textView.frame.size.height - 1, textView.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor whiteColor].CGColor;
    [textView.layer addSublayer:bottomBorder];
}


- (void)addButtonBorder:(UIButton*)button {
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, button.frame.size.height - 1, button.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor whiteColor].CGColor;
    [button.layer addSublayer:bottomBorder];
}


#pragma mark - DatePicker Delegate
- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate {
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *currentTime = [dateFormatter stringFromDate:aDate];
    
    UIButton *button = [timePickers objectAtIndex:selectedTag];
    [button setTitle:currentTime forState:UIControlStateNormal];
    
    [dateFormatter setDateFormat:@"a"];
    NSString *tempAmPm = [dateFormatter stringFromDate:aDate];
    [amPm addObject:tempAmPm];
    
    [dateFormatter setDateFormat:@"hh"];
    NSString *tempHours = [dateFormatter stringFromDate:aDate];
    [dateFormatter setDateFormat:@"mm"];
    NSString *tempMins = [dateFormatter stringFromDate:aDate];
    
    [self addTimeWithHour:tempHours
                  andMins:tempMins
                  andAmPm:tempAmPm];
    //Convert Current Time to Integer
    if (selectedTag == [timePickers count] -1){
        [self createButton];
    }
}


#pragma mark - Create new Button
- (void)createButton {
    UIButton *bottomBut = [timePickers objectAtIndex:[timePickers count] - 1];
    
    UIButton *newButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bottomBut.frame) + 2, [Constants window_width], [Constants window_height]/10)];
    
    [newButton setBackgroundColor:[UIColor whiteColor]];
    [newButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [newButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:30]];
    [newButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [newButton setContentEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
    [newButton setTintColor:[UIColor whiteColor]];
    [newButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newButton setBackgroundColor:[UIColor clearColor]];
    [newButton setTitle:@"Add Time" forState:UIControlStateNormal];
    [newButton setTag:(int)[timePickers count]];
    
    [newButton addTarget:self action:@selector(setDate:)
        forControlEvents:UIControlEventTouchUpInside];
    
    [timePickers addObject:newButton];
    [self addButtonBorder:newButton];
    [self.scrollView addSubview:newButton];
    
    //Set up Scrolling
    if (CGRectGetMaxY(self.scrollView.frame) < CGRectGetMaxY(newButton.frame)){
        [self.scrollView setContentSize:(CGSizeMake([Constants window_width], CGRectGetMaxY(newButton.frame)))];
    }
}


#pragma  mark - Textfield Method
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}


- (void)dismissKeyboard {
    [medName resignFirstResponder];
    [chemName resignFirstResponder];
    [dosageNum resignFirstResponder];
}


#pragma mark - Manipulate time setup
- (void)manipulateTime {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) //Need to pass all this so we can get the day right later
                                               fromDate:[NSDate date]];
    
    [components setCalendar:calendar]; //even though you got the components from a calendar, you have to manually set the calendar anyways, I don't know why but it doesn't work otherwise
    NSInteger hour = components.hour;
    NSInteger minute = components.minute;
    
    //my rounding logic is maybe off a minute or so
    if (minute > 45) {
        minute = 0;
        hour += 1;
    } else if (minute > 15) {
        minute = 30;
    } else {
        minute = 0;
    }
    
    //Now we set the componentns to our rounded values
    components.hour = hour;
    components.minute = minute;
    
    // Now we get the date back from our modified date components.
    NSDate *toNearestHalfHour = [components date];
    datePicker.datePicker.date = toNearestHalfHour;
}

//Helper to convert a time string into an actual time block for the times array
- (void)addTimeWithHour:(NSString *)hour andMins:(NSString *)mins andAmPm:(NSString *)ampm {
    float hr = [hour intValue];
    if ([ampm isEqualToString:@"PM"]){
        if(hr != 12 && hr != 12.5){
            hr = hr + 12;
        }
    }
    if([mins isEqualToString:@"30"]){
        hr = hr + 0.5;
    }
    [times addObject:[NSNumber numberWithFloat:hr]];
}


#pragma mark - IBActions
//Method called when datePicker date is chosen
- (IBAction)setDate:(id)sender {
     UIButton *buttonClicked = (UIButton *)sender;
    selectedTag = (int)buttonClicked.tag;
    [datePicker show];
}


//Method called to close window
- (IBAction)closeWindow:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


//Method called when "done" button is hit. Creates new entries for meds into meds and today_meds.
- (IBAction)done:(id)sender {
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"dailydosedb.sql"];
    NSInteger hour;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
    hour = [components hour];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"MM/dd/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:[NSDate date]];

    if([times count] != 0 && medName.text && medName.text.length > 0 && chemName.text && chemName.text.length > 0 && dosageNum.text && dosageNum.text.length > 0){
        
        //Setup Local Notifications on a separate thread
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self setupLocalNotifs];
        });
        int completed;
            
            for (int i = 0; i < [times count]; i++){
                NSString *query = [NSString stringWithFormat: @"insert into meds(med_name, chem_name, dosage, time, ampm, monday, tuesday, wednesday, thursday, friday, saturday, sunday, completed, start_date) values ('%@', '%@', '%@', %f, '%@', '%d', %d, %d, %d, %d, %d, %d, 0, '%@')", medName.text, chemName.text, dosageNum.text, [[times objectAtIndex:i] floatValue], [amPm objectAtIndex:i], [[dayPicker.days objectForKey:@"mon"] intValue],[[dayPicker.days objectForKey:@"tue"] intValue], [[dayPicker.days objectForKey:@"wed"] intValue], [[dayPicker.days objectForKey:@"thur"] intValue], [[dayPicker.days objectForKey:@"fri"] intValue], [[dayPicker.days objectForKey:@"sat"] intValue], [[dayPicker.days objectForKey:@"sun"] intValue], dateString];
                [self.dbManager executeQuery:query];
                
                //TO-DO fix bug where med is added to today's meds table
//                if(hour <= [[times objectAtIndex:i] floatValue]){
                    completed = 0;
                    query = [NSString stringWithFormat: @"insert into today_meds(med_name, chem_name, dosage, time, ampm, completed) values ('%@', '%@', '%@', %f, '%@', %d)",medName.text, chemName.text, dosageNum.text, [[times objectAtIndex:i] floatValue],  [amPm objectAtIndex:i], completed];
                    [self.dbManager executeQuery:query];
              //  }

            }
        [self dismissViewControllerAnimated:YES
                                 completion:nil];
    }
    else{
         [AZNotification showNotificationWithTitle:@"Please Add All Information!"
                                        controller:self notificationType:AZNotificationTypeWarning];
    }
    
    
}


#pragma mark - Setup Local Notifs
//Method called to setup local notifications
//TO DO - Fix this method logic
- (void)setupLocalNotifs {
    NSArray *daysOfWeek = [[NSArray alloc] initWithObjects:@"sun", @"mon", @"tue", @"wed", @"thur", @"fri", @"sat", nil];
    BOOL flag = NO;
    for (int j = 0; j < [times count]; j++){
        for (NSString *day in daysOfWeek){
            if([[dayPicker.days objectForKey:day] intValue] == 1){
                UIApplication *app = [UIApplication sharedApplication];
                NSArray *eventArray = [app scheduledLocalNotifications];
                for (int i=0; i<[eventArray count]; i++)
                {
                    UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
                    NSDictionary *userInfoCurrent = oneEvent.userInfo;
                    NSString *identifier = [userInfoCurrent objectForKey:uid];
                    NSString *prefix = [day stringByAppendingString:[NSString stringWithFormat:@"%@",[times objectAtIndex:j]]];

                    if ([identifier hasPrefix:prefix])
                    {
                        flag = YES;
                        [app cancelLocalNotification:oneEvent];
                        int number = [[identifier substringFromIndex:[prefix length]] intValue];
                        
                        [self initLocalNotif:number andDay:day
                                     andTime:[NSString stringWithFormat:@"%@",[times objectAtIndex:j]]
                                 andDayIndex:(int)[daysOfWeek indexOfObject:day]];
                        
                        break;
                    }
                }
                if (!flag){
                    int number = 0;
                    [self initLocalNotif:number andDay:day
                                 andTime:[NSString stringWithFormat:@"%@", [times objectAtIndex:j]]
                             andDayIndex:(int)[daysOfWeek indexOfObject:day]];
                    
                }
                
            }
        }
    }
}


//Method called to create the local notifications
- (void)initLocalNotif:(int)number andDay:(NSString *)day andTime:(NSString*)timeString andDayIndex:(int)dayIndex {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now = [NSDate date];
    
    NSDateComponents *componentsForFireDate = [calendar components:(NSYearCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit| NSSecondCalendarUnit | NSWeekdayCalendarUnit) fromDate: now];
    [componentsForFireDate setWeekday: dayIndex] ;
    
    float timeFloat = [timeString floatValue];
    int minute = 0;
    if (timeFloat != (int)timeFloat){
        timeFloat = (int)timeFloat;
        minute = 30;
    }
    [componentsForFireDate setHour: timeFloat] ;
    [componentsForFireDate setMinute:minute] ;
    [componentsForFireDate setSecond:0] ;
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [calendar dateFromComponents:componentsForFireDate];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterSpellOutStyle];
    number += 1;
    NSString *s = [f stringFromNumber:[NSNumber numberWithInt:number]];
    NSString *alertBody;
    
    if (number == 1) {
        alertBody = [s stringByAppendingString:@" med!"];
    } else {
        alertBody = [s stringByAppendingString:@" meds!"];
    }
    
    localNotification.alertBody = [@"Time to take " stringByAppendingString:alertBody];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.repeatInterval = NSWeekCalendarUnit;
    
    NSString *key = [timeString stringByAppendingString:[NSString stringWithFormat:@"%d", number]];
    key = [day stringByAppendingString:key];
    
    [localNotification setUserInfo:[NSDictionary dictionaryWithObject:key forKey:uid]];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

@end
