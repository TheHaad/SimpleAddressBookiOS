//
//  PersonParserXCTestCase.m
//  AddressBookSample
//
//  Created by Fahad Muntaz on 6/23/15.
//  Copyright (c) 2015 Fahad Muntaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "PersonParser.h"
#import "Blindside.h"
#import "AddressBookModule.h"
#import <CoreData/CoreData.h>
#import "TestUtility.h"
#import "Person.h"
#import "TestManagedObjectContext.h"
#import "FetchPersonService.h"
#import "AddressBookItemForm.h"

@interface PersonParserXCTestCase : XCTestCase

@property (strong, nonatomic) PersonParser *subject;
@property (strong, nonatomic) id<BSInjector, BSBinder> injector;
@property (strong, nonatomic) TestManagedObjectContext *testManagedObjectContext;

@end

@implementation PersonParserXCTestCase

- (void)setUp {
    [super setUp];
    self.injector = (id<BSInjector,BSBinder>) [Blindside injectorWithModule:[[AddressBookModule alloc] init]];
    
    self.testManagedObjectContext = [TestManagedObjectContext new];
    [self.injector bind:[NSManagedObjectContext class] toInstance:self.testManagedObjectContext.managedObjectContext];
    self.subject = [self.injector getInstance:[PersonParser class]];
}

- (void)tearDown {
    self.subject = nil;
    [self.testManagedObjectContext.managedObjectContext reset];
    self.testManagedObjectContext = nil;
    self.injector = nil;
    [super tearDown];
}

- (void)testInsertNewPersonModelwithDictionary {
    
    NSData *data = [TestUtility loadFixture:@"sampleUser.json"];
    NSError *error;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

    Person * person = [self.subject insertNewPersonModelwithDictionary:jsonDictionary];
    XCTAssertNotNil(person);
    XCTAssertTrue([person.title isEqualToString:@"mrs"]);
    XCTAssertTrue([person.firstName isEqualToString:@"maria"]);
    XCTAssertTrue([person.lastName isEqualToString:@"guerrero"]);

    XCTAssertTrue([person.street isEqualToString:@"4957 calle del barquillo"]);
    XCTAssertTrue([person.city isEqualToString:@"logroño"]);
    XCTAssertTrue([person.state isEqualToString:@"región de murcia"]);
    XCTAssertTrue([person.zip isEqualToString:@"21351"]);
    
    XCTAssertTrue([person.email isEqualToString:@"maria.guerrero45@example.com"]);
    XCTAssertTrue([person.homePhone isEqualToString:@"940-415-345"]);
    XCTAssertTrue([person.cellPhone isEqualToString:@"623-496-579"]);
    XCTAssertTrue([person.displayName isEqualToString:@"maria guerrero"]);
}

- (void)testUpdatePersonWithAddressBookItemForm {
    NSData *data = [TestUtility loadFixture:@"sampleUser.json"];
    NSError *error;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    Person *person = [self.subject insertNewPersonModelwithDictionary:jsonDictionary];
    
    AddressBookItemForm *form = [AddressBookItemForm initWithPerson:person];
    form.firstName = @"mark";
    [self.subject updatePerson:person withAddressBookItemForm:form];
    XCTAssertTrue([person.firstName isEqualToString:@"mark"]);
}

@end
