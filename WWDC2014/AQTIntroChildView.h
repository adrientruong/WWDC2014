//
//  AQTIntroChildView.h
//  WWDC2014
//
//  Created by Adrien Truong on 4/5/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CPAnimationSequence.h>
#import <CPAnimationProgram.h>

typedef void (^AQTIntroChildViewAnimationCompletionBlock)();

@interface AQTIntroChildView : UIView

@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *labels;

- (void)startAnimationWithCompletion:(AQTIntroChildViewAnimationCompletionBlock)completionBlock;

@end
