//
//  PersonParser.h
//  AddressBookSample
//
//  Created by Fahad Muntaz on 2015-05-18.
//  Copyright (c) 2015 Fahad Muntaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Person;
@class AddressBookItemForm;

@interface PersonParser : NSObject

- (Person *)insertNewPersonModelwithDictionary:(NSDictionary *)personDictionary;
- (BOOL)updatePerson:(Person *)person withAddressBookItemForm:(AddressBookItemForm *)form;

@end
