//
//  EditMedsController.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 5/8/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "EditMedsController.h"
#import "AZNotification.h"

@interface EditMedsController ()

@end

#define uid @"uid"
#define bgColor [UIColor colorWithRed:125/255.0 green:0/255.0 blue:10/255.0 alpha:1.0]
#define bgColor2 [UIColor colorWithRed:180/255.0 green:42/255.0 blue:50/255.0 alpha:1.0]

@implementation EditMedsController

-(id)initWithMed:(Medication*)medication andDays:(NSMutableArray *)daySchedule andTime:(NSMutableArray *)timeSchedule{
    if (self = [super init]) {
        med = medication;
        self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"dailydosedb.sql"];
        self.dayShedule = daySchedule;
        self.times = timeSchedule;

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup Views
-(void)setupView{
    timePickers = [[NSMutableArray alloc] init];
    amPm = [[NSMutableArray alloc] init];
    times = [[NSMutableArray alloc] init];
    oldTimes = [[NSMutableArray alloc] init];
    
    [self.view setBackgroundColor:bgColor];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.scrollView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Constants window_width], 50)];
    [headerView setBackgroundColor:bgColor];
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
    [medName setText:med.medName];
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
    [chemName setTextColor:[UIColor whiteColor]];
    [chemName setTintColor:[UIColor whiteColor]];
    [chemName.layer setSublayerTransform:CATransform3DMakeTranslation(7, 0, 0)];
    [chemName setDelegate:self];
    [chemName setText:med.chemName];
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
    [dosageNum setTextColor:[UIColor whiteColor]];
    [dosageNum setTintColor:[UIColor whiteColor]];
    [dosageNum.layer setSublayerTransform:CATransform3DMakeTranslation(7, 0, 0)];
    [dosageNum setDelegate:self];
    [dosageNum setText:med.dosage];
    [self addTextViewBorder:dosageNum];
    [self.scrollView  addSubview:dosageNum];
    
    days = [[UILabel alloc]initWithFrame:CGRectMake(7, [Constants window_height] * 0.45, 150, 20)];
    [days setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    [days setText:@"Days Taken"];
    [days setTextColor:[UIColor whiteColor]];
    [self.scrollView  addSubview:days];
    
    dayPicker = [[DayPicker alloc] initWithFrame:CGRectMake(0, [Constants window_height] * 0.45 + 20, [Constants window_width], [Constants window_height]/10) andBG:[UIColor clearColor] andTc:[UIColor whiteColor] andHtc:[UIColor whiteColor] andHl:[UIColor whiteColor] andTextviews:[NSMutableArray arrayWithObjects:medName, chemName, dosageNum, nil]];
    [self.scrollView  addSubview:dayPicker];
    
    
    time = [[UILabel alloc]initWithFrame:CGRectMake(7, [Constants window_height] * 0.60, 150, 20)];
    [time setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    [time setText:@"Time Taken"];
    [time setTextColor:[UIColor whiteColor]];
    [self.scrollView  addSubview:time];
    
    timePicker = [[UIButton alloc] initWithFrame:CGRectMake(0, [Constants window_height] * 0.60 + 20, [Constants window_width], [Constants window_height]/10)];
    [timePicker setBackgroundColor:[UIColor whiteColor]];
    [timePicker setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [timePicker.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:30]];
    [timePicker setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [timePicker setContentEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
    [timePicker setTitle:[self.times objectAtIndex:0] forState:UIControlStateNormal];
    [timePicker setTintColor:[UIColor whiteColor]];
    [timePicker setBackgroundColor:[UIColor clearColor]];
    [timePicker setTag:0];
    [timePicker addTarget:self action:@selector(setDate:) forControlEvents:UIControlEventTouchUpInside];
    [self addButtonBorder:timePicker];
    
    datePicker = [RMDateSelectionViewController dateSelectionController];
    [datePicker setDelegate:self];
    datePicker.datePicker.datePickerMode = UIDatePickerModeTime;
    [self setupDayPicker];
    [datePicker.datePicker setMinuteInterval:30];
    [timePickers addObject:timePicker];
    
    [self createTime:[self.times objectAtIndex:0]];
    [self setupTimes];
    [self.scrollView  addSubview:timePicker];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.scrollView addGestureRecognizer:tap];
    
    //  [dayPicker addGestureRecognizer:tap];
    
}

- (void)addTextViewBorder:(UITextField*)textView{
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, textView.frame.size.height - 1, textView.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor whiteColor].CGColor;
    [textView.layer addSublayer:bottomBorder];
}

- (void)addButtonBorder:(UIButton*)button{
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, button.frame.size.height - 1, button.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor whiteColor].CGColor;
    [button.layer addSublayer:bottomBorder];
}

#pragma mark - Setup Day Picker
- (void)setupDayPicker{
    for(int i = 0; i < 7; i++){
        if ([self.dayShedule[i] intValue] == 1){
            if(i == 0){
                [dayPicker sun:nil];
            }
            else if (i == 1){
                [dayPicker mon:nil];
            }
            else if (i == 2){
                [dayPicker tue:nil];
            }
            else if (i == 3){
                [dayPicker wed:nil];
            }
            else if (i == 4){
                [dayPicker thur:nil];
            }
            else if (i == 5){
                [dayPicker fri:nil];
            }
            else if (i == 6){
                [dayPicker sat:nil];
            }
        }
    }
}

#pragma mark - Setup Times 

- (void)setupTimes{
    int count = (int)[self.times count];
    for (int i = 1; i < count ; i++){
        [self createButton];
        UIButton *bottomBut = [timePickers objectAtIndex:[timePickers count] - 1];
        [bottomBut setTitle:[self.times objectAtIndex:i] forState:UIControlStateNormal];
        [self createTime:[self.times objectAtIndex:i]];
    }
}
- (void)createTime:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSDate *currentTime = [dateFormatter dateFromString:dateString];
    
    [dateFormatter setDateFormat:@"a"];
    NSString *tempAmPm = [dateFormatter stringFromDate:currentTime];
    [amPm addObject:tempAmPm];
    
    [dateFormatter setDateFormat:@"hh"];
    NSString *tempHours = [dateFormatter stringFromDate:currentTime];
    [dateFormatter setDateFormat:@"mm"];
    NSString *tempMins = [dateFormatter stringFromDate:currentTime];
    
    [self addTimeWithHour:tempHours andMins:tempMins andAmPm:tempAmPm];
    
}
- (void)createButton{
    UIButton *bottomBut = [timePickers objectAtIndex:[timePickers count] - 1];
    UIButton *newButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bottomBut.frame) + 2, [Constants window_width], [Constants window_height]/10)];
    [newButton setBackgroundColor:[UIColor whiteColor]];
    [newButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:30]];
    [newButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [newButton setContentEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
    [newButton setTintColor:[UIColor whiteColor]];
    [newButton setBackgroundColor:[UIColor clearColor]];
    [newButton setTitle:@"Add Time" forState:UIControlStateNormal];
    [self.scrollView addSubview:newButton];
    [newButton setTag:(int)[timePickers count]];
    [newButton addTarget:self action:@selector(setDate:) forControlEvents:UIControlEventTouchUpInside];
    [timePickers addObject:newButton];
    [self addButtonBorder:newButton];
    
    //Set up Scrolling
    if (CGRectGetMaxY(self.scrollView.frame) < CGRectGetMaxY(newButton.frame)){
        [self.scrollView setContentSize:(CGSizeMake([Constants window_width], CGRectGetMaxY(newButton.frame)))];
    }
}

#pragma mark - DatePicker Delegate
- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate {
    
    
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
    
    float hr = [tempHours intValue];
    if ([tempAmPm isEqualToString:@"PM"]){
        if(hr != 12 && hr != 12.5){
            hr = hr + 12;
        }
    }
    if([tempMins isEqualToString:@"30"]){
        hr = hr + 0.5;
    }
    times [selectedTag] = [NSNumber numberWithFloat:hr];
    //Convert Current Time to Integer
    if (selectedTag == [timePickers count] -1){
        [self createButton];
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

- (void)addTimeWithHour:(NSString *)hour andMins:(NSString *)mins andAmPm:(NSString *)ampm{
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
    [oldTimes addObject:[NSNumber numberWithFloat:hr]];
}

#pragma mark - IBActions
-(IBAction)closeWindow:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)setDate:(id)sender{
    UIButton *buttonClicked = (UIButton *)sender;
    selectedTag = (int)buttonClicked.tag;
    [datePicker show];
}

- (IBAction)done:(id)sender{
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"dailydosedb.sql"];
    NSInteger hour;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
    hour= [components hour];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"MM/dd/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
    if([times count] != 0 && medName.text && medName.text.length > 0 && chemName.text && chemName.text.length > 0 && dosageNum.text && dosageNum.text.length > 0){
        
        for (int i = 0; i < [times count]; i++){
            NSString *ampm = @"AM";
            if((int)[times objectAtIndex:i] > 12){
                ampm = @"PM";
            }
            
            
            
            NSString *query = [NSString stringWithFormat: @"update meds  set med_name = '%@', chem_name = '%@', dosage = '%@', time = %f, ampm = '%@', monday = %d, tuesday = %d, wednesday = %d, thursday = %d, friday = %d, saturday = %d, sunday = %d, completed = 0, start_date = '%@' where med_name = '%@' and time = %f", medName.text, chemName.text, dosageNum.text, [[times objectAtIndex:i] floatValue], [amPm objectAtIndex:i], [[dayPicker.days objectForKey:@"mon"] intValue],[[dayPicker.days objectForKey:@"tue"] intValue], [[dayPicker.days objectForKey:@"wed"] intValue], [[dayPicker.days objectForKey:@"thur"] intValue], [[dayPicker.days objectForKey:@"fri"] intValue], [[dayPicker.days objectForKey:@"sat"] intValue], [[dayPicker.days objectForKey:@"sun"] intValue], dateString, med.medName, [[oldTimes objectAtIndex:i] floatValue]];
            [self.dbManager executeQuery:query];
            
//            if(hour <= [[times objectAtIndex:i] floatValue]){
//                completed = 0;
//                query = [NSString stringWithFormat: @"update today_meds med_name, chem_name, dosage, time, ampm, completed) values ('%@', '%@', '%@', %f, '%@', %d)",medName.text, chemName.text, dosageNum.text, [[times objectAtIndex:i] floatValue],  [amPm objectAtIndex:i], completed];
//                [self.dbManager executeQuery:query];
//            }
            
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        [AZNotification showNotificationWithTitle:@"Please Add All Information!" controller:self notificationType:AZNotificationTypeWarning];
    }
    
    
}


@end
