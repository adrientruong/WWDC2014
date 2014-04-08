//
//  AQTAppCollectionViewCell+AQTApp.h
//  WWDC2014
//
//  Created by Adrien Truong on 4/5/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import "AQTAppCollectionViewCell.h"

@class AQTApp;

@interface AQTAppCollectionViewCell (AQTApp)

- (void)configureWithApp:(AQTApp *)app;

@end
