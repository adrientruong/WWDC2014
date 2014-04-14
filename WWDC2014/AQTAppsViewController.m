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
#import "LEColorPicker.h"
#import "ColorArt/UIImage+ColorArt.h"
#import "AQTVideoFeatureMonitor.h"
#import "AQTAppsHintView.h"
#import "FXBlurView.h"

@import StoreKit;

#define kAppCellReuseIdentifier NSStringFromClass([AQTAppCollectionViewCell class])

@interface AQTAppsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, SKStoreProductViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UILabel *appNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *appInfoLabel;
@property (nonatomic, weak) IBOutlet UITextView *appInfoTextView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *storeBarButtonItem;
@property (nonatomic, weak) IBOutlet UIView *topBackgroundView;

@property (nonatomic, weak) AQTAppsHintView *hintView;

@property (nonatomic, strong) AQTVideoFeatureMonitor *featureMonitor;

@property (nonatomic, weak) AQTApp *currentApp;

@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

@end

@implementation AQTAppsViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.tabBarItem.selectedImage = [UIImage imageNamed:@"apps-icon-selected"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.appInfoTextView.textContainerInset = UIEdgeInsetsMake(0, 14, 6, 14);
    
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
    
    UINib *hintViewNib = [AQTAppsHintView nib];
    NSArray *objects = [hintViewNib instantiateWithOwner:self options:nil];
    AQTAppsHintView *hintView = [objects firstObject];
    hintView.translatesAutoresizingMaskIntoConstraints = NO;
    hintView.blurView.underlyingView = self.view;
    
    [self.view addSubview:hintView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(hintView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[hintView]-(10)-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(168)-[hintView(==200)]" options:0 metrics:nil views:views]];
    
    self.hintView = hintView;
    
    AQTVideoFeatureMonitor *monitor = [[AQTVideoFeatureMonitor alloc] init];
    monitor.featureValues = @{@"hasSmile": @YES};
    monitor.detectorFeatureOptions = @{CIDetectorSmile: @YES};
    monitor.ignoreTimeIntervalAfterDetect = 5;
    
    monitor.didDetectHandler = ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self userDidSmileOrShake];
        });        
    };
    
    self.featureMonitor = monitor;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tabBarController.tabBar.tintColor = [UIColor colorWithRed:84.0f/255.0f green:154.0f/255.0f blue:202.0f/255.0f alpha:1.0];
    });
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self becomeFirstResponder];
    
    [self.featureMonitor startMonitoring];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self resignFirstResponder];
    
    [self.featureMonitor stopMonitoring];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.appInfoTextView.contentInset = UIEdgeInsetsMake(0, 0, self.tabBarController.tabBar.frame.size.height, 0);
    self.appInfoTextView.scrollIndicatorInsets = self.appInfoTextView.contentInset;
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
    
    UIColor *topColor = nil;
    UIColor *bottomColor = nil;
    
    if ([app.name isEqualToString:@"Workout Hero"]) {
        topColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:42.0f/255.0f alpha:1.0];
        bottomColor = [UIColor colorWithRed:0.0f/255.0f green:142.0f/255 blue:244.0f/255.0f alpha:1.0];
    }
    else if ([colorPickers containsObject:app.name]) {
        LEColorPicker *colorPicker = [[LEColorPicker alloc] init];
        LEColorScheme *scheme = [colorPicker colorSchemeFromImage:app.squircleIcon];
        topColor = scheme.backgroundColor;
        bottomColor = scheme.primaryTextColor;
    }
    else {
        SLColorArt *colorArt = [app.squircleIcon colorArt];
        topColor = colorArt.backgroundColor;
        bottomColor = colorArt.primaryColor;
    }
    
    NSArray *whiteTextColor = @[@"Workout Hero", @"USAlliance", @"Guess Dat Song"];
    
    UIColor *infoTextColor = nil;
    if ([whiteTextColor containsObject:app.name]) {
        infoTextColor = [UIColor whiteColor];
    }
    else {
        infoTextColor = [UIColor blackColor];
    }
    
    [UIView animateWithDuration:0.30 animations:^{
        self.topBackgroundView.backgroundColor = topColor;
        self.view.backgroundColor = bottomColor;
        self.appNameLabel.textColor = topColor;
        self.appInfoTextView.textColor = infoTextColor;
    }];
    
    self.appInfoTextView.contentOffset = CGPointZero;
    
    NSArray *whiteStatusBarAppNames = @[@"Timers Pro", @"Globaclock"];
    if ([whiteStatusBarAppNames containsObject:app.name]) {
        self.statusBarStyle = UIStatusBarStyleLightContent;
    }
    else {
        self.statusBarStyle = UIStatusBarStyleDefault;
    }
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.currentApp = app;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
    CGPoint offset = CGPointMake(attributes.center.x - collectionView.frame.size.width / 2, 0);
    [collectionView setContentOffset:offset animated:YES];
    
    [self updateViewWithAppAtIndexPath:indexPath];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.statusBarStyle;
}

#pragma mark - Shake to Open Store

- (void)openStoreProductViewController
{
    SKStoreProductViewController *storeViewController = [[SKStoreProductViewController alloc] init];
    storeViewController.delegate = self;
    
    NSDictionary *parameters = @{SKStoreProductParameterITunesItemIdentifier: self.currentApp.iTunesItemIdentifier};
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    __weak AQTAppsViewController *weakSelf = self;
    [storeViewController loadProductWithParameters:parameters completionBlock:^(BOOL success, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
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

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)userDidSmileOrShake
{
    if (self.hintView != nil) {
        [UIView animateWithDuration:0.3 animations:^{
            self.hintView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.hintView removeFromSuperview];
            self.hintView = nil;
        }];
    }
    else {
        [self userWantsToOpenStore];
    }
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake) {
        [self userDidSmileOrShake];
    }
}

- (void)userWantsToOpenStore
{
    if ([self.currentApp.iTunesItemIdentifier length] > 0) {
        [self openStoreProductViewController];
    }
    else {
        NSString *title = NSLocalizedString(@"Sorry about that.", @"");
        NSString *message = NSLocalizedString(@"USAlliance is an enterprise app and is not available on the app store.", @"");
        NSString *okayTitle = NSLocalizedString(@"Okay", @"");
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:okayTitle otherButtonTitles:nil];
        
        [alertView show];
    }
}

@end
