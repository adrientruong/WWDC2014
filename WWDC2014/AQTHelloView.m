//
//  AQTHelloView.m
//  WWDC2014
//
//  Created by Adrien Truong on 4/11/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import "AQTHelloView.h"

@interface AQTHelloView ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *helloLabelTopConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageViewTopSpaceConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *myNameLabelTopConstraint;

@end

@implementation AQTHelloView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.imageView.layer.cornerRadius = self.imageView.frame.size.height / 2;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imageView.layer.borderWidth = 3.0f;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 480) {
        self.helloLabelTopConstraint.constant = 40;
        self.imageViewTopSpaceConstraint.constant = 20;
        self.myNameLabelTopConstraint.constant = 30;
    }
}

@end
