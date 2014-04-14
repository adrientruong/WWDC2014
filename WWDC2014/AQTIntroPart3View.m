//
//  AQTIntroPart3View.m
//  WWDC2014
//
//  Created by Adrien Truong on 4/5/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import "AQTIntroPart3View.h"

@implementation AQTIntroPart3View

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UILabel *lastLabel = [self.labels lastObject];
    CGFloat centerY = self.frame.size.height - ((self.frame.size.height - (lastLabel.frame.origin.y + lastLabel.frame.size.height)) / 2);
    
    CGRect frame = self.enterButton.frame;
    frame.origin.y = centerY - (frame.size.height / 2);
    self.enterButton.frame = frame;
}

- (void)startAnimationWithCompletion:(AQTIntroChildViewAnimationCompletionBlock)completionBlock;
{
    CPAnimationSequence *sequence =
    [CPAnimationSequence sequenceWithSteps:
     [CPAnimationStep for:0.8 animate:^{
        UILabel *label = self.labels[0];
        label.alpha = 1.0;
    }],
     [CPAnimationStep after:2.0 for:0.8 animate:^{
        UILabel *label = self.labels[1];
        label.alpha = 1.0;
    }],
     [CPAnimationStep after:2.0 for:0.8 animate:^{
        UILabel *label = self.labels[2];
        label.alpha = 1.0;
    }],
     [CPAnimationStep after:1.0 for:0.8 animate:^{
        self.enterButton.alpha = 1.0;
    }],
     [CPAnimationStep for:0.0 animate:^{
        completionBlock();
    }], nil];
    
    [sequence runAnimated:YES];
}

@end
