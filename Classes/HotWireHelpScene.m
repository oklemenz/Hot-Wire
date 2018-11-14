//
//  HotWireHelpLayer.m
//  HotWire
//
//  Created by Oliver Klemenz on 17.01.11.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#import "HotWireHelpScene.h"
#import "HotWireMenuScene.h"
#import "TextureManager.h"
#import "SoundManager.h"

@implementation HotWireHelpScene

+ (id)scene {
	CCScene *scene = [CCScene node];
	HotWireHelpScene *layer = [HotWireHelpScene node];
	[scene addChild:layer];
	return scene;
}

- (id)init {
	if ((self = [super init])) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
		CCSprite *help = [CCSprite spriteWithFile:@"help.png"];
        help.scaleX = winSize.width / help.contentSize.width;
        help.scaleY = winSize.height / help.contentSize.height;
		help.anchorPoint = CGPointZero;
		[self addChild:help];
		
		self.touchEnabled = YES;
	}
	return self;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipAngular transitionWithDuration:1.0f scene:[HotWireMenuScene scene]]];
	[[SoundManager instance] playSceneTransitionSound];
}

- (void)dealloc {
	[[TextureManager instance] unloadHelp];
	[super dealloc];
}

@end
