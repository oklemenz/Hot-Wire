//
//  CheckedFlag.m
//  HotWire
//
//  Created by Oliver Klemenz on 29.01.11.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#import "CheckedFlag.h"

@implementation CheckedFlag

- (id)initWithPosition:(CGPoint)position {
	if ((self = [super init])) {
		CCSpriteBatchNode *checkedFlagSheet = [CCSpriteBatchNode batchNodeWithFile:@"checked_flag.png"];
		[self addChild:checkedFlagSheet];
		CCSprite *checkedFlag = [CCSprite spriteWithTexture:checkedFlagSheet.texture rect:CGRectMake(0, 0, 66, 50)];
		checkedFlag.position = position;
		[checkedFlagSheet addChild:checkedFlag];
		NSMutableArray *frames = [NSMutableArray array];
		int frameCount = 0;
		for (int y = 0; y < 3; y++) {
			for (int x = 0; x < 4; x++) {
				CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:checkedFlagSheet.texture rect:CGRectMake(x*66, y*50, 66, 45)];
				[frames addObject:frame];
				frameCount++;
				if (frameCount == 12) {
					break;
				}
			}
		}		
		CCAnimation *wavingAnimation = [CCAnimation animationWithFrames:frames delay:0.05f];
		[[CCAnimationCache sharedAnimationCache] addAnimation:wavingAnimation name:@"waving"];
		CCAnimate *wavingAction = [CCAnimate actionWithAnimation:wavingAnimation];
		CCRepeatForever *repeat = [CCRepeatForever actionWithAction:wavingAction];
		[checkedFlag runAction:repeat];		
	}
	return self;
}

@end
