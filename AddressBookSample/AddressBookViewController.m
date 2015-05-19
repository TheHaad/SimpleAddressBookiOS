//
//  AddressBookViewController.m
//  AddressBookSample
//
//  Created by Fahad Muntaz on 2015-05-16.
//  Copyright (c) 2015 Fahad Muntaz. All rights reserved.
//

#import "AddressBookViewController.h"
#import "AppDelegate.h"
#import "Person.h"
#import "AddressBookCollectionViewCell.h"
#import "FetchPersonService.h"
#import "AddressBookItemFormViewController.h"
#import "AddressBookItemForm.h"
#import "Blindside.h"
#import "BlindsidedStoryboard.h"


@interface AddressBookViewController ()

@property (nonatomic, strong) FetchPersonService *fetchPersonService;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingSpinner;
@property (nonatomic, strong) Person *selectedPerson;

@end

@implementation AddressBookViewController

#pragma mark - Lifecycle

+ (BSPropertySet *)bsProperties {
    return [BSPropertySet propertySetWithClass:[self class] propertyNames:@"fetchPersonService", nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchForLocalPeople];
}

#pragma mark - <UICollectionViewDelegate,Datasource,FlowLayout>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.people.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width, [AddressBookCollectionViewCell height]);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AddressBookCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AddressBookCollectionViewCell class]) forIndexPath:indexPath];
    [cell setupWithPerson:[self.people objectAtIndex:indexPath.item]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedPerson = [self.people objectAtIndex:indexPath.item];
    [self performSegueWithIdentifier:@"showAddressBookItemSegue" sender:self];
}

#pragma mark - IBActions

- (IBAction)addPerson:(id)sender {
    
    __weak __typeof(self) weakSelf = self;
    [self startLoading];
    [self.fetchPersonService fetchPersonWithCompletionBlock:^(Person *person) {
        [weakSelf fetchForLocalPeople];
    } failureBlock:^(NSError *error) {
        [weakSelf stopLoading];
        [[[UIAlertView alloc] initWithTitle:@"Couldn't fetch person" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showAddressBookItemSegue"]) {
        AddressBookItemFormViewController *formVc = (AddressBookItemFormViewController *)segue.destinationViewController;
        [formVc setupWithPerson:self.selectedPerson];
    }
}

#pragma mark - Private

- (void)fetchForLocalPeople {
    [self startLoading];
    self.people = [self.fetchPersonService fetchForLocalPeople];
    [self.collectionView reloadData];
    [self stopLoading];
}

- (void)startLoading {
    [self.loadingSpinner startAnimating];
}

-(void)stopLoading {
    [self.loadingSpinner stopAnimating];
}

@end
