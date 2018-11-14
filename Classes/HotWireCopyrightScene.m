//
//  HotWireCopyrightScene.m
//  HotWire
//
//  Created by Oliver Klemenz on 25.01.11.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#import "HotWireCopyrightScene.h"
#import "HotWireMenuScene.h"
#import "TextureManager.h"
#import "SoundManager.h"

@implementation HotWireCopyrightScene

@synthesize copyright, copyright2;

+ (id)scene {
	CCScene *scene = [CCScene node];
	HotWireCopyrightScene *layer = [HotWireCopyrightScene node];
	[scene addChild:layer];
	return scene;
}

- (id)init {
	if ((self = [super init])) { //WithColor:ccc4(255, 255, 255, 0)])) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
		copyright = [CCSprite spriteWithFile:@"copyright.png"];
		copyright.color = ccc3(255, 255, 255);
		copyright.anchorPoint = CGPointZero;
        copyright.scaleX = winSize.width / copyright.contentSize.width;
        copyright.scaleY = winSize.height / copyright.contentSize.height;
		[self addChild:copyright];

		copyright2 = [CCSprite spriteWithFile:@"copyright.png"];
		copyright2.anchorPoint = CGPointZero;
		copyright2.visible = NO;
        copyright2.scaleX = winSize.width / copyright.contentSize.width;
        copyright2.scaleY = winSize.height / copyright.contentSize.height;
		[self addChild:copyright2];	
		
		[self setOpacity:0];
		
		id fadeIn = [CCFadeIn actionWithDuration:1.5f];
		id splash = [CCCallFuncN actionWithTarget:self selector:@selector(splash:)];
		id waves = [CCWaves3D actionWithWaves:5 amplitude:35 grid:ccg(15,10) duration:3.0];
		id show = [CCCallFuncN actionWithTarget:self selector:@selector(show:)];
		id wait = [CCDelayTime actionWithDuration:1.0f];
		id done = [CCCallFuncN actionWithTarget:self selector:@selector(menu:)];
		CCSequence *seq = [CCSequence actions:[CCSpawn actions: splash, waves, nil], show, wait, done, nil];
		[copyright runAction:seq];
		[self runAction:fadeIn];
		
		self.touchEnabled = YES;
	}
	return self;
}

- (void)splash:(id)sender {
	[[SoundManager instance] playSplashSound];
}

- (void)show:(id)sender {
	copyright2.visible = YES;
}

- (void)menu:(id)sender {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0f scene:[HotWireMenuScene scene]]];
	[[SoundManager instance] playSceneTransitionSound];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[[CCActionManager sharedManager] removeAllActionsFromTarget:copyright];
	[self menu:self];
}

- (void)setOpacity:(GLubyte)newOpacity {
	super.opacity = newOpacity;
	id<CCRGBAProtocol> item;
	CCARRAY_FOREACH(_children, item)
	[item setOpacity:newOpacity];
}

-(void)setColor:(ccColor3B)color {
	super.color = color;
	id<CCRGBAProtocol> item;
	CCARRAY_FOREACH(_children, item)
	[item setColor:color];
}

- (void)dealloc {
	[[TextureManager instance] unloadCopyright];
	[super dealloc];
}

@end
