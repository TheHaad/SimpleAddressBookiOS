//
//  FetchPersonService.m
//  AddressBookSample
//
//  Created by Fahad Muntaz on 2015-05-16.
//  Copyright (c) 2015 Fahad Muntaz. All rights reserved.
//

#import "FetchPersonService.h"
#import "Person.h"
#import "AppDelegate.h"
#import "NSURLConnectionProvider.h"
#import "PersonParser.h"
#import "Blindside.h"


NSString* const kFetchPersonUrl =  @"http://api.randomuser.me/";

@interface FetchPersonService()

@property (nonatomic, strong) PersonParser *personParser;
@property (nonatomic, strong) NSURLConnectionProvider *connectionProvider;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end


@implementation FetchPersonService

+ (BSInitializer *)bsInitializer {
    return [BSInitializer initializerWithClass:[self class] selector:@selector(initWithConnectionProvider:personParser:managedObjectContext:)argumentKeys:
            [NSURLConnectionProvider class],
            [PersonParser class],
            [NSManagedObjectContext class], nil];
}

- (instancetype)initWithConnectionProvider:(NSURLConnectionProvider *)connectionProvider
                      personParser:(PersonParser *)personParser
                      managedObjectContext:(NSManagedObjectContext *)context {
    self = [super init];
    if (self) {
        self.connectionProvider = connectionProvider;
        self.personParser = personParser;
        self.managedObjectContext = context;
    }
    
    return self;
}

- (void)fetchPersonWithCompletionBlock:(FetchServicePersonCompletionBlock)completionBlock failureBlock:(FetchServicePersonFailureBlock)failureBlock {
    NSURLRequest *fetchPersonRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:kFetchPersonUrl]];
    [self.connectionProvider sendAsynchronousRequest:fetchPersonRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            NSError *jsonError = nil;
            NSMutableDictionary *personDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if (!jsonError) {
                Person *newPerson = [self.personParser insertNewPersonModelwithDictionary:personDictionary];
                if (completionBlock) {
                    completionBlock(newPerson);
                }
            } else {
                if (failureBlock) {
                    failureBlock(jsonError);
                }
            }
        } else {
            if (failureBlock) {
                failureBlock(connectionError);
            }
        }
    }];
}

- (NSArray *)fetchForLocalPeople {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:[Person entityName]inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entityDescription];
    NSError *error = nil;
    NSArray *people = [self.managedObjectContext executeFetchRequest:request error:&error];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    return [people sortedArrayUsingDescriptors:@[sort]];
}

@end
