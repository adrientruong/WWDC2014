//
//  AQTIntroPart1View.m
//  WWDC2014
//
//  Created by Adrien Truong on 4/5/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import "AQTIntroPart1View.h"

@implementation AQTIntroPart1View

- (void)startAnimationWithCompletion:(AQTIntroChildViewAnimationCompletionBlock)completionBlock;
{
    CPAnimationSequence *sequence =
    [CPAnimationSequence sequenceWithSteps:
    [CPAnimationStep for:0.8 animate:^{
        self.topLabel.alpha = 1.0;
    }],
     [CPAnimationStep after:0.5 for:0.8 animate:^{
        UILabel *label = self.labels[0];
        label.alpha = 1.0;
    }],
     [CPAnimationStep after:0.6 for:0.8 animate:^{
        UILabel *label = self.labels[1];
        label.alpha = 1.0;
    }],
     [CPAnimationStep after:0.6 for:0.8 animate:^{
        UILabel *label = self.labels[2];
        label.alpha = 1.0;
    }],
     [CPAnimationStep after:1.5 for:0.8 animate:^{
        NSMutableArray *labelsToHide = [self.labels mutableCopy];
        [labelsToHide addObject:self.topLabel];
        
        for (UILabel *label in labelsToHide) {
            label.alpha = 0.0;
        }
    }],
     [CPAnimationStep for:0.0 animate:^{
        completionBlock();
    }], nil];

    [sequence runAnimated:YES];
}



@end
