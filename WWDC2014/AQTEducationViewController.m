//
//  AQTEducationViewController.m
//  WWDC2014
//
//  Created by Adrien Truong on 4/6/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import "AQTEducationViewController.h"
#import "AQTEducationCellInfo.h"
#import "AQTEducationTableViewCell+AQTEducationCellInfo.h"
#import "UIView+AQTNib.h"
#import "FXBlurView.h"

#define kCellReuseIdentifier NSStringFromClass([AQTEducationTableViewCell class])

@interface AQTEducationViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet FXBlurView *statusBarBlurView;

@property (nonatomic, strong) NSArray *cellInfos;

@end

@implementation AQTEducationViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.tabBarItem.selectedImage = [UIImage imageNamed:@"education-icon-selected"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"EducationCellInfos" ofType:@"plist"];
    NSArray *cellInfoDictionaries = [NSArray arrayWithContentsOfFile:path];
    self.cellInfos = [AQTEducationCellInfo infosWithDictionaries:cellInfoDictionaries];
    
    UINib *nib = [AQTEducationTableViewCell nib];
    [self.tableView registerNib:nib forCellReuseIdentifier:kCellReuseIdentifier];
    
    self.tableView.rowHeight = [AQTEducationTableViewCell rowHeight];
    
    UIImage *background = [UIImage imageNamed:@"hello-background"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    self.tableView.backgroundView = imageView;
    
    self.statusBarBlurView.underlyingView = self.tableView;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.tabBarController.tabBar.frame.size.height, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.cellInfos count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AQTEducationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier];
    AQTEducationCellInfo *info = self.cellInfos[indexPath.section];
    
    [cell configureWithInfo:info];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    AQTEducationTableViewCell *educationCell = (AQTEducationTableViewCell *)cell;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [educationCell.blurView setNeedsDisplay];
    });
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
