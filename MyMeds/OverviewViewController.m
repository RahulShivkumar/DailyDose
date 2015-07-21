//
//  OverviewViewController.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 1/26/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "OverviewViewController.h"
#import "Medication.h"
#import "InfoViewController.h"
#import "AddMedViewController.h"


@interface OverviewViewController ()

@end


#define kBGColor [UIColor colorWithRed:170/255.0 green:18/255.0 blue:22/255.0 alpha:1.0]

@implementation OverviewViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}


- (void)viewDidAppear:(BOOL)animated{
    //Lets ensure that the first page opened is our Schedule view regardless
    int index = 0;
    
    if(self.timeline.selectedSegmentIndex == 1){
        index = 1;
    }

    [self setupMeds:index];
    [self setupViews];
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Set up views
//Method called to set up views
- (void)setupViews {
    self.medsView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [Constants window_width], self.navigationController.view.frame.size.height - 44)];
    [self.medsView setDataSource:self];
    [self.medsView setDelegate:self];
    [self.medsView setBackgroundColor:[UIColor whiteColor]];
    [self.medsView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.medsView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.medsView];


    
    [Constants setupNavbar:self];
}





#pragma mark - Set Up Medication 
//Method called to setup meds based on selection current/past
- (void)setupMeds:(int)expired {
    meds = [[[CoreMedication query] whereWithFormat:@"expired = %d",expired] fetch];
    [self.medsView reloadData];
}


////Method called to convert SQLData to Array
//- (NSMutableArray *)setDataInArray:(NSArray *)temp{
//    NSMutableArray *tempMutable = [[NSMutableArray alloc] init];
//    for(int i = 0; i < [temp count]; i++){
//        NSString *medName = [[temp objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"med_name"]];
//        NSString *chemName = [[temp objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"chem_name"]];
//        NSString *dosage = [[temp objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"dosage"]];
//        NSString *subName = [chemName stringByAppendingString:@" - "];
//        subName = [subName stringByAppendingString:dosage];
//        
//        NSString *completed = [[temp objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"completed"]];
//        int intCompleted = [completed intValue];
//        
//        Medication *med = [[Medication alloc]initWithName:medName andChemName:chemName];
//        med.subName = subName;
//        med.dosage = dosage;
//        
//        if (intCompleted == 1){
//            [med setExpired:YES];
//        } else {
//            [med setCompleted:NO];
//        }
//        
//        [tempMutable addObject:med];
//    }
//    return tempMutable;
//}


#pragma mark - Table view delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [meds count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    CoreMedication *med = [meds objectAtIndex:indexPath.row];
    
    [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:[Constants window_height]/8 * 0.4]];
    [cell.textLabel setTextColor:[UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1.0]];
    [cell.textLabel setText:med.genName];
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Constants window_width], 50)];
    [footer setBackgroundColor:[UIColor whiteColor]];
    
    return footer;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [Constants window_height]/10;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 70.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    InfoViewController *infoVC = [[InfoViewController alloc] initWithMed:[meds objectAtIndex:indexPath.row]];
    [self.navigationController presentViewController:infoVC animated:YES completion:nil];
}



#pragma mark - UIImagePickerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // Access the uncropped image from info dictionary
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *fixedImage = [image imageWithFixedOrientation];
    
    [ImageProcessor sharedProcessor].delegate = self;
    [[ImageProcessor sharedProcessor] processImage:fixedImage];
//    G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng"];
//    tesseract.delegate = self;
//    
//    [tesseract setImage:image];
//    [tesseract recognize];
//    NSLog(@"%@", [tesseract recognizedText]);
    
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    
    
}


//- (UIImage *)preprocessedImageForTesseract:(G8Tesseract *)tesseract sourceImage:(UIImage *)sourceImage {
//    
//    // Give the filteredImage to Tesseract instead of the original one,
//    // allowing us to bypass the internal thresholding step.
//    // filteredImage will be sent immediately to the recognition step
//    
//    //sourceImage = [ImageProcessor processImage:sourceImage];
//    return sourceImage;
//}

#pragma mark - ImageProcessor Delegate 
- (void)imageProcessorFinishedProcessingWithImage:(UIImage *)outputImage {
//    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, [Constants window_width], [Constants window_height] - 44)];
//    [self.view addSubview:imgView];
//    [imgView setImage:outputImage];
//    
//    G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng"];
//    tesseract.delegate = self;
//    [tesseract setImage:outputImage];
//    [tesseract recognize];
//    NSLog(@"%@", [tesseract recognizedText]);
}

#pragma mark - IBActions
//Method called for camera logic
- (void)openCamera:(id)sender {
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])  {
//        
//        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//        
//        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
//        imagePicker.delegate = self;
//        imagePicker.editing = NO;
//        
//        [self presentViewController:imagePicker animated:YES completion:nil];
//    }
//    else {
//        //TO-DO Alert saying Camera not accessible :(
//    }
}


//Method called to change the timeline 
- (IBAction)changeTimeline:(id)sender {
    if(self.timeline.selectedSegmentIndex == 0){
        [self setupMeds:NO];
    }
    else{
        [self setupMeds:YES];
    }
}


- (IBAction)addMedication:(id)sender {
    AddMedViewController *addMedVC = [[AddMedViewController alloc] init];
    [self.navigationController presentViewController:addMedVC animated:YES completion:nil];
}

@end
