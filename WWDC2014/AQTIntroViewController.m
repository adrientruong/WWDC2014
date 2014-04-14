//
//  AQTIntroViewController.m
//  WWDC2014
//
//  Created by Adrien Truong on 4/5/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import "AQTIntroViewController.h"
#import "AQTIntroChildView.h"
#import "AQTIntroPart3View.h"

@interface AQTIntroViewController ()

@property (nonatomic, strong) NSArray *views;
@property (nonatomic, assign) NSInteger currentViewIndex;
@property (nonatomic, readonly) AQTIntroChildView *currentView;

@end

@implementation AQTIntroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    UINib *nib = [UINib nibWithNibName:@"AQTIntroViews" bundle:nil];
    NSArray *views = [nib instantiateWithOwner:self options:nil];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES];
    views = [views sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    self.views = views;
    
    self.currentViewIndex = -1;
    [self nextView];
}

- (AQTIntroChildView *)currentView
{
    return self.views[self.currentViewIndex];
}

- (void)nextView
{
    if (self.currentViewIndex == [self.views count] - 1) {
        return;
    }
    
    if (self.currentViewIndex != -1) {
        [self.currentView removeFromSuperview];
    }
    
    self.currentViewIndex++;
    
    AQTIntroChildView *view = self.views[self.currentViewIndex];
    [self.view addSubview:view];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(view);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:views]];
    
    [view startAnimationWithCompletion:^{
        [self nextView];
    }];
    
    if ([view isKindOfClass:[AQTIntroPart3View class]]) {
        AQTIntroPart3View *part3 = (AQTIntroPart3View *)view;
        [part3.enterButton addTarget:self action:@selector(enterButtonWasTapped) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)enterButtonWasTapped
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
