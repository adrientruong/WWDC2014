//
//  AQTEducationCellInfo.m
//  WWDC2014
//
//  Created by Adrien Truong on 4/11/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import "AQTEducationCellInfo.h"

@implementation AQTEducationCellInfo

+ (NSArray *)infosWithDictionaries:(NSArray *)array
{
    NSMutableArray *infos = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        AQTEducationCellInfo *info = [[self alloc] initWithDictionary:dictionary];
        [infos addObject:info];
    }
    
    return infos;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    
    self.backgroundImage = [UIImage imageNamed:dictionary[@"backgroundImageName"]];
    self.text = dictionary[@"text"];
    
    return self;
}

@end
