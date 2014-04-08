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
    self.image = [UIImage imageNamed:dictionary[@"imageName"]];
    self.detailViewControllerStoryboardIdentifier = dictionary[@"detailViewControllerStoryboardIdentifier"];
    
    NSString *storyFileName = dictionary[@"storyFileName"];
    NSURL *storyFileURL = [[NSBundle mainBundle] URLForResource:storyFileName withExtension:@"rtf"];
    self.storyText = [[NSAttributedString alloc] initWithFileURL:storyFileURL options:nil documentAttributes:nil error:nil];
    
    return self;
}

@end
