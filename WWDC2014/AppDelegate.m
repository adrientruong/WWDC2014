//
//  AppDelegate.m
//  WWDC2014
//
//  Created by Adrien Truong on 4/4/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
    
    UIStoryboard *introStoryboard = [UIStoryboard storyboardWithName:@"Intro" bundle:nil];
    UIViewController *initialViewController = [introStoryboard instantiateInitialViewController];
    
    UIImage *defaultImage;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568.0) {
        defaultImage = [UIImage imageNamed:@"LaunchImage-700-568h@2x"];
    }
    else {
        defaultImage = [UIImage imageNamed:@"LaunchImage-700@2x"];
    }
    
    defaultImage = [UIImage imageWithCGImage:defaultImage.CGImage scale:2.0 orientation:defaultImage.imageOrientation];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:defaultImage];
    
    self.window.rootViewController.view.hidden = YES;
    [self.window addSubview:imageView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.window.rootViewController presentViewController:initialViewController animated:NO completion:^{
            [imageView removeFromSuperview];
            self.window.rootViewController.view.hidden = NO;
        }];
    });
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window.tintColor = [UIColor colorWithRed:84.0f/255.0f green:154.0f/255.0f blue:202.0f/255.0f alpha:1.0];
    
    return YES;
}

@end
