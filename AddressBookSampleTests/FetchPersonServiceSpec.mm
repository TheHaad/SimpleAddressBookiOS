#import <Cedar/Cedar.h>
#import "FetchPersonService.h"
#import "Blindside.h"
#import "AddressBookModule.h"
#import <CoreData/CoreData.h>
#import "NSURLConnectionProvider.h"
#import "Person.h"
#import "PersonParser.h"
#import "TestUtility.h"
#import "TestManagedObjectContext.h"


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(FetchPersonServiceSpec)

describe(@"FetchPersonService", ^{
    __block FetchPersonService *subject;
    __block id<BSInjector, BSBinder> injector;
    __block TestManagedObjectContext *testManagedObjectContext;
    __block NSURLConnectionProvider *fakeUrlProvider;

    beforeEach(^{
        injector = (id<BSInjector,BSBinder>) [Blindside injectorWithModule:[[AddressBookModule alloc] init]];
        testManagedObjectContext = [TestManagedObjectContext new];
        fakeUrlProvider = nice_fake_for([NSURLConnectionProvider class]);
        [injector bind:[NSManagedObjectContext class] toInstance:testManagedObjectContext.managedObjectContext];
        
        [injector bind:[NSURLConnectionProvider class] toInstance:fakeUrlProvider];

    });

    
    context(@"fetchPersonWithCompletionBlockFailureBlock:", ^{
        __block PersonParser *fakePersonParser;
        beforeEach(^{
            fakePersonParser = nice_fake_for([PersonParser class]);
            [injector bind:[PersonParser class] toInstance:fakePersonParser];
            subject = [injector getInstance:[FetchPersonService class]];
        });
        context(@"on completion", ^{
            beforeEach(^{
                fakeUrlProvider stub_method(@selector(sendAsynchronousRequest:queue:completionHandler:)).and_do_block(^void(NSURLRequest *request, NSOperationQueue *operationQueue,
                    NSURLConnectionProviderCompletionHandler compHandler){
                    if (compHandler) {
                        NSData *data = [TestUtility loadFixture:@"sampleUser.json"];
                        compHandler(nil, data, nil);
                    }
                });
                
                fakePersonParser stub_method(@selector(insertNewPersonModelwithDictionary:)).and_return(nil);
            });
            
            
            it(@"should call the completion block ", ^{
                __block BOOL completionBlockCalled = NO;
                [subject fetchPersonWithCompletionBlock:^(Person *person) {
                    completionBlockCalled = YES;
                } failureBlock:nil];
                
                completionBlockCalled should be_truthy;
            });
        });
        
        sharedExamplesFor(@"failure block should execute", ^(NSDictionary *sharedContext) {
            it(@"should call the failure block", ^{
                __block BOOL failureBlockCalled = NO;
                [subject fetchPersonWithCompletionBlock:nil failureBlock:^(NSError *error) {
                    failureBlockCalled = YES;
                }];
                
                failureBlockCalled should be_truthy;
            });
        });
        
        context(@"on failure", ^{
            context(@"when a connection error occurs", ^{
                __block NSError *connectionError;
                beforeEach(^{
                    connectionError = [NSError new];
                    fakeUrlProvider stub_method(@selector(sendAsynchronousRequest:queue:completionHandler:)).and_do_block(^void(NSURLRequest *request, NSOperationQueue *operationQueue,
                                                                                                                                NSURLConnectionProviderCompletionHandler compHandler){
                        if (compHandler) {
                            compHandler(nil, nil, connectionError);
                        }
                    });
                    
                });
                
                itShouldBehaveLike(@"failure block should execute");

            });
            
            context(@"when a json error occurs", ^{
                __block NSData *jsonData;
                beforeEach(^{
                    jsonData = [TestUtility loadFixture:@"sampleUserError.json"];
                    fakeUrlProvider stub_method(@selector(sendAsynchronousRequest:queue:completionHandler:)).and_do_block(^void(NSURLRequest *request, NSOperationQueue *operationQueue,
                                                                                                                                NSURLConnectionProviderCompletionHandler compHandler){
                        if (compHandler) {

                            compHandler(nil, jsonData, nil);
                        }
                    });
                });
                
                itShouldBehaveLike(@"failure block should execute");

            });
        });
    });
    
    context(@"fetchForLocalPeople", ^{
        beforeEach(^{
            subject = [injector getInstance:[FetchPersonService class]];
            NSData *data = [TestUtility loadFixture:@"sampleUser.json"];
            NSError *error;
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            PersonParser *parser = [injector getInstance:[PersonParser class]];
            for (int x = 0; x < 3; x++) {
                [parser insertNewPersonModelwithDictionary:jsonDictionary];
            }
        });
        
        afterEach(^{
            [testManagedObjectContext.managedObjectContext reset];
        });
        it(@"should return the amount of people stored", ^{
            NSArray *people = [subject fetchForLocalPeople];
            people.count should equal(3);
        });
    });
});

SPEC_END
