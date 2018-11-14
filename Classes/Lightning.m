//
//  Lightning.m
//  HotWire
//
//  Created by Oliver Klemenz on 29.01.11.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#import "Lightning.h"
#import "Utilities.h"
#import "SoundManager.h"
#include <OpenGLES/ES1/gl.h>

@implementation Lightning

@synthesize strikePoint1, strikePoint2, color, opacity, displacement, minDisplacement, seed;
@synthesize displayedColor, cascadeColorEnabled, displayedOpacity, cascadeOpacityEnabled;

-(id)initLightning {
	if ((self = [super init])) {
		color = ccWHITE;
		opacity = 255;
		seed = rand();
		displacement = 100;
		minDisplacement = 10;
	}
	return self;
}

- (void)draw {
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisable(GL_TEXTURE_2D);
	
	glColor4ub(color.r, color.g, color.b, opacity);

	glLineWidth(1.10);
	glEnable(GL_LINE_SMOOTH);
	
	if (opacity != 255)
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

	[self drawLightning:strikePoint1 to:strikePoint2 displace:displacement seed:seed];
	
	if (opacity != 255)
		glBlendFunc(CC_BLEND_SRC, CC_BLEND_DST);
	
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);
}

- (CGPoint)drawLightning:(CGPoint)pt1 to:(CGPoint)pt2 displace:(int)displace seed:(unsigned long)randSeed {
	CGPoint mid = ccpMult(ccpAdd(pt1,pt2), 0.5f);
	
	if (displace < minDisplacement) {
		ccDrawLine(pt1, pt2);
		glBlendFunc(GL_SRC_ALPHA, GL_ONE);	
		CGFloat r1 = [Utilities getFloatHalfRandom] * 5;
		CGFloat r2 = [Utilities getFloatHalfRandom] * 5;
		CGFloat r3 = [Utilities getFloatHalfRandom] * 5;
		CGFloat r4 = [Utilities getFloatHalfRandom] * 5;
		ccDrawLine(ccp(pt1.x + r1, pt1.y + r2), ccp(pt2.x + r3, pt2.y + r4));
	}
	else {
		int r = rand(); //getNextRandom(&randSeed);
		mid.x += (((r % 101)/100.0)-.5)*displace;
		r = rand(); //getNextRandom(&randSeed);
		mid.y += (((r % 101)/100.0)-.5)*displace;
		
		[self drawLightning:pt1 to:mid displace:displace/2 seed:randSeed];
		[self drawLightning:pt2 to:mid displace:displace/2 seed:randSeed];
	}
	
	return mid;
}

- (void)setColor:(ccColor3B)newColor {
    color = newColor;
    id<CCRGBAProtocol> item;
    CCARRAY_FOREACH(_children, item)
    [item setColor:color];
}

- (void)setOpacity:(GLubyte)newOpacity {
    opacity = newOpacity;
    id<CCRGBAProtocol> item;
    CCARRAY_FOREACH(_children, item)
    [item setOpacity:newOpacity];
}

- (void)updateDisplayedColor:(ccColor3B)newColor {
    color = newColor;
    id<CCRGBAProtocol> item;
    CCARRAY_FOREACH(_children, item)
    [item updateDisplayedColor:color];
}

- (void)updateDisplayedOpacity:(GLubyte)newOpacity {
    opacity = newOpacity;
    id<CCRGBAProtocol> item;
    CCARRAY_FOREACH(_children, item)
    [item updateDisplayedOpacity:opacity];
}

@end

int getNextRandom(unsigned long *seed) {
	(*seed) = (*seed) * 1103515245 + 12345;
	return ((unsigned)((*seed)/65536)%32768);
}

@implementation Tesla

@synthesize status, time, hideDuration, showDuration;
@synthesize paused;

- (id)initTesla {
	if ((self = [super init])) {
		lightnings = [[NSMutableSet alloc] init];
		for (int i = 0; i < 4; i++) {
			Lightning *lightning = [[Lightning alloc] initLightning];
			if (i % 2 == 0) {	
				lightning.color = (ccColor3B) { 250.0f, 250.0f, 250.0f };
			} else {
				lightning.color = (ccColor3B) { 120.0f, 170.0f, 255.0f }; 				
			}
			lightning.displacement = 40; //100;
			lightning.minDisplacement = 10;
			lightning.opacity = 100;	
			[lightnings addObject:lightning];
			[lightning release];
		}
		status = kElectricityStatusHide;
	}
	return self;
}

- (void)showAtPos:(CGPoint)pos1 andPos:(CGPoint)pos2 andHideDuration:(CGFloat)hideDur andShowDuration:(CGFloat)showDur {
	if (!paused) {
		position1 = pos1;
		position2 = pos2;
		hideDuration = hideDur;
		showDuration = showDur;
		for (Lightning *lightning in lightnings) {
			lightning.strikePoint1 = position1;
			lightning.strikePoint2 = position2;
		}	
		time = 0;
		counter = 0;
		[self show];
	}
}

- (void)update:(ccTime)dt {
	time += dt;
	if (status == kElectricityStatusHideWait) {
		if (time >= hideDuration) {
			status = kElectricityStatusHide;
		}
	} else if (status == kElectricityStatusShow) {
		if (counter == 0) {
			for (Lightning *lightning in lightnings) {
				CGFloat r1 = [Utilities getFloatHalfRandom] * 10;
				CGFloat r2 = [Utilities getFloatHalfRandom] * 10;
				CGFloat r3 = [Utilities getFloatHalfRandom] * 10;
				CGFloat r4 = [Utilities getFloatHalfRandom] * 10;
				lightning.seed = rand();
				lightning.strikePoint1 = ccp(position1.x + r1, position1.y + r2);
				lightning.strikePoint2 = ccp(position2.x + r3, position2.y + r4); 
			}
			counter = 4;
		} else {
			counter--;
		}		
		if (time >= showDuration) {
			[self hide];
		}
	}
}

- (void)hide {
	time = 0;
	status = kElectricityStatusHideWait;
}

- (void)show {
	if (!paused) {
		time = 0;
		status = kElectricityStatusShow;
		[[SoundManager instance] playElectricitySound];
	}
}

- (void)draw {
	if (!paused && status == kElectricityStatusShow) {
		for (Lightning *lightning in lightnings) {
			[lightning draw];
		}
	}
}

- (void)dealloc {
	[lightnings release];
	[super dealloc];
}

@end
