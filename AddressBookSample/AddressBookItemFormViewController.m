//
//  AddressBookItemFormViewController.m
//  AddressBookSample
//
//  Created by Fahad Muntaz on 2015-05-18.
//  Copyright (c) 2015 Fahad Muntaz. All rights reserved.
//

#import "AddressBookItemFormViewController.h"
#import "AddressBookItemForm.h"
#import "Person.h"
#import "Blindside.h"
#import "PersonParser.h"


@interface AddressBookItemFormViewController ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Person *person;
@property (nonatomic, strong) PersonParser *personParser;

@end

@implementation AddressBookItemFormViewController

+ (BSPropertySet *)bsProperties {
    return [BSPropertySet propertySetWithClass:[self class] propertyNames:@"managedObjectContext",@"personParser", nil];
}

- (void)setupWithPerson:(Person *)person {
    self.person = person;
    AddressBookItemForm *form = [AddressBookItemForm initWithPerson:person];
    self.formController.form = form;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Details";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonTapped)];
}

#pragma mark - actions

- (void)saveButtonTapped {
    [self.view endEditing:YES];
    BOOL didSavePerson = [self.personParser updatePerson:self.person withAddressBookItemForm:self.formController.form];
    if (!didSavePerson) {
        [[[UIAlertView alloc] initWithTitle:@"Couldn't save person" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

@end
