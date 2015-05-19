//
//  TestManagedObjectContext.m
//  AddressBookSample
//
//  Created by Fahad Muntaz on 2015-05-18.
//  Copyright (c) 2015 Fahad Muntaz. All rights reserved.
//

#import "TestManagedObjectContext.h"

@implementation TestManagedObjectContext

- (NSManagedObjectContext *) managedObjectContext {
    
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return _managedObjectContext;
}

- (NSPersistentStoreCoordinator*)persistentStoreCoordinator {
    if (_persistentStoreCoordinator) return _persistentStoreCoordinator;
    NSError* error = nil;
    NSManagedObjectModel *mom = [self managedObjectModel];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                       initWithManagedObjectModel:mom];
    
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType
                                                       configuration:nil
                                                                 URL:nil
                                                             options:nil
                                                               error:&error]) {
        NSLog(@"failed");
        return nil;
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AddressBookSample" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

@end
