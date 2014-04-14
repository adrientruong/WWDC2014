//
//  AQTInDevelopmentViewController.m
//  WWDC2014
//
//  Created by Adrien Truong on 4/11/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import "AQTInDevelopmentViewController.h"
#import "AQTTeenHacksViewController.h"
#import "AQTDottedTableViewCell.h"

#define kCellReuseIdentifier @"Id"

@interface AQTInDevelopmentViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation AQTInDevelopmentViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.navigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"hammer-selected"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[AQTDottedTableViewCell class] forCellReuseIdentifier:kCellReuseIdentifier];
    
//    UIImage *image = [UIImage imageNamed:@"hello-background"];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//    imageView.translatesAutoresizingMaskIntoConstraints = NO;
//    imageView.contentMode = UIViewContentModeScaleAspectFill;
//    [self.view insertSubview:imageView atIndex:0];
//    NSDictionary *views = NSDictionaryOfVariableBindings(imageView);
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics:nil views:views]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|" options:0 metrics:nil views:views]];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithRed:56.0f/255.0f green:129.0f/255.0f blue:254.0f/255.0f alpha:1.0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"TeenHacks";
    }
    else {
        cell.textLabel.text = @"Ward";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        AQTTeenHacksViewController *teenHacksViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([AQTTeenHacksViewController class])];
        [self.navigationController pushViewController:teenHacksViewController animated:YES];
    }
    else {
        UIViewController *wardViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AQTWardViewController"];
        [self.navigationController pushViewController:wardViewController animated:YES];
    }
}

@end
