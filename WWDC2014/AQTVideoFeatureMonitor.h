//
//  AQTVideoFeatureMonitor.h
//  WWDC2014
//
//  Created by Adrien on 4/13/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AQTVideoFeatureMonitor : NSObject

@property (nonatomic, copy) NSDictionary *detectorFeatureOptions;
@property (nonatomic, copy) NSDictionary *featureValues;
@property (nonatomic, copy) void (^didDetectHandler)();
@property (nonatomic, assign) NSTimeInterval ignoreTimeIntervalAfterDetect;

@property (nonatomic, assign, getter = isMonitoring) BOOL monitoring;

- (void)startMonitoring;
- (void)stopMonitoring;

@end
