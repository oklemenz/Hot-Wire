//
//  HotWireOptions.m
//  HotWire
//
//  Created by Oliver Klemenz on 20.01.11.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#import "HotWireOptions.h"
#import "HotWireMenuScene.h"
#import "UserData.h"
#import "SoundManager.h"

@implementation HotWireOptions

@synthesize menuScene, musicMenuItem, soundMenuItem, vibrationMenuItem, gridMenuItem;
@synthesize opacity=opacity_, color=color_;
@synthesize displayedColor, cascadeColorEnabled, displayedOpacity, cascadeOpacityEnabled;

- (id)init {
	if ((self = [super init])) {
		self.anchorPoint = ccp(0.5, 0.5);

		CGSize winSize = [[CCDirector sharedDirector] winSize];
		CGPoint center = ccp(winSize.width/2, winSize.height/2);
		CCSprite *frame = [CCSprite spriteWithFile:@"menu_frame_large.png"];
		frame.position = center;
		[self addChild:frame];
		
		CCSprite *optionsTile = [CCSprite spriteWithFile:@"options_title.png"];
		optionsTile.position = ccp(winSize.width/2, winSize.height/2 + [frame boundingBox].size.height / 2 - 9);
		[self addChild:optionsTile];
		
		CCMenu *menu = [CCMenu menuWithItems:nil];
		menu.anchorPoint = ccp(0, 1);
		menu.position = ccp(winSize.width/2, winSize.height / 2);

		CCMenuItemImage *musicOnMenuItem = [CCMenuItemImage itemFromNormalImage:@"options_music_on.png" selectedImage:@"options_music_on_p.png"];
		CCMenuItemImage *musicOffMenuItem = [CCMenuItemImage itemFromNormalImage:@"options_music_off.png" selectedImage:@"options_music_off_p.png"];
		musicMenuItem = [CCMenuItemToggle itemWithTarget:self selector:@selector(music:) items:musicOnMenuItem, musicOffMenuItem, nil];
		musicMenuItem.selectedIndex = [[UserData instance] getMusic] ? 0 : 1;
		[menu addChild:musicMenuItem];

		CCMenuItemImage *soundOnMenuItem = [CCMenuItemImage itemFromNormalImage:@"options_sound_on.png" selectedImage:@"options_sound_on_p.png"];
		CCMenuItemImage *soundOffMenuItem = [CCMenuItemImage itemFromNormalImage:@"options_sound_off.png" selectedImage:@"options_sound_off_p.png"];
		soundMenuItem = [CCMenuItemToggle itemWithTarget:self selector:@selector(sound:) items:soundOnMenuItem, soundOffMenuItem, nil];
		soundMenuItem.selectedIndex = [[UserData instance] getSound] ? 0 : 1;
		[menu addChild:soundMenuItem];
		
		if ([HotWireAppDelegate isIPhone]) {
			CCMenuItemImage *vibrationOnMenuItem = [CCMenuItemImage itemFromNormalImage:@"options_vibration_on.png" selectedImage:@"options_vibration_on_p.png"];
			CCMenuItemImage *vibrationOffMenuItem = [CCMenuItemImage itemFromNormalImage:@"options_vibration_off.png" selectedImage:@"options_vibration_off_p.png"];
			vibrationMenuItem = [CCMenuItemToggle itemWithTarget:self selector:@selector(vibration:) items:vibrationOnMenuItem, vibrationOffMenuItem, nil];
			vibrationMenuItem.selectedIndex = [[UserData instance] getVibration] ? 0 : 1;
			[menu addChild:vibrationMenuItem];
		}
		
		CCMenuItemImage *gridOnMenuItem = [CCMenuItemImage itemFromNormalImage:@"options_grid_on.png" selectedImage:@"options_grid_on_p.png"];
		CCMenuItemImage *gridOffMenuItem = [CCMenuItemImage itemFromNormalImage:@"options_grid_off.png" selectedImage:@"options_grid_off_p.png"];
		gridMenuItem = [CCMenuItemToggle itemWithTarget:self selector:@selector(grid:) items:gridOnMenuItem, gridOffMenuItem, nil];
		gridMenuItem.selectedIndex = [[UserData instance] getGrid] ? 0 : 1;
		[menu addChild:gridMenuItem];

		CCMenuItemImage *backMenuItem = [CCMenuItemImage itemFromNormalImage:@"menu_back.png" selectedImage:@"menu_back_p.png" target:self selector:@selector(hideOptions:)];
		[menu addChild:backMenuItem];
		
        [menu alignItemsVerticallyWithPadding:5.0f];
		[self addChild:menu];
		
		[self switchButtons:NO];
		self.touchEnabled = NO;
	}
	return self;
}

- (void)switchButtons:(BOOL)state {
	for (CCNode* node in self.children)	{
		if ([node class] == [CCMenu class])	{
			CCMenu* menu = ((CCMenu*)node);
			for (CCMenuItem* item in [menu children])
			{
				[item setIsEnabled:state];
			}
		}
	}
}

- (void)showOptions:(HotWireMenuScene *)aMenuScene {
	[self switchButtons:YES];
	[[SoundManager instance] playOptionOpenTransitionSound];
	self.menuScene = aMenuScene;
	self.scale = 0;
	self.visible = YES;
	CCScaleTo *scaleTo = [CCScaleTo actionWithDuration:0.5f scale:1.0f];
	CCAction *fadeIn = [CCFadeIn actionWithDuration:0.5f];
	[self runAction:[CCSpawn actions:[CCEaseBackOut actionWithAction:scaleTo], fadeIn, nil]];
}

- (void)music:(CCMenuItem *)menuItem {
	[[UserData instance] setMusic:musicMenuItem.selectedIndex == 0];
	[[SoundManager instance] playToggleButtonSound];
}

- (void)sound:(CCMenuItem *)menuItem {
	[[UserData instance] setSound:soundMenuItem.selectedIndex == 0];
	[[SoundManager instance] playToggleButtonSound];
}

- (void)vibration:(CCMenuItem *)menuItem {
	[[UserData instance] setVibration:vibrationMenuItem.selectedIndex == 0];
	[[SoundManager instance] playToggleButtonSound];
}

- (void)grid:(CCMenuItem *)menuItem {
	[[UserData instance] setGrid:gridMenuItem.selectedIndex == 0];
	[[SoundManager instance] playToggleButtonSound];	
}

- (void)hideOptions:(CCMenuItem *)menuItem {
	[[SoundManager instance] playBackButtonSound];
	[self switchButtons:NO];
	CCScaleTo *scaleTo = [CCScaleTo actionWithDuration:0.5f scale:0.0f];
	CCAction *fadeOut = [CCFadeOut actionWithDuration:0.5f];
	[self runAction:[CCSpawn actions:[CCEaseBackIn actionWithAction:scaleTo], fadeOut, nil]];
	[menuScene optionsClosed];
	[[SoundManager instance] playOptionCloseTransitionSound];
}

- (void)setColor:(ccColor3B)color {
    color_ = color;
	id<CCRGBAProtocol> item;
	CCARRAY_FOREACH(_children, item)
	[item setColor:color];
}

- (void)setOpacity:(GLubyte)newOpacity {
    opacity_ = newOpacity;
    id<CCRGBAProtocol> item;
    CCARRAY_FOREACH(_children, item)
    [item setOpacity:newOpacity];
}

- (void)updateDisplayedColor:(ccColor3B)color {
    id<CCRGBAProtocol> item;
    CCARRAY_FOREACH(_children, item)
    [item updateDisplayedColor:color];
}

- (void)updateDisplayedOpacity:(GLubyte)opacity {
    id<CCRGBAProtocol> item;
    CCARRAY_FOREACH(_children, item)
    [item updateDisplayedOpacity:opacity];
}

@end
