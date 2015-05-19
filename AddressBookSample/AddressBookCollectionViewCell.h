//
//  AddressBookCollectionViewCell.h
//  AddressBookSample
//
//  Created by Fahad Muntaz on 2015-05-16.
//  Copyright (c) 2015 Fahad Muntaz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Person;
@interface AddressBookCollectionViewCell : UICollectionViewCell

+ (CGFloat)height;
- (void)setupWithPerson:(Person *)person;

@end
