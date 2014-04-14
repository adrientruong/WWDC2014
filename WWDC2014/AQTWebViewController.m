//
//  AQTWebViewController.m
//  WWDC2014
//
//  Created by Adrien on 4/12/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import "AQTWebViewController.h"

@interface AQTWebViewController () <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end

@implementation AQTWebViewController

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 0, 0);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadURLString:self.URLString];
}

- (void)loadURLString:(NSString *)URLString
{
    NSURL *URL = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    [self.webView loadRequest:request];
}

- (void)setURLString:(NSString *)URLString
{
    _URLString = [URLString copy];
    
    if (self.isViewLoaded) {
        [self loadURLString:URLString];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
