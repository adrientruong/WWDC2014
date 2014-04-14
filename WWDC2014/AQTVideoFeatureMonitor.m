//
//  AQTVideoFeatureMonitor.m
//  WWDC2014
//
//  Created by Adrien on 4/13/14.
//  Copyright (c) 2014 Adrien Truong. All rights reserved.
//

#import "AQTVideoFeatureMonitor.h"

@import AVFoundation;

@interface AQTVideoFeatureMonitor () <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) CIDetector *detector;

@property (nonatomic, copy) NSDate *lastDetectDate;

@end

@implementation AQTVideoFeatureMonitor

- (CIDetector *)detector
{
    if (_detector == nil) {
        NSDictionary *options = @{CIDetectorAccuracy: CIDetectorAccuracyHigh};
        self.detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options: options];
    }
    
    return _detector;
}

- (void)startMonitoring
{
    if (self.isMonitoring == YES) {
        return;
    }
    
    self.monitoring = YES;
    
    if (self.session == nil) {
        [self setupFrontCamera];
    }
    
    [self.session startRunning];
}

- (void)stopMonitoring
{
    if (self.isMonitoring == NO) {
        return;
    }
    
    self.monitoring = NO;
    [self.session stopRunning];
}

- (AVCaptureDevice *)frontCamera
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionFront) {
            return device;
        }
    }
    return nil;
}

- (void)setupFrontCamera
{
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    AVCaptureDevice *device = [self frontCamera];
    NSError *error = nil;
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device
                                                                        error:&error];
    if (input) {
        [session addInput:input];
    }
    else {
        NSLog(@"Error: %@", error);
    }
    
    AVCaptureVideoDataOutput *dataOutput = [AVCaptureVideoDataOutput new];
    NSDictionary *rgbOutputSettings = [NSDictionary dictionaryWithObject:
                                       [NSNumber numberWithInt:kCMPixelFormat_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    dataOutput.videoSettings = rgbOutputSettings;
    [dataOutput setAlwaysDiscardsLateVideoFrames:YES];

    dispatch_queue_t queue = dispatch_queue_create("VideoQueue", DISPATCH_QUEUE_SERIAL);
    [dataOutput setSampleBufferDelegate:self queue:queue];
    
    if ([session canAddOutput:dataOutput]) {
        [session addOutput:dataOutput];
    }
    
    self.session = session;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if ([[NSDate date] timeIntervalSinceDate:self.lastDetectDate] <= self.ignoreTimeIntervalAfterDetect) {
        return;
    }
    
    CVPixelBufferRef pixelBuffer = (CVPixelBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
    CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    CIImage *image = [CIImage imageWithCVPixelBuffer:pixelBuffer options:(__bridge NSDictionary *)attachments];
    if (attachments) {
        CFRelease(attachments);
    }
    
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    int exifOrientation;
    
    /* kCGImagePropertyOrientation values
     The intended display orientation of the image. If present, this key is a CFNumber value with the same value as defined
     by the TIFF and EXIF specifications -- see enumeration of integer constants.
     The value specified where the origin (0,0) of the image is located. If not present, a value of 1 is assumed.
     
     used when calling featuresInImage: options: The value for this key is an integer NSNumber from 1..8 as found in kCGImagePropertyOrientation.
     If present, the detection will be done based on that orientation but the coordinates in the returned features will still be based on those of the image. */
    
    enum {
        PHOTOS_EXIF_0ROW_TOP_0COL_LEFT          = 1, //   1  =  0th row is at the top, and 0th column is on the left (THE DEFAULT).
        PHOTOS_EXIF_0ROW_TOP_0COL_RIGHT         = 2, //   2  =  0th row is at the top, and 0th column is on the right.
        PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT      = 3, //   3  =  0th row is at the bottom, and 0th column is on the right.
        PHOTOS_EXIF_0ROW_BOTTOM_0COL_LEFT       = 4, //   4  =  0th row is at the bottom, and 0th column is on the left.
        PHOTOS_EXIF_0ROW_LEFT_0COL_TOP          = 5, //   5  =  0th row is on the left, and 0th column is the top.
        PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP         = 6, //   6  =  0th row is on the right, and 0th column is the top.
        PHOTOS_EXIF_0ROW_RIGHT_0COL_BOTTOM      = 7, //   7  =  0th row is on the right, and 0th column is the bottom.
        PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM       = 8  //   8  =  0th row is on the left, and 0th column is the bottom.
    };
    
    switch (curDeviceOrientation) {
        case UIDeviceOrientationPortraitUpsideDown:  // Device oriented vertically, home button on the top
            exifOrientation = PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM;
            break;
        case UIDeviceOrientationLandscapeLeft:       // Device oriented horizontally, home button on the right
            exifOrientation = PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT;
            break;
        case UIDeviceOrientationLandscapeRight:      // Device oriented horizontally, home button on the left
            exifOrientation = PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT;
            break;
        case UIDeviceOrientationPortrait:            // Device oriented vertically, home button on the bottom
        default:
            exifOrientation = PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP;
            break;
    }
    
    NSMutableDictionary *options = [self.detectorFeatureOptions mutableCopy];
    options[CIDetectorImageOrientation] = @(exifOrientation);
    NSArray *features = [self.detector featuresInImage:image options:options];
    
    for (CIFeature *feature in features) {
        NSArray *keys = [self.featureValues allKeys];
        NSDictionary *values = [feature dictionaryWithValuesForKeys:keys];
        
        if ([values isEqualToDictionary:self.featureValues]) {
            self.didDetectHandler();
            
            self.lastDetectDate = [NSDate date];
        }
    }
}

@end
