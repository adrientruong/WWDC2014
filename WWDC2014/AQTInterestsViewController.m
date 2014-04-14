//
//  AQTInterestsViewController.m
//  WWDC2014
//
//  Created by Adrien Truong on 4/8/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import "AQTInterestsViewController.h"
#import "AQTInterest.h"
#import "AQTInterestViewController.h"

@interface AQTInterestsViewController () <UIPageViewControllerDataSource>

@property (nonatomic, weak) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *interests;

@end

@implementation AQTInterestsViewController

#pragma mark - View Life Cycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.tabBarItem.selectedImage = [UIImage imageNamed:@"interests-icon-selected"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Interests" ofType:@"plist"];
    NSArray *interestDictionaries = [NSArray arrayWithContentsOfFile:path];
    self.interests = [AQTInterest interestsWithDictionaries:interestDictionaries];
    
    UIPageViewController *pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    pageViewController.dataSource = self;
    
    AQTInterestViewController *initialViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([AQTInterestViewController class])];
    initialViewController.interest = [self.interests firstObject];
    [pageViewController setViewControllers:@[initialViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:pageViewController];
    [self.view addSubview:pageViewController.view];
    [pageViewController didMoveToParentViewController:self];
    
    UIView *pageView = pageViewController.view;
    NSDictionary *views = NSDictionaryOfVariableBindings(pageView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pageView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[pageView]|" options:0 metrics:nil views:views]];
    
    self.pageViewController = pageViewController;
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    AQTInterestViewController *interestViewController = (AQTInterestViewController *)viewController;
    NSInteger index = [self.interests indexOfObjectIdenticalTo:interestViewController.interest];
    index--;
    
    if (index == -1) {
        return nil;
    }
    
    AQTInterestViewController *beforeViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([AQTInterestViewController class])];
    beforeViewController.interest = self.interests[index];
    
    return beforeViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    AQTInterestViewController *interestViewController = (AQTInterestViewController *)viewController;
    NSInteger index = [self.interests indexOfObjectIdenticalTo:interestViewController.interest];
    index++;
    
    if (index == [self.interests count]) {
        return nil;
    }
    
    AQTInterestViewController *beforeViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([AQTInterestViewController class])];
    beforeViewController.interest = self.interests[index];
    
    return beforeViewController;
}

#pragma mark - Status Bar

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
