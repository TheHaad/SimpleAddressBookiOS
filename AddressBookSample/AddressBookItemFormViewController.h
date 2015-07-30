//
//  AddressBookItemFormViewController.h
//  AddressBookSample
//
//  Created by Fahad Muntaz on 2015-05-18.
//  Copyright (c) 2015 Fahad Muntaz. All rights reserved.
//

#import "FXForms.h"

@class Person;
@interface AddressBookItemFormViewController : FXFormViewController

- (void)setupWithPerson:(Person *)person;
- (void)saveButtonTapped;

@end
