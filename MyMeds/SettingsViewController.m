//
//  SettingsViewController.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 1/26/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "SettingsViewController.h"
#import "Parser.h"

@interface SettingsViewController ()

@end

#define NavBarColor [UIColor colorWithRed:170/255.0 green:18/255.0 blue:22/255.0 alpha:1.0]

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavbar];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"dailydosedb.sql"];


    // Do any additional setup after loading the view.
}
- (void)setup{
  
}
- (void)train1{
    self.classifier = [[ParsimmonNaiveBayesClassifier alloc] init];
    NSString *query = @"select phrase, category from parser where type = 1";
    
    NSArray *temp = [self.dbManager loadDataFromDB:query];
    for(int i = 0; i < [temp count]; i++){
        NSString *phrase = [[temp objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"phrase"]];
        NSString *category = [[temp objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"category"]];
        
        [self.classifier trainWithText:phrase category:category];
    }
}
- (void)train2{
    self.classifier = [[ParsimmonNaiveBayesClassifier alloc] init];
    NSString *query = @"select phrase, category from parser where type = 2";
    
    NSArray *temp = [self.dbManager loadDataFromDB:query];
    for(int i = 0; i < [temp count]; i++){
        NSString *phrase = [[temp objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"phrase"]];
        NSString *category = [[temp objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"category"]];
        
        [self.classifier trainWithText:phrase category:category];
    }
}
- (void)train3{
    self.classifier = [[ParsimmonNaiveBayesClassifier alloc] init];
    NSString *query = @"select phrase, category from parser where type = 3";
    
    NSArray *temp = [self.dbManager loadDataFromDB:query];
    for(int i = 0; i < [temp count]; i++){
        NSString *phrase = [[temp objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"phrase"]];
        NSString *category = [[temp objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"category"]];
        
        [self.classifier trainWithText:phrase category:category];
    }
    
   
    
}
- (void)train4{
    self.classifier = [[ParsimmonNaiveBayesClassifier alloc] init];
    NSString *query = @"select phrase, category from parser where type = 4";
    
    NSArray *temp = [self.dbManager loadDataFromDB:query];
    for(int i = 0; i < [temp count]; i++){
        NSString *phrase = [[temp objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"phrase"]];
        NSString *category = [[temp objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"category"]];
        
        [self.classifier trainWithText:phrase category:category];
    }
    

    
}

- (void)train5{
    self.classifier = [[ParsimmonNaiveBayesClassifier alloc] init];
    NSString *query = @"select phrase, category from parser where type = 5";
    
    NSArray *temp = [self.dbManager loadDataFromDB:query];
    for(int i = 0; i < [temp count]; i++){
        NSString *phrase = [[temp objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"phrase"]];
        NSString *category = [[temp objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"category"]];
        
        [self.classifier trainWithText:phrase category:category];
    }
    
    
    
}
//Place a placeholder image for now
- (IBAction)parse:(id)sender {
    
    NSString *unstructuredSig = self.scriptPhrase.text;
    unstructuredSig = [unstructuredSig lowercaseString];
    
    NSLinguisticTaggerOptions options = NSLinguisticTaggerOmitWhitespace | NSLinguisticTaggerOmitPunctuation | NSLinguisticTaggerJoinNames;
    NSLinguisticTagger *tagger = [[NSLinguisticTagger alloc] initWithTagSchemes: [NSLinguisticTagger availableTagSchemesForLanguage:@"en"] options:options];
    tagger.string = unstructuredSig;
    NSMutableArray *tokens = [[NSMutableArray alloc] init];
    NSMutableArray *tags = [[NSMutableArray alloc] init];
    [tagger enumerateTagsInRange:NSMakeRange(0, [unstructuredSig length]) scheme:NSLinguisticTagSchemeNameTypeOrLexicalClass options:options usingBlock:^(NSString *tag, NSRange tokenRange, NSRange sentenceRange, BOOL *stop) {
        NSString *token = [unstructuredSig substringWithRange:tokenRange];
        [tokens addObject:token];
        [tags addObject:tag];
       // NSLog(@"%@", token);
       // NSLog(@"%@", tag);

    }];
    
    //Begin algorithm
    NSString *dosage;
    //Find Dosage first - Usually found after a verb & before a noun
    int i = 0;
    if ([[tags objectAtIndex:i]  isEqual:@"Verb"] || [[tags objectAtIndex:i]  isEqual:@"Adjective"] ){
        if([[tags objectAtIndex:i + 1] isEqual:@"Number"] && [[tags objectAtIndex:i + 2] isEqual:@"Noun"]){
            dosage = [[tokens objectAtIndex:i+1 ] stringByAppendingString:@" "];
            dosage = [dosage stringByAppendingString:[tokens objectAtIndex:i+2]];
            [tokens removeObjectAtIndex:0];
            [tokens removeObjectAtIndex:0];
            [tokens removeObjectAtIndex:0];
            [tags removeObjectAtIndex:0];
            [tags removeObjectAtIndex:0];
            [tags removeObjectAtIndex:0];
        
        }
    }
    else if ([[tags objectAtIndex:i] isEqual:@"Number"] && [[tags objectAtIndex:i + 1] isEqual:@"Noun"]){
        dosage = [[tokens objectAtIndex:i] stringByAppendingString:@" "];
        dosage = [dosage stringByAppendingString:[tokens objectAtIndex:i+1]];
        [tokens removeObjectAtIndex:0];
        [tokens removeObjectAtIndex:0];
        [tags removeObjectAtIndex:0];
        [tags removeObjectAtIndex:0];
    }

    NSString *newCommand = @"";
    for (int j = 0; j < [tokens count]; j ++){
        newCommand = [newCommand stringByAppendingString:[tokens objectAtIndex:j]];
         newCommand = [newCommand stringByAppendingString:@" "];
    }
//    NSString *dosageClassification;
//    int frequency = 0;
//    BOOL break1 = YES;
//    BOOL break2 = YES;
//    for (int j = i; j < [tags count] && break1; j++){
//        if ([[tags objectAtIndex:j] isEqual:@"Determiner"]){
//            dosageClassification = [tokens objectAtIndex:j+1];
//            //Search for the number of times
//            //Look to find the word times & get the frequency
//
//        }
//        for (int k = j - 1; k > i && break2; k--){
//            if([[tokens objectAtIndex:k] isEqual:@"times"]){
//                if ([[tags objectAtIndex:k-1] isEqual:@"Number"]){
//                    frequency = [[tokens objectAtIndex:k-1] integerValue];
//                    break2 = NO;
//                }
//            }
//        }
//        //Default to frquency as 1
//        if([[tokens objectAtIndex:j] isEqual:@"every"] && break2){
//            frequency = 1;
//        }
//    }
//
//    if (frequency == 0){
//        frequency = 1;
//    }
//    NSLog(@"%d", frequency);
//    NSLog(@"%@", dosageClassification);
    

    
    
    [self train1];
    NSString *category = [self.classifier classify:newCommand];
    [self.type1 setText:category];
    
    [self train2];
    category = [self.classifier classify:newCommand];
    [self.type2 setText:category];
    
    [self train3];
    category = [self.classifier classify:newCommand];
    [self.type3 setText:category];
    
    [self train4];
    category = [self.classifier classify:newCommand];
    [self.type4 setText:category];
    
    [self train5];
    category = [self.classifier classify:newCommand];
    [self.type5 setText:category];
}


- (IBAction)input:(id)sender {
   NSString *query = [NSString stringWithFormat: @"insert into parser(phrase, category, type) values ('%@', '%@', %d)", self.scriptPhrase.text, self.setType1.text, 1];
    [self.dbManager executeQuery:query];
    query = [NSString stringWithFormat: @"insert into parser(phrase, category, type) values ('%@', '%@', %d)", self.scriptPhrase.text, self.setType2.text, 2];
    [self.dbManager executeQuery:query];
    query = [NSString stringWithFormat: @"insert into parser(phrase, category, type) values ('%@', '%@', %d)", self.scriptPhrase.text, self.setType3.text, 3];
    [self.dbManager executeQuery:query];
    query = [NSString stringWithFormat: @"insert into parser(phrase, category, type) values ('%@', '%@', %d)", self.scriptPhrase.text, self.setType4.text, 4];
    [self.dbManager executeQuery:query];
    query = [NSString stringWithFormat: @"insert into parser(phrase, category, type) values ('%@', '%@', %d)", self.scriptPhrase.text, self.setType4.text, 5];
    [self.dbManager executeQuery:query];
}

- (IBAction)delete:(id)sender{
    NSString *query = [NSString stringWithFormat: @"delete from parser where phrase = '%@' and category = '%@' and type = %d", self.scriptPhrase.text, self.setType1.text, 1];
    [self.dbManager executeQuery:query];
    query = [NSString stringWithFormat: @"delete from parser where phrase = '%@' and category = '%@' and type = %d", self.scriptPhrase.text, self.setType1.text, 2];
    [self.dbManager executeQuery:query];
     query = [NSString stringWithFormat: @"delete from parser where phrase = '%@' and category = '%@' and type = %d", self.scriptPhrase.text, self.setType1.text, 3];
    [self.dbManager executeQuery:query];
     query = [NSString stringWithFormat: @"delete from parser where phrase = '%@' and category = '%@' and type = %d", self.scriptPhrase.text, self.setType1.text, 4];
    [self.dbManager executeQuery:query];
    query = [NSString stringWithFormat: @"delete from parser where phrase = '%@' and category = '%@' and type = %d", self.scriptPhrase.text, self.setType1.text, 5];
    [self.dbManager executeQuery:query];
    
    
}


- (IBAction)correct:(id)sender {
}



- (IBAction)wrong:(id)sender {
}


- (void)setPlaceholderImage{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, [Constants window_height] - 89)];
    [self.view addSubview:imageView];
    [imageView setImage:[UIImage imageNamed:@"settingsph"]];
}


//Method called to set navigation bar
- (void)setNavbar{
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [self.navigationController.navigationBar setBarTintColor:NavBarColor];
    [self.navigationItem setTitle:@"Settings"];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBActions
- (IBAction)deleteMeds:(id)sender{
        self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"dailydosedb.sql"];
        NSString *query2 = [NSString stringWithFormat: @"delete from meds"];
        //Store in today's sql table after deleting what exists
        [self.dbManager executeQuery:query2];
          NSString *query4 = [NSString stringWithFormat: @"delete from today_meds"];
        [self.dbManager executeQuery:query4];
}


- (IBAction)syncMeds:(id)sender{
     Parser *parser = [[Parser alloc] init];
}

@end
