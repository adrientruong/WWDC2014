//
//  AQTAppsHintView.m
//  WWDC2014
//
//  Created by Adrien on 4/13/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import "AQTAppsHintView.h"
#import "FXBlurView.h"

@implementation AQTAppsHintView

- (void)awakeFromNib
{
    [super awakeFromNib];
    

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:15.0];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    self.layer.mask = shapeLayer;
    
    self.blurView.tintColor = nil;
    self.blurView.blurRadius = 15;
    self.blurView.dynamic = NO;
}

@end
