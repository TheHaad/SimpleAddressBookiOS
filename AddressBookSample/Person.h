//
//  Person.h
//  AddressBookSample
//
//  Created by Fahad Muntaz on 2015-05-16.
//  Copyright (c) 2015 Fahad Muntaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * cellPhone;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSDate * dateOfBirth;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * homePhone;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) NSString * displayName;

+ (NSString *)entityName;

@end
