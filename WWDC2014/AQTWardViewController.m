//
//  AQTWardViewController.m
//  WWDC2014
//
//  Created by Adrien on 4/12/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import "AQTWardViewController.h"
#import "AQTScreenshotsViewController.h"

@interface AQTWardViewController ()

@end

@implementation AQTWardViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSMutableArray *screenshots = [NSMutableArray array];
    for (NSInteger i = 0; i < 3; i++) {
        NSString *imageName = [NSString stringWithFormat:@"ward%i", i + 1];
        UIImage *screenshot = [UIImage imageNamed:imageName];
        [screenshots addObject:screenshot];
    }
    
    AQTScreenshotsViewController *screenshotsViewController = segue.destinationViewController;
    screenshotsViewController.screenshots = screenshots;
}

@end
