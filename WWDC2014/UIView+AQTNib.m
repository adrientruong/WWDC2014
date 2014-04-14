//
//  UIView+Nib.m
//  DoTA2
//
//  Created by Adrien Truong on 7/26/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "UIView+AQTNib.h"

@implementation UIView (AQTNib)

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

@end
