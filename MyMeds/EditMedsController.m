//
//  EditMedsController.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 5/8/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "EditMedsController.h"

@interface EditMedsController ()

@end

#define uid @"uid"
#define bgColor [UIColor colorWithRed:229/255.0 green:98/255.0 blue:92/255.0 alpha:1.0]
#define bgColor2 [UIColor colorWithRed:229/255.0 green:98/255.0 blue:92/255.0 alpha:1.0]

@implementation EditMedsController

-(id)initWithMed:(CoreMedication*)medication andDays:(NSMutableArray *)daySchedule andTime:(NSMutableArray *)timeSchedule{
    if (self = [super init]) {
        cm = medication;
        self.dayShedule = daySchedule;
        times = timeSchedule;

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self generateData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup Views
-(void)setupView{
    timePickers = [[NSMutableArray alloc] init];
    oldTimes = [[NSMutableArray alloc] init];
    
    [self.view setBackgroundColor:bgColor];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.scrollView];
    
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Constants window_width], 50)];
//    [headerView setBackgroundColor:bgColor];
//    [self.view addSubview:headerView];
    
    cancel = [[UIButton alloc]initWithFrame:CGRectMake(0, 15, 60, 40)];
    [cancel.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
    [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancel.titleLabel setTextColor:[UIColor whiteColor]];
    [self.scrollView addSubview:cancel];
    [cancel addTarget:self action:@selector(closeWindow:) forControlEvents:UIControlEventTouchUpInside];
    
    done = [[UIButton alloc]initWithFrame:CGRectMake([Constants window_width]-60, 15, 60, 40)];
    [addMed setTextAlignment:NSTextAlignmentRight];
    [done.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [done setTitle:@"Done" forState:UIControlStateNormal];
    [done.titleLabel setTextColor:[UIColor whiteColor]];
    [self.scrollView addSubview:done];
    [done addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    
    addMed = [[UILabel alloc]initWithFrame:CGRectMake([Constants window_width]/2 -100, 15, 200, 40)];
    [addMed setTextAlignment:NSTextAlignmentCenter];
    [addMed setFont:[UIFont fontWithName:@"HelveticaNeue" size:18]];
    [addMed setText:@"New Medication"];
    [addMed setTextColor:[UIColor whiteColor]];
    [self.scrollView addSubview:addMed];
    
    name = [[UILabel alloc]initWithFrame:CGRectMake(7, [Constants window_height] * 0.12, 150, 20)];
    [name setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    [name setText:@"Medication Name"];
    [name setTextColor:[UIColor whiteColor]];
    [self.scrollView addSubview:name];
    
    medName = [[MPGTextField alloc] initWithFrame:CGRectMake(0, [Constants window_height] * 0.12 + 20, [Constants window_width], [Constants window_height]/15)];
    [medName setBackgroundColor:[UIColor clearColor]];
    [medName setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:25]];
    [medName setTextColor:[UIColor whiteColor]];
    [medName setTintColor:[UIColor whiteColor]];
    [medName setDelegate:self];
    [medName.layer setSublayerTransform:CATransform3DMakeTranslation(7, 0, 0)];
    [medName setText:cm.genName];
    [Constants addTextViewBorder:medName withColor:[UIColor whiteColor]];
    [self.scrollView  addSubview:medName];
    
    generic = [[UILabel alloc]initWithFrame:CGRectMake(7, [Constants window_height] * 0.23, 150, 20)];
    [generic setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    [generic setText:@"Chemical Name"];
    [generic setTextColor:[UIColor whiteColor]];
    [self.scrollView  addSubview:generic];
    
    chemName = [[MPGTextField alloc] initWithFrame:CGRectMake(0, [Constants window_height] * 0.23 + 20, [Constants window_width], [Constants window_height]/15)];
    [chemName setBackgroundColor:[UIColor clearColor]];
    [chemName setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:25]];
    [chemName setTextColor:[UIColor whiteColor]];
    [chemName setTintColor:[UIColor whiteColor]];
    [chemName.layer setSublayerTransform:CATransform3DMakeTranslation(7, 0, 0)];
    [chemName setDelegate:self];
    [chemName setText:cm.chemName];
    [Constants addTextViewBorder:chemName withColor:[UIColor whiteColor]];
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
    [dosageNum setText:cm.dosage];
    [Constants addTextViewBorder:dosageNum withColor:[UIColor whiteColor]];
    [self.scrollView  addSubview:dosageNum];
    
    days = [[UILabel alloc]initWithFrame:CGRectMake(7, [Constants window_height] * 0.45, 150, 20)];
    [days setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    [days setText:@"Days Taken"];
    [days setTextColor:[UIColor whiteColor]];
    [self.scrollView  addSubview:days];
    
    dayPicker = [[DayPicker alloc] initWithFrame:CGRectMake(0, [Constants window_height] * 0.45 + 20, [Constants window_width], [Constants window_height]/10)
                                           andBG:bgColor
                                           andTc:[UIColor whiteColor]
                                          andHtc:bgColor
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
    [timePicker setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [timePicker.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:30]];
    [timePicker setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [timePicker setContentEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
    [timePicker setTitle:[Constants convertTimeToString:[[times objectAtIndex:0] floatValue]] forState:UIControlStateNormal];
    [oldTimes addObject:[times objectAtIndex:0]];
    
    [timePicker setTintColor:[UIColor whiteColor]];
    [timePicker setBackgroundColor:[UIColor clearColor]];
    [timePicker setTag:0];
    [timePicker addTarget:self action:@selector(setDate:) forControlEvents:UIControlEventTouchUpInside];
    [Constants addButtonBorder:timePicker];
    
    datePicker = [RMDateSelectionViewController dateSelectionController];
    [datePicker setDelegate:self];
    datePicker.datePicker.datePickerMode = UIDatePickerModeTime;
    [self setupDayPicker];
    [datePicker.datePicker setMinuteInterval:30];
    [timePickers addObject:timePicker];
    
    [self setupTimes];
    [self.scrollView  addSubview:timePicker];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.scrollView addGestureRecognizer:tap];
    
    //  [dayPicker addGestureRecognizer:tap];
    
}

#pragma mark - Setup Day Picker
- (void)setupDayPicker{
    for(int i = 0; i < 7; i++){
        if ([self.dayShedule[i] intValue] == 1){
            if(i == 0){
                [dayPicker sunday:nil];
            }
            else if (i == 1){
                [dayPicker monday:nil];
            }
            else if (i == 2){
                [dayPicker tuesday:nil];
            }
            else if (i == 3){
                [dayPicker wednesday:nil];
            }
            else if (i == 4){
                [dayPicker thursday:nil];
            }
            else if (i == 5){
                [dayPicker friday:nil];
            }
            else if (i == 6){
                [dayPicker saturday:nil];
            }
        }
    }
}

#pragma mark - Setup Times 

- (void)setupTimes{
    int count = (int)[times count];
    for (int i = 1; i < count ; i++){
        [self createButton];
        UIButton *bottomBut = [timePickers objectAtIndex:[timePickers count] - 1];
        [bottomBut setTitle:[Constants convertTimeToString:[[times objectAtIndex:i] floatValue]]
                   forState:UIControlStateNormal];
        [oldTimes addObject:[times objectAtIndex:i]];
    }
    [self createButton];
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
    [Constants addButtonBorder:newButton];
    
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

- (void)dismissKeyboard {
    [medName resignFirstResponder];
    [chemName resignFirstResponder];
    [dosage resignFirstResponder];
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

    NSInteger hour;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
    hour = [components hour];
    
    if([times count] != 0 && medName.text && medName.text.length > 0 && chemName.text && chemName.text.length > 0 && dosageNum.text && dosageNum.text.length > 0){
        
        //Setup Local Notifications on a separate thread
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [NotificationScheduler removeLocalNotificationWithCoreMedication:cm AndTimes:oldTimes];
            [NotificationScheduler setupLocalNotifsWithDictionary:dayPicker.days andTimes:times];
        });
        
        
        //Delete all meds
        [[[[Medication query] whereWithFormat:@"coreMed = %@", cm]  fetch] removeAll];
        [[[[TodayMedication query] whereWithFormat:@"coreMed = %@", cm] fetch] removeAll];
        
        //Change coreMed
        cm.genName = medName.text;
        cm.chemName = chemName.text;
        cm.dosage = dosageNum.text;
        [cm commit];
        
        for (int i = 0; i < [times count]; i++){
            
            Medication *medication = [Medication new];
            medication.coreMed = cm;
            medication.time = [[times objectAtIndex:i] floatValue];
            medication.monday = (BOOL)[[dayPicker.days objectForKey:@"monday"] intValue];
            medication.tuesday = (BOOL)[[dayPicker.days objectForKey:@"tuesday"] intValue];
            medication.wednesday = (BOOL)[[dayPicker.days objectForKey:@"wednesday"] intValue];
            medication.thursday = (BOOL)[[dayPicker.days objectForKey:@"thursday"] intValue];
            medication.friday = (BOOL)[[dayPicker.days objectForKey:@"friday"] intValue];
            medication.saturday = (BOOL)[[dayPicker.days objectForKey:@"saturday"] intValue];
            medication.sunday = (BOOL)[[dayPicker.days objectForKey:@"sunday"] intValue];
            
            [medication commit];
            
            NSString *today = [Constants getCurrentDayFromDate:[NSDate date]];
            if(hour <= [[times objectAtIndex:i] floatValue] && (BOOL)[dayPicker.days objectForKey:[today lowercaseString]]){
                TodayMedication *todayMed = [TodayMedication new];
                [todayMed createFromMedication:medication];
                [todayMed commit];
            }
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
//        [AZNotification showNotificationWithTitle:@"Please Add All Information!" controller:self notificationType:AZNotificationTypeWarning];
    }
    
}

#pragma mark - MPGTextfield Delegate
- (NSArray *)dataForPopoverInTextField:(MPGTextField *)textField
{
    return data;
}


- (BOOL)textFieldShouldSelect:(MPGTextField *)textField
{
    return YES;
}


- (void)textField:(MPGTextField *)textField didEndEditingWithSelection:(NSDictionary *)result
{
    // TO-DO See why NEW is actually popping up!
    if ([result objectForKey:@"CustomObject"] == nil) {
        [medName setText:[result objectForKey:@"DisplayText"]];
        [chemName setText:[result objectForKey:@"DisplaySubText"]];
    }

}

#pragma mark - Setup Data
- (void)generateData {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSError* err = nil;
        data = [[NSMutableArray alloc] init];

        NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"drugsdb" ofType:@"json"];
        NSArray* contents = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath] options:kNilOptions error:&err];
        dispatch_async( dispatch_get_main_queue(), ^{
            [contents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [data addObject:[NSDictionary dictionaryWithObjectsAndKeys:[obj objectForKey:@"med_name"], @"DisplayText", [obj objectForKey:@"chem_name"], @"DisplaySubText",nil]];
            }];
        });
    });
}



@end
