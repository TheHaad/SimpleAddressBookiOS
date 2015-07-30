//
//  AddressBookItemFormViewControllerXCTestCase.m
//  AddressBookSample
//
//  Created by Fahad Muntaz on 2015-07-15.
//  Copyright (c) 2015 Fahad Muntaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "AddressBookItemFormViewController.h"
#import "TestManagedObjectContext.h"
#import "Blindside.h"
#import "BlindsidedStoryboard.h"
#import "AddressBookModule.h"
#import "PersonParser.h"
#import "TestUtility.h"
#import "AddressBookItemForm.h"
#import "FetchPersonService.h"
#import "Person.h"


@interface AddressBookItemFormViewControllerXCTestCase : XCTestCase

@property (strong, nonatomic) AddressBookItemFormViewController *subject;
@property (strong, nonatomic) TestManagedObjectContext *testManagedObjectContext;
@property (strong, nonatomic) UINavigationController *navVC;
@property (strong, nonatomic) id<BSInjector, BSBinder> injector;

@end

@implementation AddressBookItemFormViewControllerXCTestCase

- (void)setUp {
    
    [super setUp];
    self.injector = (id<BSInjector,BSBinder>) [Blindside injectorWithModule:[[AddressBookModule alloc] init]];
    self.testManagedObjectContext = [TestManagedObjectContext new];
    [self.injector bind:[NSManagedObjectContext class] toInstance:self.testManagedObjectContext.managedObjectContext];
    
    BlindsidedStoryboard *storyboard = [BlindsidedStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle] injector:self.injector];
    
    self.subject = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([AddressBookItemFormViewController class])];
    self.navVC = [[UINavigationController alloc] initWithRootViewController:self.subject];
    
    PersonParser *parser = [self.injector getInstance:[PersonParser class]];
    NSDictionary *jsonDictionary = [TestUtility retrieveSampleUser];
    
    Person* person =  [parser insertNewPersonModelwithDictionary:jsonDictionary];
    
    [self.subject setupWithPerson:person];
    [self.subject viewWillAppear:NO];
}

- (void)tearDown {
    
    [self.testManagedObjectContext.managedObjectContext reset];
    self.injector = nil;
    self.testManagedObjectContext = nil;
    self.navVC = nil;
    self.subject = nil;
    [super tearDown];
}

- (void)testOnInitItShouldDisplayTheProvidedPersonInAForm
{
    AddressBookItemForm *bookItemForm = self.subject.formController.form;
    
    XCTAssertNotNil(bookItemForm);
    XCTAssertTrue([bookItemForm.title isEqualToString:@"mrs"], @"The form item title should be equal to mrs");
    XCTAssertTrue([bookItemForm.firstName isEqualToString:@"maria"],@"The form item firstName should be equal to maria");
    XCTAssertTrue([bookItemForm.lastName isEqualToString:@"guerrero"], @"The form item lastName should be equal to guerrero");
    
    XCTAssertTrue([bookItemForm.street isEqualToString:@"4957 calle del barquillo"], @"The form item street should be equal to 4957 calle del barquillo");
    XCTAssertTrue([bookItemForm.city isEqualToString:@"logroño"], @"The form item city should be equal to logroño");
    XCTAssertTrue([bookItemForm.state isEqualToString:@"región de murcia"], @"The form item state should be equal to región de murcia");
    XCTAssertTrue([bookItemForm.zip isEqualToString:@"21351"], @"The form item zip should be equal to 21351");
    
    XCTAssertTrue([bookItemForm.email isEqualToString:@"maria.guerrero45@example.com"], @"The form item email should be equal to maria.guerrero45@example.com");
    XCTAssertTrue([bookItemForm.homePhone isEqualToString:@"940-415-345"], @"The form item homePhone should be equal to 940-415-345");
    XCTAssertTrue([bookItemForm.cellPhone isEqualToString:@"623-496-579"], @"The form item cellPhone should be equal to 623-496-579");
    XCTAssertTrue([bookItemForm.displayName isEqualToString:@"maria guerrero"], @"The form item displayName should be equal to maria guerrero");
    XCTAssertTrue([bookItemForm.displayName isEqualToString:@"maria guerrero"]);
}

- (void)testWhenUserPressesSaveItShouldSaveTheEditedPerson
{
    AddressBookItemForm *bookItemForm = self.subject.formController.form;
    FetchPersonService *personService = [self.injector getInstance:[FetchPersonService class]];
    bookItemForm.title = @"mr";
    [self.subject saveButtonTapped];
   
    Person *modifiedPerson = [[personService fetchForLocalPeople] firstObject];
    XCTAssertTrue([modifiedPerson.title isEqualToString:@"mr"], @"The updated person object's title should equal 'mr'");
}


@end
