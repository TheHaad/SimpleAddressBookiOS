//
//  AddressBookViewControllerXCTestCase.m
//  AddressBookSample
//
//  Created by Fahad Muntaz on 6/25/15.
//  Copyright (c) 2015 Fahad Muntaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "AddressBookViewController.h"
#import "BlindsidedStoryboard.h"
#import "Blindside.h"
#import "AddressBookModule.h"
#import "FetchPersonService.h"
#import <CoreData/CoreData.h>
#import "Person.h"
#import "AddressBookItemFormViewController.h"
#import "TestManagedObjectContext.h"
#import "TestUtility.h"
#import "PersonParser.h"
#import "NSURLConnectionProvider.h"


@interface AddressBookViewControllerXCTestCase : XCTestCase

@property (strong, nonatomic) AddressBookViewController *subject;
@property (strong, nonatomic) UINavigationController *navVC;
@property (strong, nonatomic) id<BSInjector, BSBinder> injector;
@property (strong, nonatomic) NSURLConnectionProvider *fakeConnectionProvider;
@property (strong, nonatomic) TestManagedObjectContext *testManagedObjectContext;

@end

@implementation AddressBookViewControllerXCTestCase

- (void)setUp
{
    [super setUp];
    self.injector = (id<BSInjector,BSBinder>) [Blindside injectorWithModule:[[AddressBookModule alloc] init]];
    self.testManagedObjectContext = [TestManagedObjectContext new];
    self.fakeConnectionProvider = OCMClassMock([NSURLConnectionProvider class]);
    [self.injector bind:[NSManagedObjectContext class] toInstance:self.testManagedObjectContext.managedObjectContext];
    [self.injector bind:[NSURLConnectionProvider class] toInstance:self.fakeConnectionProvider];
    
    BlindsidedStoryboard *storyboard = [BlindsidedStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle] injector:self.injector];
    
    self.subject = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([AddressBookViewController class])];
    self.navVC = [[UINavigationController alloc] initWithRootViewController:self.subject];
    [self.subject view];
}

- (void)tearDown
{
    [self.testManagedObjectContext.managedObjectContext reset];
    self.testManagedObjectContext = nil;
    self.subject = nil;
    self.navVC = nil;
    self.fakeConnectionProvider = nil;
    self.injector = nil;
}

- (void)testWhenDisplayingAddressShouldFetchFromLocalStorage
{
    PersonParser *parser = [self.injector getInstance:[PersonParser class]];
    NSDictionary *jsonDictionary = [TestUtility retrieveSampleUser];
    
    for (int x = 0; x < 2; x++) {
        [parser insertNewPersonModelwithDictionary:jsonDictionary];
    }
    [self.subject viewWillAppear:NO];
    
    XCTAssertTrue(self.subject.people.count == 2);
}

- (void)testWhenAddingANewPersonShouldFetchANewPersonAndAddtoCollection
{
    __block NSData *userData = [TestUtility loadFixture:@"sampleUser.json"];
    PersonParser *parser = [self.injector getInstance:[PersonParser class]];
    NSDictionary *jsonDictionary = [TestUtility retrieveSampleUser];
    
    for (int x = 0; x < 2; x++) {
        [parser insertNewPersonModelwithDictionary:jsonDictionary];
    }
    
    OCMStub([self.fakeConnectionProvider sendAsynchronousRequest:[OCMArg any] queue:[OCMArg any] completionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation)
    {
        NSURLConnectionProviderCompletionHandler compHandler;
        [invocation getArgument:&compHandler atIndex:4];
        if (compHandler)
        {
            compHandler(nil, userData, nil);
        }
    });
    
    [self.subject viewWillAppear:NO];
    [self.subject addPerson:nil];
    XCTAssertTrue(self.subject.people.count == 3);
}

- (void)testWhenViewingPersonDetailsShouldNavigateToAddressItemFormVC
{
    PersonParser *parser = [self.injector getInstance:[PersonParser class]];
    NSDictionary *jsonDictionary = [TestUtility retrieveSampleUser];
    [parser insertNewPersonModelwithDictionary:jsonDictionary];
    [self.subject viewWillAppear:NO];
    
    [self.subject collectionView:self.subject.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    OCMExpect([self.subject prepareForSegue:nil sender:nil]);
}

@end
