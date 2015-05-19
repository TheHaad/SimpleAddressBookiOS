//
//  TestUtility.m
//  AddressBookSample
//
//  Created by Fahad Muntaz on 2015-05-18.
//  Copyright (c) 2015 Fahad Muntaz. All rights reserved.
//

#import "TestUtility.h"
#import <CoreData/CoreData.h>

@implementation TestUtility

 + (NSData *)loadFixture:(NSString *)name {
    NSBundle *unitTestBundle = [NSBundle bundleForClass:[self class]];
    NSString *pathForFile    = [unitTestBundle pathForResource:name ofType:nil];
    NSData   *data           = [[NSData alloc] initWithContentsOfFile:pathForFile];
    return data;
}

+ (NSDictionary *)retrieveSampleUser {
    NSData *data = [TestUtility loadFixture:@"sampleUser.json"];
    NSError *error;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    return jsonDictionary;
}

@end
