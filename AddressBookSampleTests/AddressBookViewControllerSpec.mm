#import <Cedar/Cedar.h>
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


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(AddressBookViewControllerSpec)

describe(@"AddressBookViewController", ^{
    __block AddressBookViewController *subject;
    __block UINavigationController *navVC;
    __block id<BSInjector, BSBinder> injector;
    __block NSURLConnectionProvider *fakeConnectionProvider;
    __block TestManagedObjectContext *testManagedObjectContext;

    beforeEach(^{
        injector = (id<BSInjector,BSBinder>) [Blindside injectorWithModule:[[AddressBookModule alloc] init]];
        testManagedObjectContext = [TestManagedObjectContext new];
        fakeConnectionProvider = nice_fake_for([NSURLConnectionProvider class]);
        [injector bind:[NSManagedObjectContext class] toInstance:testManagedObjectContext.managedObjectContext];
        [injector bind:[NSURLConnectionProvider class] toInstance:fakeConnectionProvider];
        
        BlindsidedStoryboard *storyboard = [BlindsidedStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle] injector:injector];
        
        subject = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([AddressBookViewController class])];
        navVC = [[UINavigationController alloc] initWithRootViewController:subject];
        [subject view];
    });
    
    context(@"when displaying people's address'", ^{
        beforeEach(^{
            PersonParser *parser = [injector getInstance:[PersonParser class]];
            NSDictionary *jsonDictionary = [TestUtility retrieveSampleUser];
            
            for (int x = 0; x < 2; x++) {
                [parser insertNewPersonModelwithDictionary:jsonDictionary];
            }
            [subject viewWillAppear:NO];

        });
        
        afterEach(^{
            [testManagedObjectContext.managedObjectContext reset];
        });
        
        it(@"should fetch the address' from local storage", ^{
            subject.people.count should equal(2);
        });
        
    });
    
    context(@"when attempting to add a new person", ^{
        __block NSData *userData;
        
        beforeEach(^{
            userData = [TestUtility loadFixture:@"sampleUser.json"];
            PersonParser *parser = [injector getInstance:[PersonParser class]];
            NSDictionary *jsonDictionary = [TestUtility retrieveSampleUser];
            
            for (int x = 0; x < 2; x++) {
                [parser insertNewPersonModelwithDictionary:jsonDictionary];
            }
            
            fakeConnectionProvider stub_method(@selector(sendAsynchronousRequest:queue:completionHandler:)).and_do_block(^void(NSURLRequest *request, NSOperationQueue *operationQueue, NSURLConnectionProviderCompletionHandler compHandler) {
                if (compHandler) {
                    compHandler(nil, userData, nil);
                }
            });
            
            [subject viewWillAppear:NO];
            
        });
        
        afterEach(^{
            [testManagedObjectContext.managedObjectContext reset];
        });
        
        it(@"should fetch a new person and add that person to the collection", ^{
            [subject addPerson:nil];
            subject.people.count should equal(3);
        });
        
    });
    
    context(@"when wanting to view a person's details", ^{
        beforeEach(^{
            spy_on(subject);
            PersonParser *parser = [injector getInstance:[PersonParser class]];
            NSDictionary *jsonDictionary = [TestUtility retrieveSampleUser];
            [parser insertNewPersonModelwithDictionary:jsonDictionary];
            [subject viewWillAppear:NO];
        });
        
        afterEach(^{
            stop_spying_on(subject);
            [testManagedObjectContext.managedObjectContext reset];
        });
        
        it(@"should navigate to the AddressBookItemFormViewController", ^{
            [subject collectionView:subject.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
            subject should have_received(@selector(prepareForSegue:sender:));
        });
    });
});

SPEC_END
