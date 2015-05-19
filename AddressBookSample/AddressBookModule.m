//
//  AddressBookModule.m
//  AddressBookSample
//
//  Created by Fahad Muntaz on 2015-05-18.
//  Copyright (c) 2015 Fahad Muntaz. All rights reserved.
//

#import "AddressBookModule.h"
#import "AppDelegate.h"


@implementation AddressBookModule

- (void)configure:(id<BSBinder>)binder {
    //configure services
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    [binder bind:[NSManagedObjectContext class] toInstance:context];
}

@end
