//
//  AQTEducationTableViewCell+AQTEducationCellInfo.m
//  WWDC2014
//
//  Created by Adrien Truong on 4/11/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import "AQTEducationTableViewCell+AQTEducationCellInfo.h"
#import "AQTEducationCellInfo.h"
#import "FXBlurView.h"

@implementation AQTEducationTableViewCell (AQTEducationCellInfo)

- (void)configureWithInfo:(AQTEducationCellInfo *)info
{
    self.label.text = info.text;
    self.backgroundImageView.image = info.backgroundImage;
}

@end
