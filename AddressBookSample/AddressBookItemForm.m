//
//  AddressBookItemForm.m
//  AddressBookSample
//
//  Created by Fahad Muntaz on 2015-05-18.
//  Copyright (c) 2015 Fahad Muntaz. All rights reserved.
//

#import "AddressBookItemForm.h"
#import "Person.h"


@implementation AddressBookItemForm

+ (instancetype)initWithPerson:(Person *)person {
    AddressBookItemForm *form = [AddressBookItemForm new];
    //parse person
    form.displayName = person.displayName;
    form.title = person.title;
    form.firstName = person.firstName;
    form.lastName = person.lastName;
    form.street = person.street;
    form.city = person.city;
    form.state = person.state;
    form.zip = person.zip;
    form.email = person.email;
    form.homePhone = person.homePhone;
    form.cellPhone = person.cellPhone;
    form.dateOfBirth = person.dateOfBirth;
    
    return form;
}

@end
