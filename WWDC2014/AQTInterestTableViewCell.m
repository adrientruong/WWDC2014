//
//  AQTInterestTableViewCell.m
//  WWDC2014
//
//  Created by Adrien Truong on 4/6/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import "AQTInterestTableViewCell.h"

@implementation AQTInterestTableViewCell

+ (CGFloat)rowHeight
{
    return 170.0;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                                                                          type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @-5;
    horizontalMotionEffect.maximumRelativeValue = @5;
    
    UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                                                                        type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @-5;
    verticalMotionEffect.maximumRelativeValue = @5;
    
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    [self.interestLabel addMotionEffect:group];
    [self.chevronImageView addMotionEffect:group];
}

@end
