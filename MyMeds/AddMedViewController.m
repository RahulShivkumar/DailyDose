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

#define uid @"uid"
#define kBGColor [UIColor colorWithRed:229/255.0 green:98/255.0 blue:92/255.0 alpha:1.0]

#define kTimePickerY [Constants window_height] * 0.60 + 18
#define kTimePickerHeight [Constants window_height]/10

#define kRemoveTimeX [Constants window_width] - 25


@implementation AddMedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self generateData];
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
    removeTimes = [[NSMutableArray alloc] init];
    times = [[NSMutableArray alloc] init];
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

    medName = [[MPGTextField alloc] initWithFrame:CGRectMake(0, [Constants window_height] * 0.12 + 20, [Constants window_width], [Constants window_height]/15)];
    [medName setBackgroundColor:[UIColor clearColor]];
    [medName setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:25]];
    [medName setTextColor:[UIColor whiteColor]];
    [medName setTintColor:[UIColor whiteColor]];
    [medName setDelegate:self];
    [medName.layer setSublayerTransform:CATransform3DMakeTranslation(7, 0, 0)];
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
    [chemName setTintColor:[UIColor whiteColor]];
    [chemName setTextColor:[UIColor whiteColor]];
    [chemName.layer setSublayerTransform:CATransform3DMakeTranslation(7, 0, 0)];
    
    [chemName setDelegate:self];
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
    [dosageNum setTintColor:[UIColor whiteColor]];
    [dosageNum setTextColor:[UIColor whiteColor]];
    [dosageNum.layer setSublayerTransform:CATransform3DMakeTranslation(7, 0, 0)];
    [dosageNum setDelegate:self];
    [Constants addTextViewBorder:dosageNum withColor:[UIColor whiteColor]];
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
    
    timePicker = [[UIButton alloc] initWithFrame:CGRectMake(0, kTimePickerY, [Constants window_width], kTimePickerHeight)];
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
    [Constants addButtonBorder:timePicker];
    
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
    
    UIButton *removeTime = [[UIButton alloc] initWithFrame:CGRectMake(kRemoveTimeX, CGRectGetMinY(bottomBut.frame) + 5, 20, [Constants window_height]/10)];
    [removeTime setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [removeTime addTarget:self action:@selector(removeDate:) forControlEvents:UIControlEventTouchUpInside];
    [removeTime setTag:[removeTimes count]];
    
    [removeTimes addObject:removeTime];
    [self.scrollView addSubview:removeTime];
    
    
    UIButton *newButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bottomBut.frame) + 2, [Constants window_width], kTimePickerHeight)];
    
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
    [Constants addButtonBorder:newButton];
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
    [dosage resignFirstResponder];
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
    times[selectedTag] = [NSNumber numberWithFloat:hr];
}

#pragma mark - Move Times Up 
- (void)moveTimesUp:(int)index {
    // Remove Scrolling
    if([timePickers count] < 5) {
        // Scroll to top
        [self.scrollView setContentOffset:CGPointZero animated:YES];
        
        // Remove Scrolling
        [self.scrollView setScrollEnabled:NO];
    }
    for (int i = index; i < [timePickers count]; i++) {
        UIButton *tp = [timePickers objectAtIndex:i];
        [tp setTag:i];
        UIButton *removeTime;
        if (i < [removeTimes count]) {
            removeTime = [removeTimes objectAtIndex:i];
            [removeTime setTag:i];
        }
        [UIView animateWithDuration:0.1 animations:^(){
            [tp setFrame:CGRectMake(0, kTimePickerY + 2 * i + kTimePickerHeight * i, [Constants window_width], kTimePickerHeight)];
            
            if (i < [removeTimes count]) {
                [removeTime setFrame:CGRectMake(kRemoveTimeX, kTimePickerY + 7 * i + kTimePickerHeight * i, 20, kTimePickerHeight)];
            }
        }];
    }
}


#pragma mark - IBActions
//Method called when datePicker date is chosen
- (IBAction)setDate:(id)sender {
    UIButton *buttonClicked = (UIButton *)sender;
    selectedTag = (int)buttonClicked.tag;
    [datePicker show];
}


- (IBAction)removeDate:(id)sender {
    UIButton *buttonClicked = (UIButton *)sender;
    
    int clickedTag = (int)buttonClicked.tag;
    
    [times removeObjectAtIndex:clickedTag];
    UIButton *removeTime = [removeTimes objectAtIndex:clickedTag];
    [removeTime removeFromSuperview];
    [removeTimes removeObjectAtIndex:clickedTag];
    
    UIButton *tp = [timePickers objectAtIndex:clickedTag];
    [tp removeFromSuperview];
    [timePickers removeObjectAtIndex:clickedTag];
    
    // Move Other Times Up
    [self moveTimesUp:clickedTag];
}

//Method called to close window
- (IBAction)closeWindow:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


//Method called when "done" button is hit. Creates new entries for meds into meds and today_meds.
- (IBAction)done:(id)sender {
    
    if([times count] != 0 && medName.text && medName.text.length > 0 && chemName.text && chemName.text.length > 0 && dosageNum.text && dosageNum.text.length > 0){
        
        //Setup Local Notifications
        [NotificationScheduler setupLocalNotifsWithDictionary:dayPicker.days andTimes:times];
        
        //First check if Core med exists
        NSString *query = [NSString stringWithFormat:@"genName = '%@' and chemName = '%@'", medName.text, chemName.text];
        set = [[[CoreMedication query] where:query] fetch];
        
        if ([set count] == 0) {
            
            coreMed = [CoreMedication new];
            coreMed.genName = medName.text;
            coreMed.chemName = chemName.text;
            coreMed.expired = NO;
            coreMed.dosage = dosageNum.text;
            coreMed.startDate = [NSDate date];
            [coreMed commit];
            
            
            
            //If the user has not been asked yet, ask if they would like to allow local notifications.
            if ([PermissionView showMe]){
                PermissionView *pv = [[PermissionView alloc] init];
                pv.delegate = self;
                [self.view addSubview:pv];
            }else{
                [self addMeds:coreMed];
            }
            
        } else {
            
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"This Medication is already present!"
                                                              message:@"Would you like to replace the current information with this new information?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"Replace", nil];
            
            [message show];
            
        }
        

    } else {
        NSString *incomplete = @"Please complete required field(s):";
        
        if (!medName.text || medName.text.length == 0){
            incomplete = [incomplete stringByAppendingString:@"\nMedication Name"];
        }
        if (!chemName.text || chemName.text.length == 0){
            incomplete = [incomplete stringByAppendingString:@"\nChemical Name"];
        }
        if (!dosageNum.text || dosageNum.text.length == 0){
            incomplete = [incomplete stringByAppendingString:@"\nDosage"];
        }
        if ([times count] == 0){
            incomplete = [incomplete stringByAppendingString:@"\nTime Taken"];
        }
        
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Incomplete Form"
                                                           message:incomplete
                                                          delegate:nil
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"Continue", nil];
        [theAlert show];
    }
    
    
}


- (void)addMeds:(CoreMedication *)coreMedLocal {
    NSInteger hour = [Constants getCurrentHour];
    
    for (int i = 0; i < [times count]; i++){
        Medication *med = [Medication new];
        med.coreMed = coreMedLocal;
        med.time = [[times objectAtIndex:i] floatValue];
        med.monday = (BOOL)[[dayPicker.days objectForKey:@"monday"] intValue];
        med.tuesday = (BOOL)[[dayPicker.days objectForKey:@"tuesday"] intValue];
        med.wednesday = (BOOL)[[dayPicker.days objectForKey:@"wednesday"] intValue];
        med.thursday = (BOOL)[[dayPicker.days objectForKey:@"thursday"] intValue];
        med.friday = (BOOL)[[dayPicker.days objectForKey:@"friday"] intValue];
        med.saturday = (BOOL)[[dayPicker.days objectForKey:@"saturday"] intValue];
        med.sunday = (BOOL)[[dayPicker.days objectForKey:@"sunday"] intValue];
        
        [med commit];
        
        NSString *today = [Constants getCurrentDayFromDate:[NSDate date]];
        if(hour <= [[times objectAtIndex:i] floatValue] && (BOOL)[dayPicker.days objectForKey:[today lowercaseString]]){
            TodayMedication *todayMed = [TodayMedication new];
            [todayMed createFromMedication:med];
            [todayMed commit];
        }
        
    }
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    
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


#pragma mark - UIAlertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Cancel"]) {
        [self dismissViewControllerAnimated:YES
                                 completion:nil];
    } else {
        // Handle deleting the local notifications for existing med
        coreMed = [set objectAtIndex:0];
        
        DBResultSet *meds = [[[Medication query] whereWithFormat:@"coreMed = %@", coreMed] fetch];
        NSMutableArray *t = [[NSMutableArray alloc] init];
        for (Medication *med in meds){
            [t addObject:[NSNumber numberWithFloat:med.time]];
        }
        [NotificationScheduler removeLocalNotificationWithCoreMedication:coreMed
                                                                AndTimes:t];
            
        [meds removeAll];
        [[[[TodayMedication query] whereWithFormat:@"coreMed = %@", coreMed] fetch] removeAll];
        
        coreMed.genName = medName.text;
        coreMed.chemName = chemName.text;
        coreMed.expired = NO;
        coreMed.dosage = dosageNum.text;
        coreMed.startDate = [NSDate date];
        [coreMed commit];
        
        [self addMeds:coreMed];
    }

}


#pragma mark - PermissionView delegate
-(void)PermissionViewIsClosing{
    NSLog(@"Closing the permission view");
    [self addMeds:coreMed];
}




@end
