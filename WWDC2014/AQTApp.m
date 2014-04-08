//
//  AQTApp.m
//  WWDC2014
//
//  Created by Adrien Truong on 4/5/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import "AQTApp.h"
#import "UIImage+AQTMask.h"

@implementation AQTApp

+ (NSArray *)appsWithDictionaries:(NSArray *)dictionaries
{
    NSMutableArray *apps = [NSMutableArray array];
    
    for (NSDictionary *dictionary in dictionaries) {
        AQTApp *app = [[self alloc] initWithDictionary:dictionary];
        [apps addObject:app];
    }
    
    return [apps copy];
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    
    self.name = dictionary[@"name"];
    self.icon = [UIImage imageNamed:dictionary[@"iconName"]];
    self.iTunesItemIdentifier = dictionary[@"iTunesItemIdentifier"];
    
    NSString *infoFileName = dictionary[@"infoTextName"];
    NSURL *infoFileURL = [[NSBundle mainBundle] URLForResource:infoFileName withExtension:@"rtf"];
    self.infoText = [[NSAttributedString alloc] initWithFileURL:infoFileURL options:nil documentAttributes:nil error:nil];
    
    return self;
}

- (UIImage *)squircleIcon
{
    if (_squircleIcon == nil) {
        UIImage *mask = [UIImage imageNamed:@"squircle-mask"];
        self.squircleIcon = [self.icon imageWithMask:mask];
    }
    
    return _squircleIcon;
}

@end
