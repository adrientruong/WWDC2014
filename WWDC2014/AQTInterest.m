//
//  AQTInterest.m
//  WWDC2014
//
//  Created by Adrien Truong on 4/6/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import "AQTInterest.h"

@implementation AQTInterest

+ (NSArray *)interestsWithDictionaries:(NSArray *)dictionaries
{
    NSMutableArray *interests = [NSMutableArray array];
    
    for (NSDictionary *dictionary in dictionaries) {
        AQTInterest *interest = [[self alloc] initWithDictionary:dictionary];
        [interests addObject:interest];
    }
    
    return [interests copy];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    
    self.title = dictionary[@"title"];
    self.subtitle = dictionary[@"subtitle"];
    self.image = [UIImage imageNamed:dictionary[@"imageName"]];
    
    NSString *bodyFileName = dictionary[@"bodyFileName"];
    NSURL *bodyFileURL = [[NSBundle mainBundle] URLForResource:bodyFileName withExtension:@"rtf"];
    self.bodyText = [[NSAttributedString alloc] initWithFileURL:bodyFileURL options:nil documentAttributes:nil error:nil];
    
    return self;
}

@end
