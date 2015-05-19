//
//  AddressBookCollectionViewCell.m
//  AddressBookSample
//
//  Created by Fahad Muntaz on 2015-05-16.
//  Copyright (c) 2015 Fahad Muntaz. All rights reserved.
//

#import "AddressBookCollectionViewCell.h"
#import "Person.h"

#define kAddressBookCellHeight 40.0f

@interface AddressBookCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *displayName;

@end


@implementation AddressBookCollectionViewCell

+ (CGFloat)height {
    return kAddressBookCellHeight;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.displayName.text = @"";
}

- (void)setupWithPerson:(Person *)person {
    self.displayName.text = person.displayName;
}

@end
