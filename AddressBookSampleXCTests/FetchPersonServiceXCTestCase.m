//
//  FetchPersonServiceXCTestCase.m
//  AddressBookSample
//
//  Created by Fahad Muntaz on 6/25/15.
//  Copyright (c) 2015 Fahad Muntaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "FetchPersonService.h"
#import "Blindside.h"
#import "AddressBookModule.h"
#import <CoreData/CoreData.h>
#import "NSURLConnectionProvider.h"
#import "Person.h"
#import "PersonParser.h"
#import "TestUtility.h"
#import "TestManagedObjectContext.h"

@interface FetchPersonServiceXCTestCase : XCTestCase

@property (strong, nonatomic) FetchPersonService *subject;
@property (strong, nonatomic) id<BSInjector, BSBinder> injector;
@property (strong, nonatomic) TestManagedObjectContext *testManagedObjectContext;
@property (strong, nonatomic) NSURLConnectionProvider *fakeUrlProvider;

@property (strong, nonatomic) PersonParser *fakePersonParser;

@end

@implementation FetchPersonServiceXCTestCase

- (void)setUp
{
    [super setUp];
    self.injector = (id<BSInjector,BSBinder>) [Blindside injectorWithModule:[[AddressBookModule alloc] init]];
    self.testManagedObjectContext = [TestManagedObjectContext new];
    self.fakeUrlProvider = OCMClassMock([NSURLConnectionProvider class]);
    [self.injector bind:[NSManagedObjectContext class] toInstance:self.testManagedObjectContext.managedObjectContext];
    [self.injector bind:[NSURLConnectionProvider class] toInstance:self.fakeUrlProvider];
}

- (void)tearDown
{
    [self.testManagedObjectContext.managedObjectContext reset];
    self.testManagedObjectContext = nil;
    self.fakeUrlProvider = nil;
    self.injector = nil;
    self.fakePersonParser = nil;
    
    [super tearDown];
}

- (void)setupForFetchPersonWithCompletionBlockFailureBlock
{
    self.fakePersonParser = OCMClassMock([PersonParser class]);
    [self.injector bind:[PersonParser class] toInstance:self.fakePersonParser];
    self.subject = [self.injector getInstance:[FetchPersonService class]];
}

- (void)testFetchPersonWithCompletionBlockFailureBlockOnCompletion
{
    [self setupForFetchPersonWithCompletionBlockFailureBlock];
    OCMStub([self.fakeUrlProvider sendAsynchronousRequest:[OCMArg any] queue:[OCMArg any] completionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation)
     {
         NSURLConnectionProviderCompletionHandler compHandler;
         [invocation getArgument:&compHandler atIndex:4];
         if (compHandler)
         {
             NSData *data = [TestUtility loadFixture:@"sampleUser.json"];
             compHandler(nil, data, nil);
         }
     });
    
    OCMStub([self.fakePersonParser insertNewPersonModelwithDictionary:nil]).andReturn(nil);    __block BOOL completionBlockCalled = NO;
    [self.subject fetchPersonWithCompletionBlock:^(Person *person) {
        completionBlockCalled = YES;
    } failureBlock:nil];

    XCTAssertTrue(completionBlockCalled);
}

- (void)testFetchPersonWithCompletionBlockOnFailureWhenConnectionErrorOccurs
{
    [self setupForFetchPersonWithCompletionBlockFailureBlock];
    __block NSError *connectionError = [NSError new];
    
    OCMStub([self.fakeUrlProvider sendAsynchronousRequest:[OCMArg any] queue:[OCMArg any] completionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation)
    {
       NSURLConnectionProviderCompletionHandler compHandler;
       [invocation getArgument:&compHandler atIndex:4];
       if (compHandler)
       {
           compHandler(nil, nil, connectionError);
       }
   });
    
    __block BOOL failureBlockCalled = NO;
    [self.subject fetchPersonWithCompletionBlock:nil failureBlock:^(NSError *error) {
        failureBlockCalled = YES;
    }];
    
    XCTAssertTrue(failureBlockCalled);
}

- (void)testFetchPersonWithCompletionBlockOnFailureWhenJSONErrorOccurs
{
    [self setupForFetchPersonWithCompletionBlockFailureBlock];
    __block NSData *jsonData = [TestUtility loadFixture:@"sampleUserError.json"];
    
    OCMStub([self.fakeUrlProvider sendAsynchronousRequest:[OCMArg any] queue:[OCMArg any] completionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation)
     {
         NSURLConnectionProviderCompletionHandler compHandler;
         [invocation getArgument:&compHandler atIndex:4];
         if (compHandler)
         {
             compHandler(nil, jsonData, nil);
         }
     });

    __block BOOL failureBlockCalled = NO;
    [self.subject fetchPersonWithCompletionBlock:nil failureBlock:^(NSError *error) {
        failureBlockCalled = YES;
    }];
    
    XCTAssertTrue(failureBlockCalled);
}

- (void)testfetchForLocalPeopleShouldReturnTheCorrectAmountOfPeopleStored
{
    self.subject = [self.injector getInstance:[FetchPersonService class]];
    NSData *data = [TestUtility loadFixture:@"sampleUser.json"];
    NSError *error;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    PersonParser *parser = [self.injector getInstance:[PersonParser class]];
    for (int x = 0; x < 3; x++) {
        [parser insertNewPersonModelwithDictionary:jsonDictionary];
    }
    
    XCTAssertTrue([self.subject fetchForLocalPeople].count == 3);
}


@end
