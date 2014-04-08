//
//  AQTInterestsViewController.m
//  WWDC2014
//
//  Created by Adrien Truong on 4/6/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import "AQTInterestsViewController.h"
#import "AQTInterestTableViewCell.h"
#import "UIView+AQTNib.h"
#import "AQTInterest.h"
#import "AQTInterestTableViewCell+AQTInterest.h"

#define kInterestCellReuseIdentifier NSStringFromClass([AQTInterestTableViewCell class])

@interface AQTInterestsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *interests;

@end

@implementation AQTInterestsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.tableView.rowHeight = [AQTInterestTableViewCell rowHeight];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.01)];
    
    UINib *nib = [AQTInterestTableViewCell nib];
    [self.tableView registerNib:nib forCellReuseIdentifier:kInterestCellReuseIdentifier];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Interests" ofType:@"plist"];
    NSArray *interestDictionaries = [NSArray arrayWithContentsOfFile:path];
    self.interests = [AQTInterest interestsWithDictionaries:interestDictionaries];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.interests count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (AQTInterest *)interestAtIndexPath:(NSIndexPath *)indexPath
{
    return self.interests[indexPath.section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AQTInterestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kInterestCellReuseIdentifier forIndexPath:indexPath];
    AQTInterest *interest = [self interestAtIndexPath:indexPath];
    [cell configureWithInterest:interest];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AQTInterest *interest = [self interestAtIndexPath:indexPath];
    UIViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:interest.detailViewControllerStoryboardIdentifier];
    detailViewController.title = interest.title;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
