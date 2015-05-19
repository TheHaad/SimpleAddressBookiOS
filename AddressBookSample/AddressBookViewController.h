//
//  AddressBookViewController.h
//  AddressBookSample
//
//  Created by Fahad Muntaz on 2015-05-16.
//  Copyright (c) 2015 Fahad Muntaz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressBookViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *people;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBarButtonItem;

- (IBAction)addPerson:(id)sender;

@end
