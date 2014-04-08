//
//  AQTInterestTableViewCell+AQTInterest.m
//  WWDC2014
//
//  Created by Adrien Truong on 4/6/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import "AQTInterestTableViewCell+AQTInterest.h"
#import "AQTInterest.h" 

@implementation AQTInterestTableViewCell (AQTInterest)

- (void)configureWithInterest:(AQTInterest *)interest
{
    self.interestLabel.text = interest.title;
    self.backgroundImageView.image = interest.image;
}

@end
