//
//  TestUtility.h
//  AddressBookSample
//
//  Created by Fahad Muntaz on 2015-05-18.
//  Copyright (c) 2015 Fahad Muntaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestUtility : NSObject

+ (NSData *)loadFixture:(NSString *)name;
+ (NSDictionary *)retrieveSampleUser;

@end
