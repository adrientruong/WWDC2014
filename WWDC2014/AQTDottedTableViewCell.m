//
//  AQTDottedTableViewCell.m
//  WWDC2014
//
//  Created by Adrien Truong on 4/14/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import "AQTDottedTableViewCell.h"

@interface AQTDottedTableViewCell ()

@property (nonatomic, weak) CAShapeLayer *borderLayer;

@end

@implementation AQTDottedTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CAShapeLayer *borderLayer = [CAShapeLayer layer];
        borderLayer.strokeColor = [UIColor whiteColor].CGColor;
        borderLayer.fillColor = nil;
        borderLayer.lineDashPattern = @[@4, @2];
        
        [self.layer addSublayer:borderLayer];
        
        self.borderLayer = borderLayer;
        
        
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.highlightedTextColor = [UIColor blackColor];
        self.textLabel.font = [UIFont fontWithName:@"Chalkduster" size:20];
        
        self.backgroundColor = [UIColor clearColor];
        
        self.selectedBackgroundView = [[UIView alloc] init];
        self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(0, 10, 0, 10)) cornerRadius:10].CGPath;
    self.borderLayer.frame = self.bounds;
    
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.path = self.borderLayer.path;
    mask.frame = self.borderLayer.frame;
    self.selectedBackgroundView.layer.mask = mask;
}

@end
