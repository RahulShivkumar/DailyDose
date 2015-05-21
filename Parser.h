//
//  Parser.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 5/16/15.
//  Copyright (c) 2015 test. All rights reserved.
//
#define queue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define apiURL [NSURL URLWithString:@"http://klinik.io/db.json"]

#import <Foundation/Foundation.h>
#import "DBManager.h"
#import "Medication.h"

@interface Parser : NSObject <NSXMLParserDelegate>{
    int wakeup, bedtime, meal1, meal2, meal3;
    Medication *med;
    NSString *chemNameURL;
    NSString *dummyString;
}
@property (nonatomic, strong) DBManager *dbManager;

- (id)init;
- (void)setupData;
- (void)fetchedData:(NSData *)responseData;
- (NSMutableArray *)getMeds;
@end
