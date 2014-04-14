//
//  AQTIntroChildView.m
//  WWDC2014
//
//  Created by Adrien Truong on 4/5/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import "AQTIntroChildView.h"

@implementation AQTIntroChildView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    for (UIView *subview in self.subviews) {
        subview.alpha = 0.0;
    }
    
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
}

- (void)startAnimationWithCompletion:(AQTIntroChildViewAnimationCompletionBlock)completionBlock;
{
    
}

@end
