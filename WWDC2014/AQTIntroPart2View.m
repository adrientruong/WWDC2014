//
//  AQTIntroPart2View.m
//  WWDC2014
//
//  Created by Adrien Truong on 4/5/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import "AQTIntroPart2View.h"

@implementation AQTIntroPart2View

- (void)startAnimationWithCompletion:(AQTIntroChildViewAnimationCompletionBlock)completionBlock;
{
    for (NSInteger i = 1; i < [self.quoteLabels count]; i++) {
        UILabel *quoteLabel = self.quoteLabels[i];
        
        CGRect frame = quoteLabel.frame;
        frame.origin.y = self.frame.size.height;
        
        quoteLabel.frame = frame;
    }
    
    CPAnimationStep * (^quoteAnimationStep)(UILabel *, UILabel *) = ^CPAnimationStep * (UILabel *leavingLabel, UILabel *incomingLabel) {
        
        return [CPAnimationStep after: 2.2 for:0.2 options:UIViewAnimationOptionCurveEaseIn animate:^{
            leavingLabel.alpha = 0.0;
            
            CGRect leavingLabelFrame = leavingLabel.frame;
            
            incomingLabel.alpha = 1.0;
            incomingLabel.frame = leavingLabelFrame;
            
            leavingLabelFrame.origin.y -= 100;
            leavingLabel.frame = leavingLabelFrame;
        }];
    };
    
    CPAnimationSequence *sequence =
    [CPAnimationSequence sequenceWithSteps:
     [CPAnimationStep for:0.8 animate:^{
        UILabel *label = self.labels[0];
        label.alpha = 1.0;
    }],
     [CPAnimationStep after: 2.2 for:0.8 animate:^{
        UILabel *label = self.labels[1];
        label.alpha = 1.0;
    }],
     [CPAnimationStep after: 2.2 for:0.8 animate:^{
        UILabel *label = self.labels[2];
        label.alpha = 1.0;
    }],
     [CPAnimationStep after: 2.2 for:0.8 animate:^{
        UILabel *label = self.quoteLabels[0];
        label.alpha = 1.0;
    }], quoteAnimationStep(self.quoteLabels[0], self.quoteLabels[1]),
     quoteAnimationStep(self.quoteLabels[1], self.quoteLabels[2]),
     [CPAnimationStep after:2.2 for:0.8 animate:^{
        NSMutableArray *labelsToHide = [self.labels mutableCopy];
        [labelsToHide addObject:[self.quoteLabels lastObject]];
        
        for (UILabel *label in labelsToHide) {
            label.alpha = 0.0;
        }
    }],
     [CPAnimationStep after: 0 for:0.0 animate:^{
        completionBlock();
    }], nil];
    
    [sequence runAnimated:YES];
}

@end
