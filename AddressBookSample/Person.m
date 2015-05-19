//
//  Person.m
//  AddressBookSample
//
//  Created by Fahad Muntaz on 2015-05-16.
//  Copyright (c) 2015 Fahad Muntaz. All rights reserved.
//

#import "Person.h"

@implementation Person

@dynamic cellPhone;
@dynamic city;
@dynamic dateOfBirth;
@dynamic email;
@dynamic firstName;
@dynamic homePhone;
@dynamic imageUrl;
@dynamic lastName;
@dynamic state;
@dynamic street;
@dynamic title;
@dynamic zip;
@dynamic displayName;

+ (NSString *)entityName {
    return NSStringFromClass([self class]);
}

@end
