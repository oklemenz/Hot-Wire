//
//  Lightning.h
//  HotWire
//
//  Created by Oliver Klemenz on 29.01.11.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#define kElectricityStatusHide	   0
#define kElectricityStatusHideWait 1
#define kElectricityStatusShow	   2
#define kElectricityStatusShowWait 3

#import "cocos2d.h"

@interface Lightning : CCNode<CCRGBAProtocol> {
	CGPoint strikePoint1;
	CGPoint strikePoint2;
	
	ccColor3B color;
	GLubyte	opacity;
	BOOL split;
	
	int displacement;
	int minDisplacement;
	
	unsigned long seed;
}

@property (readwrite, assign) CGPoint strikePoint1;
@property (readwrite, assign) CGPoint strikePoint2;
@property (readwrite, assign, nonatomic) ccColor3B color;
@property (readwrite, assign, nonatomic) GLubyte opacity;
@property (readwrite, assign) int displacement;
@property (readwrite, assign) int minDisplacement;
@property (readwrite, assign) unsigned long seed;

- (id)initLightning;
- (CGPoint)drawLightning:(CGPoint)pt1 to:(CGPoint)pt2 displace:(int)displace seed:(unsigned long)randSeed;
@end

int getNextRandom(unsigned long *seed);

@interface Tesla : CCNode {
	CGPoint position1;
	CGPoint position2;
	int counter;
	int status;
	CGFloat time;
	CGFloat hideDuration;
	CGFloat showDuration;
	
	NSMutableSet *lightnings;
	int lightningCount;
	
	BOOL paused;
}

@property int status;
@property CGFloat time;
@property CGFloat hideDuration;
@property CGFloat showDuration;

@property BOOL paused;

- (id)initTesla;
- (void)showAtPos:(CGPoint)pos1 andPos:(CGPoint)pos2 andHideDuration:(CGFloat)hideDur andShowDuration:(CGFloat)showDur;
- (void)update:(ccTime)dt;
- (void)hide;
- (void)show;

@end
