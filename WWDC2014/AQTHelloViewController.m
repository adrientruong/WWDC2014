//
//  AQTHelloViewController.m
//  WWDC2014
//
//  Created by Adrien Truong on 4/4/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import "AQTHelloViewController.h"
#import "AQTSlideToUnlockView.h"
#import "AQTIntroViewController.h"

@interface AQTHelloViewController ()

@property (nonatomic, weak) IBOutlet AQTSlideToUnlockView *slideToUnlockView;

@end

@implementation AQTHelloViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *helloViewNib = [UINib nibWithNibName:@"HelloView" bundle:nil];
    NSArray *objects = [helloViewNib instantiateWithOwner:self options:nil];
    self.slideToUnlockView.contentView = [objects firstObject];
    
    self.slideToUnlockView.unlockTextLabel.text = @"slide to start";
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)didUnlock:(AQTSlideToUnlockView *)unlockView
{
    if (unlockView.isUnlocked) {
        NSString *identifier = NSStringFromClass([AQTIntroViewController class]);
        AQTIntroViewController *introViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
        [self.navigationController pushViewController:introViewController animated:NO];
    }
}

@end
