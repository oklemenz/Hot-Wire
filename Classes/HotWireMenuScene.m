//
//  HotWireMenuScene.m
//  HotWire
//
//  Created by Oliver Klemenz on 02.01.11.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#import "HotWireMenuScene.h"
#import "HotWireOptions.h"
#import "HotWirePlaySelect.h"
#import "HotWireGameCenterSelect.h"
#import "HotWireHelpScene.h"
#import "HotWireLevelScene.h"
#import "HotWireGameScene.h"
#import "TextureManager.h"
#import "UserData.h"
#import "SoundManager.h"
#import "GameCenterClient.h"

@implementation HotWireMenuScene

@synthesize themeMenuItem, options, playSelect, gameCenterSelect;
@synthesize retroSun, lightning1, lightning2, moonRotate, sunRotate, moonPosition, sunPosition, currentAngle;

+ (id)scene {
	CCScene *scene = [CCScene node];
	HotWireMenuScene *layer = [HotWireMenuScene node];
	[scene addChild:layer];
	return scene;
}

- (id)init {
	if ((self = [super init])) {        
		CGSize winSize = [[CCDirector sharedDirector] winSize];
        
		CGPoint center = ccp(winSize.width/2, winSize.height/2);
		CCSprite *menu = [CCSprite spriteWithFile:@"menu.png"];
        menu.scaleX = winSize.width / menu.contentSize.width;
        menu.scaleY = winSize.height / menu.contentSize.height;
		menu.position = center;
		[self addChild:menu];

		moonRotate = [CCSprite spriteWithFile:@"menu_moon.png"];
		moonRotate.position = ccp(center.x + 50, center.y - 50);
		moonPosition = moonRotate.position;
		moonRotate.scale = 0.6;
		[self addChild:moonRotate];
		
		sunRotate = [CCSprite spriteWithFile:@"menu_sun.png"];
		sunRotate.position = ccp(center.x - 50, center.y + 50);
		sunPosition = sunRotate.position;
		sunRotate.scale = 0.6;
		[self addChild:sunRotate];
		
		retroSun = [CCSprite spriteWithFile:@"retro_sun.png"];
		retroSun.position = center;
		retroSun.opacity = 50;
		[self addChild:retroSun];

		CCSprite *whiteSun = [CCSprite spriteWithFile:@"white_sun.png"];
		whiteSun.position = center;
		[self addChild:whiteSun];
		
		CCSprite *hotWire = [CCSprite spriteWithFile:@"hot_wire.png"];
		hotWire.anchorPoint	= ccp(0, 1);
		hotWire.position = ccp(winSize.width-[hotWire boundingBox].size.width, [hotWire boundingBox].size.height);
		[self addChild:hotWire];

		CCSprite *wire = [CCSprite spriteWithFile:@"menu_wire.png"];
        wire.scaleX = winSize.width / wire.contentSize.width;
        wire.scaleY = winSize.height / wire.contentSize.height;
		wire.position = center;
		[self addChild:wire];
		
		CCMenu *menu1 = [CCMenu menuWithItems:nil];
		CCMenuItemImage *playMenuItem = [CCMenuItemImage itemFromNormalImage:@"menu_play.png" selectedImage:@"menu_play_p.png" target:self selector:@selector(play:)];
		[menu1 addChild:playMenuItem];
        if ([GameCenterClient instance].gameCenterAvailable) {
            CCMenuItemImage *gameCenterMenuItem = [CCMenuItemImage itemFromNormalImage:@"menu_game_center.png" selectedImage:@"menu_game_center_p.png" target:self selector:@selector(gameCenter:)];
            [menu1 addChild:gameCenterMenuItem];
        }
		menu1.position = ccp(winSize.width-[playMenuItem boundingBox].size.width + 50, center.y - 28);
		[menu1 alignItemsVerticallyWithPadding:0.0f];
		[self addChild:menu1];

		CCMenu *menu2 = [CCMenu menuWithItems:nil];
		menu2.anchorPoint = ccp(0, 1);
		menu2.position = ccp(60, winSize.height - 65);
		CCMenuItemImage *helpMenuItem = [CCMenuItemImage itemFromNormalImage:@"menu_help_btn.png" selectedImage:@"menu_help_btn_p.png" target:self selector:@selector(help:)];
		[menu2 addChild:helpMenuItem];
		
		CCMenuItemImage *optionsMenuItem = [CCMenuItemImage itemFromNormalImage:@"menu_options.png" selectedImage:@"menu_options_p.png" target:self selector:@selector(options:)];
		[menu2 addChild:optionsMenuItem];
		
		CCMenuItemImage *themeSunMenuItem = [CCMenuItemImage itemFromNormalImage:@"menu_theme_sun.png" selectedImage:@"menu_theme_p.png"];
		CCMenuItemImage *themeMoonMenuItem = [CCMenuItemImage itemFromNormalImage:@"menu_theme_moon.png" selectedImage:@"menu_theme_p.png"];
		themeMenuItem = [CCMenuItemToggle itemWithTarget:self selector:@selector(theme:) items:themeMoonMenuItem, themeSunMenuItem, nil];
		themeMenuItem.selectedIndex = [[UserData instance] getTheme];
		[menu2 addChild:themeMenuItem];
		[menu2 alignItemsVerticallyWithPadding:2.0f];
		[self addChild:menu2];
		
		lightning1 = [CCSprite spriteWithFile:@"menu_lightning1.png"];
		lightning1.position = center;
		lightning1.opacity = 0;
		[self addChild:lightning1];

		id fade1 = [CCFadeIn actionWithDuration:0.2f];
		id electricity1 = [CCCallFuncN actionWithTarget:self selector:@selector(electricity:)];
		id fade_back1 = [CCFadeOut actionWithDuration:0.8f];
		id show1 = [CCDelayTime actionWithDuration:1.0f];
		id seq1 = [CCSequence actions:[CCSpawn actions:fade1, electricity1, nil], fade_back1, show1, nil];
		id repeat1 = [CCRepeatForever actionWithAction:seq1];
		[lightning1 runAction:repeat1];
		
		lightning2 = [CCSprite spriteWithFile:@"menu_lightning2.png"];
		lightning2.position = center;
		lightning2.opacity = 1;
		[self addChild:lightning2];
		
		id fade2 = [CCFadeOut actionWithDuration:0.8f];
		id show2 = [CCDelayTime actionWithDuration:2.0f];		
		id fade_in2 = [CCFadeIn actionWithDuration:0.2f];
		id electricity2 = [CCCallFuncN actionWithTarget:self selector:@selector(electricity:)];
		id seq2 = [CCSequence actions:fade2, show2, [CCSpawn actions:fade_in2, electricity2, nil], nil];
		id repeat2 = [CCRepeatForever actionWithAction:seq2];
		[lightning2 runAction:repeat2];
		
		options = [HotWireOptions node];
		options.visible = NO;
		[self addChild:options];

		playSelect = [HotWirePlaySelect node];
		playSelect.visible = NO;
		[self addChild:playSelect];

		gameCenterSelect = [HotWireGameCenterSelect node];
		gameCenterSelect.visible = NO;
		[self addChild:gameCenterSelect];
		
		[[SoundManager instance] playMenuBackgroundMusic];
		[[GameCenterClient instance] authenticateLocalPlayer:NO];
		
		[self schedule:@selector(update:)];
		[self update:0];
	}
	return self;
}

- (void)update:(ccTime)dt {
	retroSun.rotation += (2 * dt);
	if (retroSun.rotation >= 360) {
		retroSun.rotation = retroSun.rotation - (floor(retroSun.rotation / 360) * 360);
	}
	
	float anglePerTick = 0.005;
    currentAngle += anglePerTick;  
    moonRotate.position = ccpAdd(ccpMult(ccpForAngle(currentAngle), 30), moonPosition);
    moonRotate.rotation = currentAngle * 180 / M_PI;
    sunRotate.position = ccpSub(sunPosition, ccpMult(ccpForAngle(-currentAngle), 30));
    sunRotate.rotation = -currentAngle * 180 / M_PI;
}

- (void)electricity:(id)sender {
	[[SoundManager instance] playMenuElectricitySound];
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

- (void)help:(CCMenuItem *)menuItem {
	[[SoundManager instance] playMenu2ButtonSound];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipAngular transitionWithDuration:1.0f scene:[HotWireHelpScene scene]]];	
	[[SoundManager instance] playSceneTransitionSound];
}

- (void)options:(CCMenuItem *)menuItem {
	[[SoundManager instance] playMenu2ButtonSound];
	[self switchButtons:NO];
	[options showOptions:self];
}

- (void)optionsClosed {
	[self switchButtons:YES];
}

- (void)theme:(CCMenuItem *)menuItem {
	[[SoundManager instance] playToggleButtonSound];
	[[UserData instance] setTheme:(int)themeMenuItem.selectedIndex];
	if (themeMenuItem.selectedIndex == kBackgroundThemeNight) {
		[[TextureManager instance] unloadDayTheme];
	} else if (themeMenuItem.selectedIndex == kBackgroundThemeDay) {
		[[TextureManager instance] unloadNightTheme];
	}
}

- (void)play:(CCMenuItem *)menuItem {
	[[SoundManager instance] playMenu1ButtonSound];
	[self switchButtons:NO];
    [playSelect showSelect:self];
}

- (void)playClosed {
	[self switchButtons:YES];
}

- (void)showLevel:(int)type {
	[[UserData instance] setCurrentLevelType:type];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFadeTR transitionWithDuration:1.5f scene:[HotWireLevelScene scene]]];
	[[SoundManager instance] playSceneTransitionSound];
}

- (void)gameCenter:(CCMenuItem *)menuItem {
	[[SoundManager instance] playMenu1ButtonSound];
    [self switchButtons:NO];
	[gameCenterSelect showSelect:self];
}

- (void)gameCenterClosed {
	[self switchButtons:YES];
}

- (void)dealloc {
	[[TextureManager instance] unloadMenu];
	[super dealloc];
}

@end
