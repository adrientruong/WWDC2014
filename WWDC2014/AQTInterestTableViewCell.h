//
//  AQTInterestTableViewCell.h
//  WWDC2014
//
//  Created by Adrien Truong on 4/6/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AQTInterestTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, weak) IBOutlet UILabel *interestLabel;
@property (nonatomic, weak) IBOutlet UIImageView *chevronImageView;

+ (CGFloat)rowHeight;

@end
