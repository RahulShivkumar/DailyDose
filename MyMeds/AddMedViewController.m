//
//  AddMedViewController.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 3/17/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "AddMedViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface AddMedViewController ()

@end

@implementation AddMedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Setup
-(void)setupView{
    timePickers = [[NSMutableArray alloc] init];
    times = [[NSMutableArray alloc] init];
    amPm = [[NSMutableArray alloc] init];
    [self.view setBackgroundColor:[UIColor colorWithRed:194/255.0 green:59/255.0 blue:34/255.0 alpha:1.0]];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.scrollView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Constants window_width], 50)];
    [headerView setBackgroundColor:[UIColor colorWithRed:194/255.0 green:59/255.0 blue:34/255.0 alpha:1.0]];
    [self.view addSubview:headerView];
    
    cancel = [[UIButton alloc]initWithFrame:CGRectMake(0, 15, 60, 40)];
    [cancel.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
    [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancel.titleLabel setTextColor:[UIColor whiteColor]];
    [headerView addSubview:cancel];
    [cancel addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    
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
    [medName setBackgroundColor:[UIColor whiteColor]];
    [medName setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:25]];
    [medName setTintColor:[UIColor blackColor]];
    [medName setDelegate:self];
    [medName.layer setSublayerTransform:CATransform3DMakeTranslation(7, 0, 0)];
    [self.scrollView  addSubview:medName];
    
    generic = [[UILabel alloc]initWithFrame:CGRectMake(7, [Constants window_height] * 0.23, 150, 20)];
    [generic setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    [generic setText:@"Chemical Name"];
    [generic setTextColor:[UIColor whiteColor]];
    [self.scrollView  addSubview:generic];
    
    chemName = [[UITextField alloc] initWithFrame:CGRectMake(0, [Constants window_height] * 0.23 + 20, [Constants window_width], [Constants window_height]/15)];
    [chemName setBackgroundColor:[UIColor whiteColor]];
    [chemName setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:25]];
    [chemName setTintColor:[UIColor blackColor]];
    [chemName.layer setSublayerTransform:CATransform3DMakeTranslation(7, 0, 0)];
    [chemName setDelegate:self];
    [self.scrollView  addSubview:chemName];
    
    dosage = [[UILabel alloc]initWithFrame:CGRectMake(7, [Constants window_height] * 0.34, 150, 20)];
    [dosage setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    [dosage setText:@"Dosage"];
    [dosage setTextColor:[UIColor whiteColor]];
    [self.scrollView  addSubview:dosage];
    
    dosageNum = [[UITextField alloc] initWithFrame:CGRectMake(0, [Constants window_height] * 0.34 + 20, [Constants window_width], [Constants window_height]/15)];
    [dosageNum setBackgroundColor:[UIColor whiteColor]];
    [dosageNum setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:25]];
    [dosageNum setTintColor:[UIColor blackColor]];
    [dosageNum.layer setSublayerTransform:CATransform3DMakeTranslation(7, 0, 0)];
    [dosageNum setDelegate:self];
    [self.scrollView  addSubview:dosageNum];
    
    days = [[UILabel alloc]initWithFrame:CGRectMake(7, [Constants window_height] * 0.45, 150, 20)];
    [days setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    [days setText:@"Days Taken"];
    [days setTextColor:[UIColor whiteColor]];
    [self.scrollView  addSubview:days];
    
    dayPicker = [[DayPicker alloc] initWithFrame:CGRectMake(0, [Constants window_height] * 0.45 + 20, [Constants window_width], [Constants window_height]/10) andBG:[UIColor whiteColor] andTc:[UIColor blackColor] andHtc:[UIColor whiteColor] andHl:[UIColor colorWithRed:194/255.0 green:59/255.0 blue:34/255.0 alpha:1.0] andTextviews:[NSMutableArray arrayWithObjects:medName, chemName, dosageNum, nil]];
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
    [timePicker setTintColor:[UIColor blackColor]];
    [timePicker setTag:0];
    [timePicker addTarget:self action:@selector(setDate:) forControlEvents:UIControlEventTouchUpInside];
    
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




#pragma mark - DatePicker Delegate
- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate {
    //Do something
    
//    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
//    localNotification.fireDate = aDate;
//    localNotification.alertBody = @"Just Testing";
//    localNotification.timeZone = [NSTimeZone defaultTimeZone];
//    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];

   
    UIButton *button = [timePickers objectAtIndex:selectedTag];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *currentTime = [dateFormatter stringFromDate:aDate];
    [button setTitle:currentTime forState:UIControlStateNormal];
    
    [dateFormatter setDateFormat:@"a"];
    NSString *tempAmPm = [dateFormatter stringFromDate:aDate];
    [amPm addObject:tempAmPm];
    
    [dateFormatter setDateFormat:@"hh"];
    NSString *tempHours = [dateFormatter stringFromDate:aDate];
    [dateFormatter setDateFormat:@"mm"];
    NSString *tempMins = [dateFormatter stringFromDate:aDate];
    
    [self addTimeWithHour:tempHours andMins:tempMins andAmPm:tempAmPm];
    //Convert Current Time to Integer
    if (selectedTag == [timePickers count] -1){
        [self createButton];
    }

}
#pragma mark - Create new Button
-(void)createButton{
    UIButton *bottomBut = [timePickers objectAtIndex:[timePickers count] - 1];
    UIButton *newButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bottomBut.frame) + 2, [Constants window_width], [Constants window_height]/10)];
    [newButton setBackgroundColor:[UIColor whiteColor]];
    [newButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [newButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:30]];
    [newButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [newButton setContentEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
    [newButton setTintColor:[UIColor blackColor]];
    [newButton setTitle:@"Add Time" forState:UIControlStateNormal];
    [self.scrollView addSubview:newButton];
    [newButton setTag:(int)[timePickers count]];
    [newButton addTarget:self action:@selector(setDate:) forControlEvents:UIControlEventTouchUpInside];
    [timePickers addObject:newButton];
    
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
-(void)dismissKeyboard {
    [medName resignFirstResponder];
    [chemName resignFirstResponder];
    [dosageNum resignFirstResponder];
}

#pragma mark - Manipulate time setup
-(void)manipulateTime{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) //Need to pass all this so we can get the day right later
                                               fromDate:[NSDate date]];
    [components setCalendar:calendar]; //even though you got the components from a calendar, you have to manually set the calendar anyways, I don't know why but it doesn't work otherwise
    NSInteger hour = components.hour;
    NSInteger minute = components.minute;
    
    //my rounding logic is maybe off a minute or so
    if (minute > 45)
    {
        minute = 0;
        hour += 1;
    }
    else if (minute > 15)
    {
        minute = 30;
    }
    else
    {
        minute = 0;
    }
    
    //Now we set the componentns to our rounded values
    components.hour = hour;
    components.minute = minute;
    
    // Now we get the date back from our modified date components.
    NSDate *toNearestHalfHour = [components date];
    datePicker.datePicker.date = toNearestHalfHour;
}

-(void)addTimeWithHour:(NSString *)hour andMins:(NSString *)mins andAmPm:(NSString *)ampm{
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
//-(IBAction)selectDate:(id)sender{
//    UIButton *buttonClicked = (UIButton *)sender;
//    UITextField *TField = [timePickers objectAtIndex:buttonClicked.tag];
//    [TField resignFirstResponder];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"hh:mm a"];
//    NSString *currentTime = [dateFormatter stringFromDate:datePicker.date];
//    [TField setText:currentTime];
//    
//    [dateFormatter setDateFormat:@"a"];
//    NSString *tempAmPm = [dateFormatter stringFromDate:datePicker.date];
//    [amPm addObject:tempAmPm];
//    
//    [dateFormatter setDateFormat:@"hh"];
//    NSString *tempHours = [dateFormatter stringFromDate:datePicker.date];
//    [dateFormatter setDateFormat:@"mm"];
//     NSString *tempMins = [dateFormatter stringFromDate:datePicker.date];
//    
//    [self addTimeWithHour:tempHours andMins:tempMins andAmPm:tempAmPm];
//    //Convert Current Time to Integer
//    if (buttonClicked.tag == [timePickers count] -1){
//        [self createB];
//    }
//}
-(IBAction)setDate:(id)sender{
     UIButton *buttonClicked = (UIButton *)sender;
    selectedTag = (int)buttonClicked.tag;
    [datePicker show];
}
-(IBAction)closeWindow:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)done:(id)sender{
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"dailydosedb.sql"];
    int completed = 0;
    NSInteger hour;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
    hour= [components hour];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"MM/dd/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
    
    for (int i = 0; i < [times count]; i++){
        NSString *query = [NSString stringWithFormat: @"insert into meds(med_name, chem_name, dosage, time, ampm, monday, tuesday, wednesday, thursday, friday, saturday, sunday, completed, start_date) values ('%@', '%@', '%@', %f, '%@', '%d', %d, %d, %d, %d, %d, %d, 0, '%@')", medName.text, chemName.text, dosageNum.text, [[times objectAtIndex:i] floatValue], [amPm objectAtIndex:i], [[dayPicker.days objectForKey:@"mon"] intValue],[[dayPicker.days objectForKey:@"tue"] intValue], [[dayPicker.days objectForKey:@"wed"] intValue], [[dayPicker.days objectForKey:@"thur"] intValue], [[dayPicker.days objectForKey:@"fri"] intValue], [[dayPicker.days objectForKey:@"sat"] intValue], [[dayPicker.days objectForKey:@"sun"] intValue], dateString];
        [self.dbManager executeQuery:query];
        
        if(hour > [[times objectAtIndex:i] floatValue]){
            completed = 1;
        }
        else{
            completed = 0;
        }
        query = [NSString stringWithFormat: @"insert into today_meds(med_name, chem_name, dosage, time, ampm, completed) values ('%@', '%@', '%@', %f, '%@', %d)",medName.text, chemName.text, dosageNum.text, [[times objectAtIndex:i] floatValue],  [amPm objectAtIndex:i], completed];
        [self.dbManager executeQuery:query];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

@end
