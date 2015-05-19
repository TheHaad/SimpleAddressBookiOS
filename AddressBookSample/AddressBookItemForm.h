//
//  AddressBookItemForm.h
//  AddressBookSample
//
//  Created by Fahad Muntaz on 2015-05-18.
//  Copyright (c) 2015 Fahad Muntaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"

@class Person;
@interface AddressBookItemForm : NSObject<FXForm>

@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *street;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *zip;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *homePhone;
@property (nonatomic, copy) NSString *cellPhone;
@property (nonatomic, copy) NSDate *dateOfBirth;

+ (instancetype)initWithPerson:(Person *)person;

@end
