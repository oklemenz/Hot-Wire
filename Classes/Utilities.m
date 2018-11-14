//
//  Utilities.m
//  HotWire
//
//  Created by Oliver Klemenz on 30.11.10.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#import "Utilities.h"

#define ARC4RANDOM_MAX 0x100000000;

@implementation Utilities

+ (double)getTimestamp {
	return [[NSDate date] timeIntervalSince1970];
}

+ (int)getRandom:(int)max {
	return (arc4random() % max) + 1;
}

+ (int)getRandomIncl:(int)max {
	return arc4random() % (max+1);
}

+ (float)getFloatRandom {
	return (float)arc4random() / (float)ARC4RANDOM_MAX;
}

+ (float)getFloatHalfRandom {
	return [self getFloatRandom] - 0.5;
}

+ (float)getFloatRandom:(float)max {
	return [self getFloatRandom] * max;	
}

+ (float)getFloatRandomWithMin:(float)min andMax:(float)max {
	return min + [self getFloatRandom] * (max-min);
}

+ (BOOL)getBoolRandom {
	return [self getFloatRandomWithMin:0 andMax:1] >= 0.5;
}

+ (int)getZeroOneRandom {
	return [self getFloatRandomWithMin:0 andMax:1] >= 0.5 ? 1 : 0;
}

+ (int)getRandomWithMin:(int)min andMax:(int)max {
	if (min == max) {
		return min;
	}
	return min + arc4random() % (max-min);
}

+ (int)getRandomWithMin:(int)min inclMax:(int)max {
	if (min == max) {
		return min;
	}
	return min + arc4random() % (max+1-min);
}

+ (NSString *)getTimeString:(double)time {
	int hour = time / 3600;
	int minute = (time - hour * 3600) / 60;
	int second = time - (hour * 3600 + minute * 60);
	int milli  = round((time - (hour * 3600 + minute * 60 + second)) * 100);
	return [NSString stringWithFormat:@"%02i:%02i:%02i.%02i", hour, minute, second, milli];
}

+ (double)getRoundedTime:(double)time {
	int hour = time / 3600;
	int minute = (time - hour * 3600) / 60;
	int second = time - (hour * 3600 + minute * 60);
	int milli  = round((time - (hour * 3600 + minute * 60 + second)) * 100);
	return hour * 3600 + minute * 60 + second + milli / 100.0;
}

@end
