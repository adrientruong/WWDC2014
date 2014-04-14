//
//  AQTEducationTableViewCell.h
//  WWDC2014
//
//  Created by Adrien Truong on 4/11/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FXBlurView;

@interface AQTEducationTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet FXBlurView *blurView;

+ (CGFloat)rowHeight;

@end
