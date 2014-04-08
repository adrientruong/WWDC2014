//
//  AQTSlideToUnlockView.h
//  WWDC2014
//
//  Created by Adrien Truong on 4/4/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AQTSlideToUnlockView : UIControl

@property (nonatomic, strong) IBOutlet UIView *backgroundView;
@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (nonatomic, weak, readonly) UILabel *unlockTextLabel;

@property (nonatomic, assign, getter = isUnlocked) BOOL unlocked;

@end
