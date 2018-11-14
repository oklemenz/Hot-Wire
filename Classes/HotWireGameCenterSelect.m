//
//  HotWireGameCenterSelect.m
//  HotWire
//
//  Created by Oliver on 26.03.11.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#import "HotWireGameCenterSelect.h"
#import "HotWireMenuScene.h"
#import "HotWireLevelScene.h"
#import "SoundManager.h"
#import "GameCenterClient.h"

@implementation HotWireGameCenterSelect

@synthesize menuScene;
@synthesize opacity=opacity_, color=color_;
@synthesize displayedColor, displayedOpacity, cascadeColorEnabled, cascadeOpacityEnabled;

- (id)init {
	if ((self = [super init])) {
		self.anchorPoint = ccp(0.5, 0.5);
		
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		CGPoint center = ccp(winSize.width/2, winSize.height/2);
		CCSprite *frame = [CCSprite spriteWithFile:@"menu_frame.png"];
		frame.position = center;
		[self addChild:frame];
		
		CCSprite *selectTile = [CCSprite spriteWithFile:@"game_center_title.png"];
		selectTile.position = ccp(winSize.width/2, winSize.height/2 + [frame boundingBox].size.height / 2 - 6);
		[self addChild:selectTile];
		
		CCMenu *menu = [CCMenu menuWithItems:nil];
		menu.anchorPoint = ccp(0, 1);
		menu.position = ccp(winSize.width/2, winSize.height / 2);
		
		CCMenuItemImage *leaderboardsMenuItem = [CCMenuItemImage itemFromNormalImage:@"game_center_leaderboards.png" selectedImage:@"game_center_leaderboards_p.png" target:self selector:@selector(leaderboards:)];
		[menu addChild:leaderboardsMenuItem];

		CCMenuItemImage *achievementsMenuItem = [CCMenuItemImage itemFromNormalImage:@"game_center_achievements.png" selectedImage:@"game_center_achievements_p.png" target:self selector:@selector(achievements:)];
		[menu addChild:achievementsMenuItem];		
		
		CCMenuItemImage *backMenuItem = [CCMenuItemImage itemFromNormalImage:@"menu_back.png" selectedImage:@"menu_back_p.png" target:self selector:@selector(hideSelect:)];
		[menu addChild:backMenuItem];
		
		[menu alignItemsVerticallyWithPadding:10.0f];
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

- (void)showSelect:(HotWireMenuScene *)aMenuScene {
	[[SoundManager instance] playOptionOpenTransitionSound];
	[self switchButtons:YES];
	self.menuScene = aMenuScene;
	self.scale = 0;
	self.visible = YES;
	CCScaleTo *scaleTo = [CCScaleTo actionWithDuration:0.5f scale:1.0f];
	CCAction *fadeIn = [CCFadeIn actionWithDuration:0.5f];
	[self runAction:[CCSpawn actions:[CCEaseBackOut actionWithAction:scaleTo], fadeIn, nil]];
}

- (void)leaderboards:(CCMenuItem *)menuItem {
	[[SoundManager instance] playMenu1ButtonSound];
	[[GameCenterClient instance] showLeaderboard];
	[self hideSelect:nil];
}

- (void)achievements:(CCMenuItem *)menuItem {
	[[SoundManager instance] playMenu1ButtonSound];
	[[GameCenterClient instance] showAchievements];
	[self hideSelect:nil];
}

- (void)hideSelect:(CCMenuItem *)menuItem {
	if (menuItem) {
		[[SoundManager instance] playBackButtonSound];
	}
	[self switchButtons:NO];
	CCScaleTo *scaleTo = [CCScaleTo actionWithDuration:0.5f scale:0.0f];
	CCAction *fadeOut = [CCFadeOut actionWithDuration:0.5f];
	[self runAction:[CCSpawn actions:[CCEaseBackIn actionWithAction:scaleTo], fadeOut, nil]];
	[menuScene gameCenterClosed];
	if (menuItem) {
		[[SoundManager instance] playOptionCloseTransitionSound];
	}
}

-(void)setColor:(ccColor3B)color {
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
