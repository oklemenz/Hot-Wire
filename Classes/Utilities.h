//
//  Utilities.h
//  HotWire
//
//  Created by Oliver Klemenz on 30.11.10.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Utilities : NSObject {
}

+ (double)getTimestamp;

+ (int)getRandom:(int)max;
+ (int)getRandomIncl:(int)max;

+ (float)getFloatRandom;
+ (float)getFloatHalfRandom;
+ (float)getFloatRandom:(float)max;
+ (float)getFloatRandomWithMin:(float)min andMax:(float)max;

+ (BOOL)getBoolRandom;
+ (int)getZeroOneRandom;

+ (int)getRandomWithMin:(int)min andMax:(int)max;
+ (int)getRandomWithMin:(int)min inclMax:(int)max;

+ (NSString *)getTimeString:(double)time;
+ (double)getRoundedTime:(double)time;

@end
