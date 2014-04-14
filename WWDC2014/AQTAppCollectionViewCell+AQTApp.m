//
//  AQTAppCollectionViewCell+AQTApp.m
//  WWDC2014
//
//  Created by Adrien Truong on 4/5/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import "AQTAppCollectionViewCell+AQTApp.h"
#import "AQTApp.h"

@implementation AQTAppCollectionViewCell (AQTApp)

- (void)configureWithApp:(AQTApp *)app
{
    self.iconView.image = [app squircleIcon];
}

@end
