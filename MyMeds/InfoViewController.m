//
//  InfoViewController.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 2/4/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController()
-(void)setupView;

@end

#define bgColor [UIColor colorWithRed:125/255.0 green:0/255.0 blue:10/255.0 alpha:1.0]
#define bgColor2 [UIColor colorWithRed:180/255.0 green:42/255.0 blue:50/255.0 alpha:1.0]

@implementation InfoViewController

-(id)initWithMed:(Medication*)medication{
    if (self = [super init]) {
        med = medication;
        self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"dailydosedb.sql"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.screenName = @"Info Screen";
    [self setupView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark View Setup 
-(void)setupView{
    //[self.view setBackgroundColor:bgColor];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[bgColor CGColor], (id)[bgColor2 CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    close = [[UIButton alloc]initWithFrame:CGRectMake(0, 15, 60, 40)];
    [close.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [close setTitle:@"Close" forState:UIControlStateNormal];
    [close.titleLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:close];
    [close addTarget:self action:@selector(closeWindow:) forControlEvents:UIControlEventTouchUpInside];
    
    edit = [[UIButton alloc]initWithFrame:CGRectMake([Constants window_width] - 60, 15, 60, 40)];
    [edit.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [edit setTitle:@"Edit" forState:UIControlStateNormal];
    [edit.titleLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:edit];
    [edit addTarget:self action:@selector(editMeds:) forControlEvents:UIControlEventTouchUpInside];
    
    medInfo = [[UILabel alloc]initWithFrame:CGRectMake([Constants window_width]/2 -100, 15, 200, 40)];
    [medInfo setTextAlignment:NSTextAlignmentCenter];
    [medInfo setFont:[UIFont fontWithName:@"HelveticaNeue" size:18]];
    [medInfo setText:@"Medication Info"];
    [medInfo setTextColor:[UIColor whiteColor]];
    [self.view addSubview:medInfo];
//
    medLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, [self window_height]* 0.05, [self window_width] - 10, [self window_height]*0.2)];
    [medLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:42]];
    [medLabel setTextColor:[UIColor whiteColor]];
    [medLabel setText:med.medName];
    [self.view addSubview:medLabel];
    
    chemLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, [self window_height]* 0.155, [self window_width] - 10, [self window_height]*0.145)];
    [chemLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:22]];
    [chemLabel setTextColor:[UIColor whiteColor]];
    [chemLabel setText:[@"- " stringByAppendingString:med.chemName]];
    [self.view addSubview:chemLabel];
    
    //Caculate medlabel's text size and use that
    CGSize textSize = [medLabel.text sizeWithAttributes:@{NSFontAttributeName:[medLabel font]}];
    description = [[UILabel alloc]initWithFrame:CGRectMake(textSize.width + 30, [self window_height]* 0.09, [self window_width] - 10, [self window_height]*0.145)];
    [description setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:22]];
    [description setTextColor:[UIColor whiteColor]];
    [description setText:med.dosage];
    [self.view addSubview:description];
    
    startDate = [[UILabel alloc]initWithFrame:CGRectMake(30, [self window_height]* 0.210, [self window_width] - 10, [self window_height]*0.145)];
    [startDate setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:22]];
    [startDate setTextColor:[UIColor whiteColor]];
    [self.view addSubview:startDate];
    
    endDate = [[UILabel alloc]initWithFrame:CGRectMake(30, [self window_height]* 0.265, [self window_width] - 10, [self window_height]*0.145)];
    [endDate setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:22]];
    [endDate setTextColor:[UIColor whiteColor]];
    [self.view addSubview:endDate];
    
    timeTaken = [[UILabel alloc] initWithFrame:CGRectMake(10, [self window_height]* 0.38, [self window_width]/2.0-10, [self window_height]*0.2)];
    [timeTaken setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:25]];
    [timeTaken setTextColor:[UIColor whiteColor]];
    [timeTaken setText:@"Time Taken:"];
    [self.view addSubview:timeTaken];
    
    
    underLine1 = [[UIView alloc] initWithFrame:CGRectMake(10, [self window_height]* 0.5, [self window_width]-20, 1)];
    [underLine1 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:underLine1];
    

    
    
    endMed =[[UIButton alloc] initWithFrame:CGRectMake(30, [self window_height] * 0.95, [self window_width] - 60, 30)];
    [endMed setTitle:@"End Course" forState:UIControlStateNormal];
    [endMed.layer setBorderWidth:1.0];
    [endMed addTarget:self
               action:@selector(endCourse:)
     forControlEvents:UIControlEventTouchUpInside];
    [endMed.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.view addSubview:endMed];
    
   [self getDates];
    [self setupDaysTaken];
    [self setupTime];
    
}

-(void)getDates{
    NSDateFormatter *dateFormat;
    [dateFormat setDateFormat: @"MM/dd/yyyy"];
    NSString *query = [NSString stringWithFormat: @"select start_date from meds where med_name = '%@'", med.medName];
    NSArray *temp = [self.dbManager loadDataFromDB:query];
    NSString *tempDate = [[temp objectAtIndex:0] objectAtIndex:0];
    med.startDate = [dateFormat dateFromString:tempDate];
    [startDate setText:[@"- Start Date: " stringByAppendingString:tempDate]];
    
    //End Date detection
    query = [NSString stringWithFormat: @"select end_date from meds where med_name = '%@'", med.medName];
    temp = [self.dbManager loadDataFromDB:query];
    if([temp count] == 0){
        [endDate setText:@"- End Date: N/A"];
    }
    else{
        tempDate = [[temp objectAtIndex:0] objectAtIndex:0];
        [endDate setText:[@"- End Date: " stringByAppendingString:tempDate]];
        med.endDate = [dateFormat dateFromString:tempDate];
    }

    
}
-(void)setupDaysTaken{
    daySchedule = [[NSMutableArray alloc] init];
    UILabel *daysTaken = [[UILabel alloc] initWithFrame:CGRectMake(30, [self window_height]* 0.320, [self window_width] *0.6, [self window_height]*0.145)];
    [daysTaken setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:22]];
    [daysTaken setTextColor:[UIColor whiteColor]];
    [daysTaken setText:@"- Days Taken:"];
    [self.view addSubview:daysTaken];
    
    NSString *query = [NSString stringWithFormat: @"select sunday, monday, tuesday, wednesday, thursday, friday, saturday from meds where med_name = '%@' limit 1", med.medName];
    NSArray *temp = [self.dbManager loadDataFromDB:query];
    NSMutableArray *days = [[NSMutableArray alloc] initWithObjects:@"S", @"M",@"T",@"W",@"Th",@"F", @"S", nil];
    for (int i = 0; i < 7; i ++){
        UILabel *day = [[UILabel alloc] initWithFrame:CGRectMake(158 + i * 0.072 * [self window_width] , [self window_height]* 0.375, [self window_width] * 0.072 , [self window_width] * 0.072)];
        [day setText:[days objectAtIndex:i]];
        [day setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:18]];
        [day setTextAlignment:NSTextAlignmentCenter];
        [day setTextColor:[UIColor whiteColor]];
        
        NSString *tempDay = [[temp objectAtIndex:0] objectAtIndex:i];
        int tempValue = [tempDay intValue];
        [daySchedule addObject:tempDay];
        if(tempValue == 1){
            [day.layer setBorderWidth:1.0];
            [day.layer setCornerRadius:day.frame.size.width/2.0];
            [day.layer setBorderColor:[UIColor whiteColor].CGColor];
        }
        [self.view addSubview:day];
    }
}

-(void)setupTime{
    times = [[NSMutableArray alloc] init];
    NSString *query = [NSString stringWithFormat: @"select time, ampm from meds where med_name = '%@' and chem_name = '%@' order by ampm, time", med.medName, med.chemName];
    NSArray *temp = [self.dbManager loadDataFromDB:query];
    
    for(int i = 0; i < [temp count]; i ++){
        NSString *tempTime = [[temp objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"time"]];
         NSString *amPm = [[temp objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"ampm"]];
        float actualTime = [tempTime floatValue];
        if(actualTime > 12.5){
            actualTime -= 12;
        }
        NSString *timeString = [NSString stringWithFormat:@"%d",(int)actualTime];
        if(actualTime == (int) actualTime){
            timeString = [timeString stringByAppendingString:@":00"];
        }
        else{
            timeString = [timeString stringByAppendingString:@":30"];
        }
        
        [times addObject:[timeString stringByAppendingString:[@" " stringByAppendingString:amPm]]
         ];
        
        time = [[UILabel alloc]initWithFrame:CGRectMake([self window_width]/2.0, [self window_height]* 0.38 + 0.05 * i * [self window_height], [self window_width]/2.0-10, [self window_height]*0.2)];
        [time setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:25]];
        [time setTextColor:[UIColor whiteColor]];
        [time setText:[timeString stringByAppendingString:amPm]];
        [time setTextAlignment:NSTextAlignmentRight];
        [self.view addSubview:time];
        
    }
    
}
- (IBAction)closeWindow:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)editMeds:(id)sender{
    EditMedsController *editMedsController = [[EditMedsController alloc] initWithMed:med andDays:daySchedule andTime:times];
    [editMedsController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:editMedsController animated:YES completion:nil];
}
-(IBAction)endCourse:(id)sender{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"MM/dd/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
    
    NSString *query = [NSString stringWithFormat: @"update meds set completed = 1, end_date = '%@' where med_name = '%@' and chem_name = '%@'", dateString, med.medName, med.chemName];
    [self.dbManager executeQuery:query];
    query = [NSString stringWithFormat: @"delete from  today_meds where med_name = '%@' and chem_name = '%@'", med.medName, med.chemName];
    [self.dbManager executeQuery:query];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Data Setup 
-(void)setupData{
    
}

#pragma mark  - Helper Methods
-(CGFloat)window_height{
    return [UIScreen mainScreen].applicationFrame.size.height;
}

-(CGFloat)window_width{
    return [UIScreen mainScreen].applicationFrame.size.width;
}

@end
