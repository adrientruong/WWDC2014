//
//  AQTSlideToUnlockView.m
//  WWDC2014
//
//  Created by Adrien Truong on 4/4/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import "AQTSlideToUnlockView.h"
#import <FBShimmeringView.h>

@interface AQTSlideToUnlockView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSLayoutConstraint *unlockTextLabelCenterXConstraint;

@property (nonatomic, weak, readwrite) UILabel *unlockTextLabel;
@property (nonatomic, strong) FBShimmeringView *shimmeringView;

@end

@implementation AQTSlideToUnlockView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.pagingEnabled = YES;
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    
    [self addSubview:scrollView];
    
    UILabel *unlockTextLabel = [[UILabel alloc] init];
    unlockTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
    unlockTextLabel.textAlignment = NSTextAlignmentCenter;
    unlockTextLabel.textColor = [UIColor whiteColor];
    unlockTextLabel.font = [UIFont systemFontOfSize:27];
    
    UIImage *chevronImage = [UIImage imageNamed:@"right-chevron"];
    UIImageView *chevronImageView = [[UIImageView alloc] initWithImage:chevronImage];
    chevronImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *shimmeringContentView = [[UIView alloc] init];
    shimmeringContentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [shimmeringContentView addSubview:chevronImageView];
    [shimmeringContentView addSubview:unlockTextLabel];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(chevronImageView, unlockTextLabel);
    [shimmeringContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[chevronImageView]-(10)-[unlockTextLabel]|" options:0 metrics:nil views:views]];
    [shimmeringContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[chevronImageView]|" options:0 metrics:nil views:views]];
    [shimmeringContentView addConstraint:[NSLayoutConstraint constraintWithItem:unlockTextLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:shimmeringContentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    //initWithFrame because of bug with FBShimmeringView
    //just init causes the shimmer to be really fast
    FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:self.bounds];
    shimmeringView.contentView = shimmeringContentView;
    shimmeringView.shimmering = YES;
    shimmeringView.translatesAutoresizingMaskIntoConstraints = NO;
    
    views = NSDictionaryOfVariableBindings(shimmeringContentView);
    [shimmeringView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[shimmeringContentView]|" options:0 metrics:nil views:views]];
    [shimmeringView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[shimmeringContentView]|" options:0 metrics:nil views:views]];

    views = NSDictionaryOfVariableBindings(scrollView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics:nil views:views]];
    
    self.scrollView = scrollView;
    self.unlockTextLabel = unlockTextLabel;
    self.shimmeringView = shimmeringView;
}

- (void)setBackgroundView:(UIView *)backgroundView
{
    [self.backgroundView removeFromSuperview];
    
    _backgroundView = backgroundView;
    
    [self insertSubview:self.backgroundView atIndex:0];
    NSDictionary *views = NSDictionaryOfVariableBindings(_backgroundView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backgroundView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_backgroundView]|" options:0 metrics:nil views:views]];
}

- (void)setContentView:(UIView *)contentView
{
    _contentView = contentView;
    
    if (self.contentView.superview != self.scrollView) {
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView removeFromSuperview];
        [self.scrollView addSubview:self.contentView];
    }
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_contentView, _shimmeringView);
    CGFloat pageWidth = self.frame.size.width;
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(pageWidth)-[_contentView(==pageWidth)]|" options:0 metrics:@{@"pageWidth": @(pageWidth)} views:views]];
    CGFloat height = self.frame.size.height;
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentView(==height)]|" options:0 metrics:@{@"height": @(height)} views:views]];
    
    [self.shimmeringView removeFromSuperview];
    [self.contentView addSubview:self.shimmeringView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.shimmeringView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0
                                                                  constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_shimmeringView]-60-|" options:0 metrics:nil views:views]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.scrollView.contentOffset = CGPointMake(pageWidth, 0);
    });
}

- (void)setUnlocked:(BOOL)unlocked
{
    _unlocked = unlocked;
    
    if (self.isUnlocked) {
        self.scrollView.contentOffset = CGPointZero;
    }
    else {
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if (page == 0) {
        self.unlocked = YES;
        
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

@end
