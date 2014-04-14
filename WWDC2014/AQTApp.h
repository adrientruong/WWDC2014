//
//  AQTApp.h
//  WWDC2014
//
//  Created by Adrien Truong on 4/5/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AQTApp : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) UIImage *squircleIcon;
@property (nonatomic, copy) NSAttributedString *infoText;
@property (nonatomic, copy) NSString *iTunesItemIdentifier;

+ (NSArray *)appsWithDictionaries:(NSArray *)dictionaries;
- (id)initWithDictionary:(NSDictionary *)dictionary;

- (UIImage *)squircleIcon;

@end
