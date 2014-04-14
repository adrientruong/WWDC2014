//
//  AQTInterestViewController.m
//  WWDC2014
//
//  Created by Adrien Truong on 4/7/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import "AQTInterestViewController.h"
#import "AQTInterest.h"

@interface AQTInterestViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *bodyLabel;
@property (nonatomic, weak) IBOutlet UIImageView *topImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewTopSpaceConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topImageViewHeightConstraint;

@property (nonatomic, assign) CGPoint lastContentOffset;

@end

@implementation AQTInterestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleLabel.text = self.interest.title;
    self.subtitleLabel.text = self.interest.subtitle;
    self.bodyLabel.attributedText = self.interest.bodyText;
    self.topImageView.image = self.interest.image;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGRect frame = self.tabBarController.tabBar.frame;
    frame.origin.y = self.tabBarController.view.frame.size.height - frame.size.height;
    self.tabBarController.tabBar.frame = frame;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.lastContentOffset = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat normalHeight = 169.0;
    if (scrollView.contentOffset.y < 0) {
        self.topImageViewHeightConstraint.constant = normalHeight + (-scrollView.contentOffset.y);
        self.contentViewTopSpaceConstraint.constant = scrollView.contentOffset.y;
        
        [self.view needsUpdateConstraints];
    }
    else if (scrollView.contentOffset.y > 0 && self.lastContentOffset.y < 0) {
        self.topImageViewHeightConstraint.constant = normalHeight;
        self.contentViewTopSpaceConstraint.constant = 0;
        
        [self.view needsUpdateConstraints];
    }
    
    if (scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height - 0.5 || scrollView.contentOffset.y < 0) {
        return;
    }
    
    CGRect tabBarFrame = self.tabBarController.tabBar.frame;
    CGRect viewFrame = self.tabBarController.view.frame;
    
    BOOL scrollingDown = scrollView.contentOffset.y > self.lastContentOffset.y;
    if (scrollingDown && tabBarFrame.origin.y < viewFrame.size.height) {
        tabBarFrame.origin.y += (scrollView.contentOffset.y - self.lastContentOffset.y);
        tabBarFrame.origin.y = MIN(viewFrame.size.height, tabBarFrame.origin.y);

        self.tabBarController.tabBar.frame = tabBarFrame;
    }
    else if (scrollingDown == NO && scrollView.isDecelerating && scrollView.decelerationRate >= UIScrollViewDecelerationRateFast) {
        tabBarFrame.origin.y = viewFrame.size.height - tabBarFrame.size.height;
        
        [UIView animateWithDuration:0.15 animations:^{
            self.tabBarController.tabBar.frame = tabBarFrame;
        }];
    }
    
    self.lastContentOffset = scrollView.contentOffset;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGRect tabBarFrame = self.tabBarController.tabBar.frame;
    float percentToBottom = 1 - ((self.tabBarController.view.frame.size.height - tabBarFrame.origin.y) / tabBarFrame.size.height);
    
    if (percentToBottom >= 0.5 && percentToBottom < 1) {
        tabBarFrame.origin.y = self.view.frame.size.height;
    }
    else if (percentToBottom > 0 && percentToBottom < 0.5) {
        tabBarFrame.origin.y = self.tabBarController.view.frame.size.height - tabBarFrame.size.height;
    }
    
    if (CGRectEqualToRect(self.tabBarController.tabBar.frame, tabBarFrame) == NO) {
        [UIView animateWithDuration:0.15 animations:^{
            self.tabBarController.tabBar.frame = tabBarFrame;
        }];
    }
}

@end
