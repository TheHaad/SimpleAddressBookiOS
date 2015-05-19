//
//  FetchPersonService.h
//  AddressBookSample
//
//  Created by Fahad Muntaz on 2015-05-16.
//  Copyright (c) 2015 Fahad Muntaz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Person;

typedef void(^FetchServicePersonCompletionBlock)(Person *person);
typedef void(^FetchServicePersonFailureBlock)(NSError *error);

@interface FetchPersonService : NSObject

- (void)fetchPersonWithCompletionBlock:(FetchServicePersonCompletionBlock)completionBlock
                          failureBlock:(FetchServicePersonFailureBlock)failureBlock;
- (NSArray *)fetchForLocalPeople;

@end
