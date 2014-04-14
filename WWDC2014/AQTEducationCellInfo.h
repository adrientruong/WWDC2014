//
//  AQTEducationCellInfo.h
//  WWDC2014
//
//  Created by Adrien Truong on 4/11/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AQTEducationCellInfo : NSObject

@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, copy) NSString *text;

+ (NSArray *)infosWithDictionaries:(NSArray *)array;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
