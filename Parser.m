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
        med = [[Medication alloc] init];
        [self setupData];
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
        
        NSString *rxnorm = [medJson objectForKey:@"rxnorm"][0];
        
        chemNameURL = @"http://rxnav.nlm.nih.gov/REST/rxcui/";
        

        NSData* data = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString:[chemNameURL stringByAppendingString:rxnorm]]];
        
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
        
        [parser setDelegate:self];
        [parser parse];
        
        

        
        
        
        NSLog(@"%@", med.medName);
        NSLog(@"%@", med.dosage);
        NSLog(@"%@", med.chemName);
        
        //Check for day/week
        NSString *isStructuredSig = [medJson objectForKey:@"isstructuredsig"];
        
        if ([isStructuredSig isEqualToString:@"true"]){
            //For structured sig its straightforward
            NSDictionary *structuredSig = [medJson objectForKey:@"structuredsig"];
            int dosageFrequencyValue = [[structuredSig objectForKey:@"dosagefrequencyvalue"] intValue];
            NSString *dosageFrequencyUnit = [structuredSig objectForKey:@"dosagefrequencyunit"];
            
            NSString *dosageAdditionalInfo = [structuredSig objectForKey:@"dosageadditionalinformation"];
            NSString *dosageQuantityValue = [structuredSig objectForKey:@"dosagequantityvalue"];
            
            NSString *dosageQuantityUnit = [structuredSig objectForKey:@"dosagequantityunit"];
            
            med.dosage = [[dosageQuantityValue stringByAppendingString:@" "] stringByAppendingString:dosageQuantityUnit];
            if ([dosageFrequencyUnit isEqualToString:@"per day"]){
                if (dosageFrequencyValue == 1){
                    if([dosageAdditionalInfo isEqualToString:@"with meals"])
                        [self insertIntoDB:med andTime:meal3 andAmpm:@"PM"];
                    else if ([dosageAdditionalInfo isEqualToString:@"before meals"])
                        [self insertIntoDB:med andTime:meal3 - 0.5 andAmpm:@"PM"];
                    else if ([dosageAdditionalInfo isEqualToString:@"after meals"])
                        [self insertIntoDB:med andTime:meal3 + 0.5 andAmpm:@"PM"];
                    else
                        [self insertIntoDB:med andTime:meal3 + 0.5 andAmpm:@"PM"];
                    
                }
                else if (dosageFrequencyValue == 2){
                    if([dosageAdditionalInfo isEqualToString:@"with meals"]){
                        [self insertIntoDB:med andTime:meal3 andAmpm:@"PM"];
                        [self insertIntoDB:med andTime:meal1 andAmpm:@"AM"];
                    }
                    else if ([dosageAdditionalInfo isEqualToString:@"before meals"]){
                        [self insertIntoDB:med andTime:meal3 - 0.5 andAmpm:@"PM"];
                        [self insertIntoDB:med andTime:meal1 - 0.5 andAmpm:@"AM"];
                    }
                    else if ([dosageAdditionalInfo isEqualToString:@"after meals"]){
                        [self insertIntoDB:med andTime:meal3 + 0.5 andAmpm:@"PM"];
                        [self insertIntoDB:med andTime:meal1 + 0.5 andAmpm:@"AM"];
                    }
                    else{
                        [self insertIntoDB:med andTime:meal3 + 0.5 andAmpm:@"PM"];
                        [self insertIntoDB:med andTime:meal1 + 0.5 andAmpm:@"AM"];
                    }
                }
                else{
                    if([dosageAdditionalInfo isEqualToString:@"with meals"]){
                        [self insertIntoDB:med andTime:meal3 andAmpm:@"PM"];
                        [self insertIntoDB:med andTime:meal1 andAmpm:@"AM"];
                        [self insertIntoDB:med andTime:meal2 andAmpm:@"PM"];
                    }
                    else if ([dosageAdditionalInfo isEqualToString:@"before meals"]){
                        [self insertIntoDB:med andTime:meal3 - 0.5 andAmpm:@"PM"];
                        [self insertIntoDB:med andTime:meal1 - 0.5 andAmpm:@"AM"];
                        [self insertIntoDB:med andTime:meal2 - 0.5 andAmpm:@"PM"];
                    }
                    else if ([dosageAdditionalInfo isEqualToString:@"after meals"]){
                        [self insertIntoDB:med andTime:meal3 + 0.5 andAmpm:@"PM"];
                        [self insertIntoDB:med andTime:meal1 + 0.5 andAmpm:@"AM"];
                        [self insertIntoDB:med andTime:meal2 + 0.5 andAmpm:@"PM"];
                    }
                    else{
                        [self insertIntoDB:med andTime:meal3 + 0.5 andAmpm:@"PM"];
                        [self insertIntoDB:med andTime:meal1 + 0.5 andAmpm:@"AM"];
                        [self insertIntoDB:med andTime:meal2 andAmpm:@"PM"];
                    }
                    
                }
            }
            else if([dosageQuantityValue isEqualToString:@"per week"]){
                
            }
        }
        else{
            //For unstructured
            NSString *unstructuredSig = [medJson objectForKey:@"unstructuredsig"];
            NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
            for (int i = 0; i < [[unstructuredSig componentsSeparatedByString:@" "] count]; i++){
                if([[unstructuredSig componentsSeparatedByString:@" "][i] rangeOfCharacterFromSet:notDigits].location == NSNotFound){
                    //If it starts witha numeric digit
                    NSString *number = [unstructuredSig componentsSeparatedByString:@" "][i];
                    NSString *unit = [unstructuredSig componentsSeparatedByString:@" "][i + 1];
                    med.dosage = [[number stringByAppendingString:@" " ] stringByAppendingString:unit];
                }
            }
            
        }

    }
    
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    dummyString = @"";
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    dummyString = [dummyString stringByAppendingString:string];
    
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"name"])
    {
        med.chemName = [dummyString componentsSeparatedByString:@" "][0];
    }


}

- (void)insertIntoDB:(Medication*)med andTime:(float)time andAmpm:(NSString *)ampm{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"MM/dd/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
    
    NSInteger hour;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
    hour = [components hour];
    
    NSString *query = [NSString stringWithFormat: @"insert into meds(med_name, chem_name, dosage, time, ampm, monday, tuesday, wednesday, thursday, friday, saturday, sunday, completed, start_date) values ('%@', '%@', '%@', %f, '%@', '%d', %d, %d, %d, %d, %d, %d, 0, '%@')", med.medName, med.chemName,med.dosage, time, ampm, 1, 1, 1, 1, 1, 1, 1, dateString ];
    [self.dbManager executeQuery:query];
    
    if(hour <= time){
        NSString *query = [NSString stringWithFormat: @"insert into today_meds(med_name, chem_name, dosage, time, ampm, completed) values ('%@', '%@', '%@', %f, '%@', %d)",med.medName, med.chemName, med.dosage, time,  ampm, 0];
        [self.dbManager executeQuery:query];
    }
}
@end
