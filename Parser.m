//
//  Parser.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 5/16/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "Parser.h"


@implementation Parser
- (id)init{
    self = [super init];
    if (self) {
        self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"dailydosedb.sql"];

        dispatch_async(queue, ^{
            NSData* data = [NSData dataWithContentsOfURL:
                           apiURL];
            [self performSelectorOnMainThread:@selector(fetchedData:)
                                   withObject:data waitUntilDone:YES];
        });
        
    }
    return self;
}
- (void)setupData{
    wakeup = 8;
    bedtime = 20;
    meal1 = 10;
    meal2 = 14;
    meal3 = 20;
}
//- (NSMutableArray *)getMeds{
//    
//}
- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    NSArray* meds = [json objectForKey:@"medications"];
    
    for (int i = 0; i < [meds count]; i++){
        NSArray *tempMed = [meds objectAtIndex:i];
    
        NSDictionary *medJson = [tempMed objectAtIndex:0];
    
        med.medName = [medJson objectForKey:@"medication"];
        med.medName = [med.medName componentsSeparatedByString:@" "][0];
        
        NSDictionary *structuredSig = [medJson objectForKey:@"structuredsig"];
        int dosageFrequencyValue = [[structuredSig objectForKey:@"dosagefrequencyvalue"] intValue];
        NSString *dosageFrequencyUnit = [structuredSig objectForKey:@"dosagefrequencyunit"];
        
        NSString *dosageQuantityValue = [structuredSig objectForKey:@"dosagequantityvalue"];
        
        NSString *dosageQuantityUnit = [structuredSig objectForKey:@"dosagequantityunit"];
        
        med.dosage = [[dosageQuantityValue stringByAppendingString:@" "] stringByAppendingString:dosageQuantityUnit];
        
        
        
        //Check for day/week
        if ([dosageFrequencyUnit isEqualToString:@"per day"]){
            if (dosageFrequencyValue == 1){
                
            }
            else if (dosageFrequencyValue == 2){
                
            }
            else{
                
            }
        }
    }
    
}

- (void)insertIntoDB:(Medication*)med andTime:(float)time andAmpm:(NSString *)ampm{
    NSString *query = [NSString stringWithFormat: @"insert into meds(med_name, chem_name, dosage, time, ampm, monday, tuesday, wednesday, thursday, friday, saturday, sunday, completed, start_date) values ('%@', '%@', '%@', %f, '%@', '%d', %d, %d, %d, %d, %d, %d, 0, '%@')", med.medName, @" ",med.dosage, time, ampm];
    [self.dbManager executeQuery:query];
}
@end
