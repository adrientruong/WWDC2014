//
//  AQTInterestTableViewCell+AQTInterest.h
//  WWDC2014
//
//  Created by Adrien Truong on 4/6/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import "AQTInterestTableViewCell.h"

@class AQTInterest;

@interface AQTInterestTableViewCell (AQTInterest)

- (void)configureWithInterest:(AQTInterest *)interest;

@end
