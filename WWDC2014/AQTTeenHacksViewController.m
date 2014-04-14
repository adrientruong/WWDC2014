//
//  AQTTeenHacksViewController.m
//  WWDC2014
//
//  Created by Adrien on 4/12/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import "AQTTeenHacksViewController.h"
#import "AQTWebViewController.h"

@interface AQTTeenHacksViewController ()

- (IBAction)visitWebsiteButtonWasTapped;

@end

@implementation AQTTeenHacksViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (IBAction)visitWebsiteButtonWasTapped
{
    AQTWebViewController *webViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([AQTWebViewController class])];
    webViewController.URLString = @"http://teenhacks.org";
    
    webViewController.title = NSLocalizedString(@"Website", @"");
    
    [self.navigationController pushViewController:webViewController animated:YES];
}

@end
