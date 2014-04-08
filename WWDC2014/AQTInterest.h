//
//  AQTInterest.h
//  WWDC2014
//
//  Created by Adrien Truong on 4/6/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AQTInterest : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *detailViewControllerStoryboardIdentifier;
@property (nonatomic, copy) NSAttributedString *storyText;

+ (NSArray *)interestsWithDictionaries:(NSArray *)dictionaries;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
