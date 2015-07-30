#import <Cedar/Cedar.h>
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


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(AddressBookItemFormViewControllerSpec)

describe(@"AddressBookItemFormViewController", ^{
    __block AddressBookItemFormViewController *subject;
    __block TestManagedObjectContext *testManagedObjectContext;
    __block UINavigationController *navVC;
    __block id<BSInjector, BSBinder> injector;

    beforeEach(^{
        injector = (id<BSInjector,BSBinder>) [Blindside injectorWithModule:[[AddressBookModule alloc] init]];
        testManagedObjectContext = [TestManagedObjectContext new];
        [injector bind:[NSManagedObjectContext class] toInstance:testManagedObjectContext.managedObjectContext];
        
        BlindsidedStoryboard *storyboard = [BlindsidedStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle] injector:injector];
        
        subject = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([AddressBookItemFormViewController class])];
        navVC = [[UINavigationController alloc] initWithRootViewController:subject];
        
        PersonParser *parser = [injector getInstance:[PersonParser class]];
        NSDictionary *jsonDictionary = [TestUtility retrieveSampleUser];
        
        Person* person =  [parser insertNewPersonModelwithDictionary:jsonDictionary];
        
        [subject setupWithPerson:person];
        [subject viewWillAppear:NO];
    });
    
    afterEach(^{
        [testManagedObjectContext.managedObjectContext reset];
    });
    
    describe(@"upon initialization", ^{
        context(@"when provided a person object", ^{
            
            it(@"should display the person object in a form", ^{
                AddressBookItemForm *bookItemForm = subject.formController.form;
                
                bookItemForm should_not be_nil;
                bookItemForm.title should equal(@"mrs");
                bookItemForm.firstName should equal(@"maria");
                bookItemForm.lastName should equal(@"guerrero");
                
                bookItemForm.street should equal(@"4957 calle del barquillo");
                bookItemForm.city  should equal(@"logroño");;
                bookItemForm.state should equal(@"región de murcia");
                bookItemForm.zip should equal(@"21351");
                
                bookItemForm.email should equal(@"maria.guerrero45@example.com");
                bookItemForm.homePhone should equal(@"940-415-345");
                bookItemForm.cellPhone should equal(@"623-496-579");
                bookItemForm.displayName should equal(@"maria guerrero");
            });
        });
    });
    
    describe(@"when editing a person object", ^{
        
        __block AddressBookItemForm *bookItemForm;
        __block FetchPersonService *personService;
        
        beforeEach(^{
            bookItemForm = subject.formController.form;
            personService = [injector getInstance:[FetchPersonService class]];
        });
        
        context(@"when the user presses save", ^{
            it(@"should save the person object", ^{
                bookItemForm.title = @"mr";
                [subject saveButtonTapped];
                Person *modifiedPerson = [[personService fetchForLocalPeople] firstObject];
                modifiedPerson.title should equal(@"mr");
            });
        });
    });

    
});

SPEC_END
