//
//  PersonParser.m
//  AddressBookSample
//
//  Created by Fahad Muntaz on 2015-05-18.
//  Copyright (c) 2015 Fahad Muntaz. All rights reserved.
//

#import "PersonParser.h"
#import <CoreData/CoreData.h>
#import "Person.h"
#import "Blindside.h"
#import "AddressBookItemForm.h"


@interface PersonParser()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end


@implementation PersonParser

+ (BSInitializer *)bsInitializer {
    return  [BSInitializer initializerWithClass:[self class] selector:@selector(initWithManagedObjectContext:) argumentKeys:[NSManagedObjectContext class], nil];
}

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context {
    self = [super init];
    if (self) {
        self.managedObjectContext = context;
    }
    
    return self;
}

- (Person *)insertNewPersonModelwithDictionary:(NSDictionary *)personDictionary {
    Person *person = [NSEntityDescription insertNewObjectForEntityForName:[Person entityName] inManagedObjectContext:self.managedObjectContext];
    
    NSDictionary *userDictionary = [[[personDictionary objectForKey:@"results"] objectAtIndex:0]objectForKey:@"user"];
    
    NSDictionary *nameDictionary  = [userDictionary objectForKey:@"name"];
    NSDictionary *locationDictionary = [userDictionary objectForKey:@"location"];
    
    person.title = [nameDictionary objectForKey:@"title"];
    person.firstName = [nameDictionary objectForKey:@"first"];
    person.lastName = [nameDictionary objectForKey:@"last"];
    
    person.street = [locationDictionary objectForKey:@"street"];
    person.city = [locationDictionary objectForKey:@"city"];
    person.state = [locationDictionary objectForKey:@"state"];
    person.zip = [locationDictionary objectForKey:@"zip"];
    
    person.email = [userDictionary objectForKey:@"email"];
    person.dateOfBirth = [NSDate dateWithTimeIntervalSinceReferenceDate:[[personDictionary objectForKey:@"dob"] doubleValue]];
    person.homePhone = [userDictionary objectForKey:@"phone"];
    person.cellPhone = [userDictionary objectForKey:@"cell"];
    person.displayName = [NSString stringWithFormat:@"%@ %@", person.firstName, person.lastName];
    
    NSError *saveError = nil;
    if (![self.managedObjectContext save:&saveError]) {
        NSLog(@"saveError occurred:\n %@", [saveError description]);
    }
    
    return person;
}

- (BOOL)updatePerson:(Person *)person withAddressBookItemForm:(AddressBookItemForm *)form {
    
    person.title = form.title;
    person.firstName = form.firstName;
    person.lastName = form.lastName;
    person.street = form.street;
    person.city = form.city;
    person.state = form.state;
    person.zip = form.zip;
    person.email = form.email;
    person.dateOfBirth = form.dateOfBirth;
    person.homePhone = form.homePhone;
    person.cellPhone = form.cellPhone;
    person.displayName = form.displayName;
    
    NSError *saveError = nil;
    return [self.managedObjectContext save:&saveError];
}

@end
