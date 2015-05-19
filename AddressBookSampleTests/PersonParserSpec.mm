#import <Cedar/Cedar.h>
#import "PersonParser.h"
#import "Blindside.h"
#import "AddressBookModule.h"
#import <CoreData/CoreData.h>
#import "TestUtility.h"
#import "Person.h"
#import "TestManagedObjectContext.h"
#import "FetchPersonService.h"
#import "AddressBookItemForm.h"


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(PersonParserSpec)

describe(@"PersonParser", ^{
    __block PersonParser *subject;
    __block id<BSInjector, BSBinder> injector;
    __block TestManagedObjectContext *testManagedObjectContext;
    
    beforeEach(^{
        injector = (id<BSInjector,BSBinder>) [Blindside injectorWithModule:[[AddressBookModule alloc] init]];
        
        testManagedObjectContext = [TestManagedObjectContext new];
        [injector bind:[NSManagedObjectContext class] toInstance:testManagedObjectContext.managedObjectContext];
        subject = [injector getInstance:[PersonParser class]];
    });
    
    context(@"insertNewPersonModelwithDictionary", ^{
        __block NSDictionary *jsonDictionary;
        beforeEach(^{
            NSData *data = [TestUtility loadFixture:@"sampleUser.json"];
            NSError *error;
            jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        });
        
        afterEach(^{
            [testManagedObjectContext.managedObjectContext reset];
        });
        
        it(@"should add a new person", ^{
            Person * person = [subject insertNewPersonModelwithDictionary:jsonDictionary];
            person should_not be_nil;
            person.title should equal(@"mrs");
            person.firstName should equal(@"maria");
            person.lastName should equal(@"guerrero");
            
            person.street should equal(@"4957 calle del barquillo");
            person.city  should equal(@"logroño");;
            person.state should equal(@"región de murcia");
            person.zip should equal(@"21351");
            
            person.email should equal(@"maria.guerrero45@example.com");
            person.homePhone should equal(@"940-415-345");
            person.cellPhone should equal(@"623-496-579");
            person.displayName should equal(@"maria guerrero");
        });
    });
    
    context(@"updatePersonWithAddressBookItemForm", ^{
        __block Person *person;
        beforeEach(^{
            NSData *data = [TestUtility loadFixture:@"sampleUser.json"];
            NSError *error;
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            person = [subject insertNewPersonModelwithDictionary:jsonDictionary];
        });
        
        afterEach(^{
            [testManagedObjectContext.managedObjectContext reset];
        });
        
        it(@"should update the person object with the new data from the form", ^{
            AddressBookItemForm *form = [AddressBookItemForm initWithPerson:person];
            form.firstName = @"mark";
            [subject updatePerson:person withAddressBookItemForm:form];
            person.firstName should equal(@"mark");
        });
    });
});

SPEC_END
