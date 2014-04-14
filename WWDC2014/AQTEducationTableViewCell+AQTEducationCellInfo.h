//
//  AQTEducationTableViewCell+AQTEducationCellInfo.h
//  WWDC2014
//
//  Created by Adrien Truong on 4/11/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import "AQTEducationTableViewCell.h"

@class AQTEducationCellInfo;

@interface AQTEducationTableViewCell (AQTEducationCellInfo)

- (void)configureWithInfo:(AQTEducationCellInfo *)info;

@end
