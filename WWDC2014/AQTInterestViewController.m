//
//  AQTInterestViewController.m
//  WWDC2014
//
//  Created by Adrien Truong on 4/7/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import "AQTInterestViewController.h"

@interface AQTInterestViewController ()

@property (nonatomic, weak) IBOutlet UITextView *textView;

@end

@implementation AQTInterestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.textView setTextContainerInset:UIEdgeInsetsMake(15, 10, 8, 10)];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    UIEdgeInsets contentInset = self.textView.contentInset;
    contentInset.bottom = self.bottomLayoutGuide.length;
    self.textView.contentInset = contentInset;
    self.textView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, self.bottomLayoutGuide.length, 0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
