//
//  AQTScreenshotsViewController.m
//  WWDC2014
//
//  Created by Adrien on 4/12/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import "AQTScreenshotsViewController.h"
#import "AQTScreenshotCollectionViewCell.h"
#import "UIView+AQTNib.h"

#define kCellReuseIdentifier NSStringFromClass([AQTScreenshotCollectionViewCell class])

@interface AQTScreenshotsViewController () <UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation AQTScreenshotsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 15;
    layout.sectionInset = UIEdgeInsetsMake(0, 7, 0, 7);
    layout.itemSize = CGSizeMake(196, 348); //shouldn't hard code this but...
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:collectionView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(collectionView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|" options:0 metrics:nil views:views]];
    
    UINib *nib = [AQTScreenshotCollectionViewCell nib];
    [collectionView registerNib:nib forCellWithReuseIdentifier:kCellReuseIdentifier];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.screenshots count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AQTScreenshotCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    
    cell.imageView.image = self.screenshots[indexPath.row];
    
    return cell;
}

- (void)setScreenshots:(NSArray *)screenshots
{
    _screenshots = screenshots;
    
    [self.collectionView reloadData];
}

@end
