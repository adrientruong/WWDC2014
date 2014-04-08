//
//  AQTAppsViewController.m
//  WWDC2014
//
//  Created by Adrien Truong on 4/5/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import "AQTAppsViewController.h"
#import "AQTApp.h"
#import "AQTAppCollectionViewCell.h"
#import "AQTAppCollectionViewCell+AQTApp.h"
#import "UIView+AQTNib.h"
#import "CoverFlowLayout.h"
#import <LEColorPicker.h>
#import <ColorArt/UIImage+ColorArt.h>

@import StoreKit;

#define kAppCellReuseIdentifier NSStringFromClass([AQTAppCollectionViewCell class])

@interface AQTAppsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, SKStoreProductViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UILabel *appNameLabel;
@property (nonatomic, weak) IBOutlet UITextView *appInfoTextView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *storeBarButtonItem;

@property (nonatomic, weak) AQTApp *currentApp;

- (IBAction)storeButtonWasTapped;

@end

@implementation AQTAppsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CoverFlowLayout *layout = [[CoverFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(120, 120);
    self.collectionView.collectionViewLayout = layout;
    
    UINib *nib = [AQTAppCollectionViewCell nib];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:kAppCellReuseIdentifier];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UICollectionElementKindSectionHeader];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:UICollectionElementKindSectionFooter];
    
    [self addMotionEffectsToCollectionVIew];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Apps" ofType:@"plist"];
    NSArray *appDictionaries = [NSArray arrayWithContentsOfFile:path];
    self.apps = [AQTApp appsWithDictionaries:appDictionaries];
    
    [self updateViewWithApp:[self.apps firstObject]];
}

- (void)addMotionEffectsToCollectionVIew
{
    
    UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                                type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @-5;
    horizontalMotionEffect.maximumRelativeValue = @5;
    
    UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                            type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @-5;
    verticalMotionEffect.maximumRelativeValue = @5;
    
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    [self.collectionView addMotionEffect:group];
}

#pragma mark - Actions

- (IBAction)storeButtonWasTapped
{
    SKStoreProductViewController *storeViewController = [[SKStoreProductViewController alloc] init];
    storeViewController.delegate = self;
    
    NSDictionary *parameters = @{SKStoreProductParameterITunesItemIdentifier: self.currentApp.iTunesItemIdentifier};
    
    __weak AQTAppsViewController *weakSelf = self;
    [storeViewController loadProductWithParameters:parameters completionBlock:^(BOOL success, NSError *error) {
        if (success == NO) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            
            NSLog(@"%@", [error userInfo]);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription] message:@"Something went wrong loading the app store. Maybe check your internet connnection?" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alertView show];
            
            return;
        }
    }];
    
    [self presentViewController:storeViewController animated:YES completion:nil];
}

#pragma mark - SKStoreProductViewControllerDelegate

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.apps count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader] || [kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *padding = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kind forIndexPath:indexPath];
        return padding;
    }
    
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AQTAppCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAppCellReuseIdentifier forIndexPath:indexPath];
    AQTApp *app = self.apps[indexPath.row];
    
    [cell configureWithApp:app];
    
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint center = CGPointZero;
    center.x = scrollView.contentOffset.x + (scrollView.frame.size.width / 2);
    center.y = scrollView.frame.size.height / 2;
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:center];
    
    [self updateViewWithAppAtIndexPath:indexPath];
}

- (void)updateViewWithAppAtIndexPath:(NSIndexPath *)indexPath
{
    AQTApp *app = self.apps[indexPath.row];
    [self updateViewWithApp:app];
}

- (void)updateViewWithApp:(AQTApp *)app
{
    self.appNameLabel.text = app.name;
    self.appInfoTextView.attributedText = app.infoText;
    
    self.storeBarButtonItem.enabled = ([app.iTunesItemIdentifier length] > 0);
    
    NSArray *colorPickers = @[@"USAlliance", @"Guess Dat Song", @"Globaclock"];
    
    if ([app.name isEqualToString:@"Workout Hero"]) {
        self.view.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:42.0f/255.0f alpha:1.0];
        self.appNameLabel.textColor = [UIColor colorWithRed:213.0f/255.0f green:0 blue:4.0f/255.0f alpha:1.0];
        self.appInfoTextView.textColor = [UIColor blackColor];
    }
    else if ([colorPickers containsObject:app.name]) {
        LEColorPicker *colorPicker = [[LEColorPicker alloc] init];
        LEColorScheme *scheme = [colorPicker colorSchemeFromImage:app.squircleIcon];
        self.view.backgroundColor = scheme.backgroundColor;
        self.appNameLabel.textColor = scheme.primaryTextColor;
        self.appInfoTextView.textColor = scheme.secondaryTextColor;
    }
    else {
        SLColorArt *colorArt = [app.squircleIcon colorArt];
        self.view.backgroundColor = colorArt.backgroundColor;
        self.appNameLabel.textColor = colorArt.primaryColor;
        self.appInfoTextView.textColor = colorArt.detailColor;
    }
    
    self.currentApp = app;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
    CGPoint offset = CGPointMake(attributes.center.x - collectionView.frame.size.width / 2, 0);
    [collectionView setContentOffset:offset animated:YES];
    
    [self updateViewWithAppAtIndexPath:indexPath];
}

@end
