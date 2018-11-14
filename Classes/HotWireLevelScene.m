//
//  HotWireLevelScene.m
//  HotWire
//
//  Created by Oliver Klemenz on 03.01.11.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#import "HotWireLevelScene.h"
#import "HotWireMenuScene.h"
#import "HotWireGameScene.h"
#import "SoundManager.h"
#import "WireTileMap.h"
#import "UserData.h"
#import "GameData.h"
#import "TextureManager.h"
#import "HighscoreView.h"
#import "GameCenterClient.h"

@implementation HotWireLevelScene

@synthesize levelType, level, wireSize, wireTileMapID;
@synthesize wireTileMap1, wireTileMap2, yourHighscore, bestHighscore, notAvailable;
@synthesize retroSun, lightning, levelFrameBack, highscoreLabel, levelLabel, levelSizeLabel, previousLevelMenuItem, nextLevelMenuItem;
@synthesize difficulty, difficultyLabel, checkIcon, crossIcon, lockIcon, starIcon, checkDisplay, crossDisplay, lockDisplay, starDisplay;

+ (id)scene {
	CCScene *scene = [CCScene node];
	HotWireLevelScene *layer = [HotWireLevelScene node];
	[scene addChild:layer];
	return scene;
}

- (id)init {
	if ((self = [super init])) {
		self.levelType = [[UserData instance] getCurrentLevelType];
		self.level = [[UserData instance] getCurrentLevel];
		
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		CGPoint center = ccp(winSize.width/2, winSize.height/2);

        CCSprite *levelBackground = nil;
		if ([[UserData instance] getTheme] == kBackgroundThemeNight) {
			levelBackground = [CCSprite spriteWithFile:@"level_night.png"];
		} else {
			levelBackground = [CCSprite spriteWithFile:@"level_day.png"];
		}
        levelBackground.scaleX = winSize.width / levelBackground.contentSize.width;
        levelBackground.scaleY = winSize.height / levelBackground.contentSize.height;
        levelBackground.position = center;
        [self addChild:levelBackground];
				
		retroSun = [CCSprite spriteWithFile:@"retro_sun.png"];
		retroSun.position = center;
		retroSun.opacity = 50;
		[self addChild:retroSun];
		
		CCSprite *whiteSun = [CCSprite spriteWithFile:@"white_sun.png"];
		whiteSun.position = center;
		[self addChild:whiteSun];
				
		CCSprite *wire = [CCSprite spriteWithFile:@"menu_wire.png"];
        wire.scaleX = winSize.width / wire.contentSize.width;
        wire.scaleY = winSize.height / wire.contentSize.height;
		wire.opacity = 120;
		wire.position = center;
		[self addChild:wire];
		
		CCMenu *backMenu = [CCMenu menuWithItems:nil];
		CCMenuItemImage *backMenuItem = [CCMenuItemImage itemFromNormalImage:@"menu_back.png" selectedImage:@"menu_back_p.png" target:self selector:@selector(back:)];
		[backMenu addChild:backMenuItem];
		backMenu.anchorPoint = ccp(0, 1);
		backMenu.position = ccp(40, winSize.height - 30);		
		[backMenu alignItemsVertically];
		[self addChild:backMenu];
		
		CCMenu *previousLevelMenu = [CCMenu menuWithItems:nil];
		previousLevelMenuItem = [CCMenuItemImage itemFromNormalImage:@"level_previous.png" selectedImage:@"level_previous_p.png" target:self selector:@selector(previous:)];
		[previousLevelMenu addChild:previousLevelMenuItem];
		previousLevelMenu.anchorPoint = ccp(0, 1);
		previousLevelMenu.position = ccp(65, center.y);		
		[previousLevelMenu alignItemsVertically];
		[self addChild:previousLevelMenu];
		
		CCMenu *nextLevelMenu = [CCMenu menuWithItems:nil];
		nextLevelMenuItem = [CCMenuItemImage itemFromNormalImage:@"level_next.png" selectedImage:@"level_next_p.png" target:self selector:@selector(next:)];
		[nextLevelMenu addChild:nextLevelMenuItem];
		nextLevelMenu.anchorPoint = ccp(1, 1);
		nextLevelMenu.position = ccp(winSize.width - 65, center.y);
		[nextLevelMenu alignItemsVertically];
		[self addChild:nextLevelMenu];
		
		lightning = [CCSprite spriteWithFile:@"level_lightning.png"];
		lightning.position = center;
		lightning.opacity = 0;
		[self addChild:lightning];
		
		id fade = [CCFadeIn actionWithDuration:0.2f];
		id electricity1 = [CCCallFuncN actionWithTarget:self selector:@selector(electricity:)];
		id fadeBack = [CCFadeOut actionWithDuration:0.8f];
		id show = [CCDelayTime actionWithDuration:1.0f];
		id seq = [CCSequence actions:[CCSpawn actions:fade, electricity1, nil], fadeBack, show, nil];
		id repeat = [CCRepeatForever actionWithAction:seq];
		[lightning runAction:repeat];
		
		if (self.levelType == kLevelTypeTraining) {
			CCSprite *title = [CCSprite spriteWithFile:@"level_training.png"];
			title.anchorPoint = ccp(0.5, 1);
			title.position = ccp(center.x, winSize.height);
			[self addChild:title];
		} else if (self.levelType == kLevelTypeCompetition) {
			CCSprite *title = [CCSprite spriteWithFile:@"level_competition.png"];
			title.anchorPoint = ccp(0.5, 1);
			title.position = ccp(center.x, winSize.height);
			[self addChild:title];
		}
		
		difficulty = [CCSprite spriteWithFile:@"level_difficulty.png"];
		difficulty.position = ccp(winSize.width - 67, winSize.height - 45);
		[self addChild:difficulty];

		difficultyLabel = [CCLabelAtlas labelWithString:@"0" charMapFile:@"level_font.png" itemWidth:28 itemHeight:30 startCharMap:'.'];
		difficultyLabel.anchorPoint = ccp(0.5, 0.5);
		difficultyLabel.position = ccp(winSize.width - 67, winSize.height - 55);
		[self addChild:difficultyLabel];
		
		if (self.levelType == kLevelTypeCompetition && [GameCenterClient instance].gameCenterAvailable) {
			CCMenu *scoresMenu = [CCMenu menuWithItems:nil];
			CCMenuItemImage *scoresMenuItem = [CCMenuItemImage itemFromNormalImage:@"menu_scores.png" selectedImage:@"menu_scores_p.png" target:self selector:@selector(scores:)];
			[scoresMenu addChild:scoresMenuItem];
			scoresMenuItem.anchorPoint = ccp(0.5, 0);
			scoresMenu.position = ccp(center.x, 3);		
			[scoresMenu alignItemsVertically];
			[self addChild:scoresMenu];
		} else {
			CCMenu *clearMenu = [CCMenu menuWithItems:nil];
			CCMenuItemImage *clearMenuItem = [CCMenuItemImage itemFromNormalImage:@"level_clear.png" selectedImage:@"level_clear_p.png" target:self selector:@selector(clearScore:)];
			[clearMenu addChild:clearMenuItem];
			clearMenuItem.anchorPoint = ccp(0.5, 0);
			clearMenu.position = ccp(center.x, 3);		
			[clearMenu alignItemsVertically];
			[self addChild:clearMenu];
		}
		
		checkIcon = [CCSprite spriteWithFile:@"level_check.png"];
		checkIcon.scale = 0;
		checkIcon.position = ccp(center.x, center.y);
		[self addChild:checkIcon];
		checkDisplay = NO;
		
		crossIcon = [CCSprite spriteWithFile:@"level_cross.png"];
		crossIcon.scale = 0;
		crossIcon.position = ccp(center.x, center.y);
		[self addChild:crossIcon];
		crossDisplay = NO;
		
		lockIcon = [CCSprite spriteWithFile:@"level_lock.png"];
		lockIcon.scale = 0;
		lockIcon.position = ccp(center.x, center.y);
		[self addChild:lockIcon];
		lockDisplay = NO;
		
		/*starIcon = [CCSprite spriteWithFile:@"level_star.png"];	
		starIcon.scale = 0;
		starIcon.position = ccp(center.x, center.y);
		[self addChild:starIcon];
		starDisplay = NO; */

		levelFrameBack = [CCSprite spriteWithFile:@"level_frame_back.png"];
		levelFrameBack.position = ccp(center.x, center.y - 5);
		[self addChild:levelFrameBack];
		
		wireTileMapID = 0;
		wireTileMap1 = [WireTileMap wireEmpty];
		wireTileMap1.position = ccp(center.x - 100, center.y - 100);
		[wireTileMap1 setScale:0];
		[self addChild:wireTileMap1];
		
		wireTileMap2 = [WireTileMap wireEmpty];
		wireTileMap2.position = ccp(center.x - 100, center.y - 100);
		[wireTileMap2 setScale:0];
		[self addChild:wireTileMap2];
		
		CCMenu *levelMenu = [CCMenu menuWithItems:nil];
		CCMenuItemImage *levelMenuItem = [CCMenuItemImage itemFromNormalImage:@"level_frame.png" selectedImage:@"level_frame_p.png" target:self selector:@selector(play:)];
		[levelMenu addChild:levelMenuItem];
		levelMenu.position = ccp(center.x, center.y - 5);
		[levelMenu alignItemsVertically];
		[self addChild:levelMenu];
				
		CCSprite *yourHighscoreLabel = [CCSprite spriteWithFile:@"level_your_highscore.png"];
		yourHighscoreLabel.anchorPoint = ccp(0, 0);
		yourHighscoreLabel.position = ccp(10, 20);
		[self addChild:yourHighscoreLabel];
				
		yourHighscore = [HighscoreView node];
		yourHighscore.position = ccp(10, 2);
		[self addChild:yourHighscore];
		
		if (self.levelType == kLevelTypeCompetition && [GameCenterClient instance].gameCenterAvailable) {
			CCSprite *bestHighscoreLabel = [CCSprite spriteWithFile:@"level_best_highscore.png"];
			bestHighscoreLabel.anchorPoint = ccp(0, 0);
			bestHighscoreLabel.position = ccp(winSize.width - 140, 20);
			[self addChild:bestHighscoreLabel];
		
			bestHighscore = [HighscoreView node];
			bestHighscore.anchorPoint = ccp(0, 0);
			bestHighscore.position = ccp(winSize.width - 152, 2);
			[self addChild:bestHighscore];		
			
			notAvailable = [CCSprite spriteWithFile:@"level_not_available.png"];
			notAvailable.anchorPoint = ccp(0, 0);
			notAvailable.position = ccp(winSize.width - 155, 0);
			notAvailable.visible = NO;
			[self addChild:notAvailable];
		}
		
		CCSprite *levelTitle = [CCSprite spriteWithFile:@"level_level.png"];
		levelTitle.anchorPoint = ccp(1, 0);
		levelTitle.position = ccp(center.x + 15, center.y + 89);
		[self addChild:levelTitle];
		
		levelLabel = [CCLabelAtlas labelWithString:@"0" charMapFile:@"level_font.png" itemWidth:28 itemHeight:30 startCharMap:'.'];
		levelLabel.anchorPoint = ccp(0, 0);
		levelLabel.position = ccp(center.x + 8, center.y + 90);
		[self addChild:levelLabel];
		
		CCSprite *levelSize = [CCSprite spriteWithFile:@"level_size.png"];
		levelSize.position = ccp(center.x - 70, 53);
		[self addChild:levelSize];		
		
		CCSprite *levelParts = [CCSprite spriteWithFile:@"level_parts.png"];
		levelParts.position = ccp(center.x + 65, 52);
		[self addChild:levelParts];		
		
		levelSizeLabel = [CCLabelAtlas labelWithString:@"0" charMapFile:@"level_font.png" itemWidth:28 itemHeight:30 startCharMap:'.'];
		levelSizeLabel.anchorPoint = ccp(0.5, 0.5);
		levelSizeLabel.position = ccp(center.x - 5, 54);
		[self addChild:levelSizeLabel];
		
		self.touchEnabled = YES;
		[self schedule:@selector(update:)];
		[self update:0];
		
		[self updateInfo];
		
		[[SoundManager instance] playLevelBackgroundMusic];
	}
	return self;
}

- (void)electricity:(id)sender {
	[[SoundManager instance] playMenuElectricitySound];
}

- (void)updateInfo {
	[[GameCenterClient instance] retrieveTopScoreForLevel:self.level];
	NSString *wireID = [GameData getLevelWireID:self.level andType:self.levelType];
	NSString *levelString = [NSString stringWithFormat:@"%i", self.level];
	[levelLabel setString:levelString];
	NSString *sizeString = [NSString stringWithFormat:@"%i", (int)[wireID length]];
	[levelSizeLabel setString:sizeString];
	NSString *difficultyString = [NSString stringWithFormat:@"%i", [GameData getLevelDifficulty:self.level andType:self.levelType]];
	[difficultyLabel setString:difficultyString];
	[yourHighscore updateHighscore:[[UserData instance] getLevelHighscore:self.level]];
	if (self.levelType == kLevelTypeCompetition) {
		if (![GameCenterClient instance].gameCenterAvailable || ![[GameCenterClient instance] isBestTimeAvailableForLevel:self.level]) {
			notAvailable.visible = YES;
			bestHighscore.visible = NO;
		} else {
			notAvailable.visible = NO;
			bestHighscore.visible = YES;
			[bestHighscore updateHighscore:[[GameCenterClient instance] getBestTimeForLevel:self.level]];
		}
	}
	if (wireTileMapID == 0) {
		[wireTileMap1 clearWire];
		[wireTileMap1 deserializeWireTiles:wireID];
		[wireTileMap1 zoomToFrameAnimated];
		[wireTileMap2 zoomOutAnimated];
		wireTileMapID = 1;
	} else {
		[wireTileMap2 clearWire];
		[wireTileMap2 deserializeWireTiles:wireID];
		[wireTileMap2 zoomToFrameAnimated];
		[wireTileMap1 zoomOutAnimated];
		wireTileMapID = 0;
	}
	int badge = [[UserData instance] getLevelIconBadge:self.level];
	if (badge == kLevelIconBadgeLock) {
		if (!lockDisplay) {
			[lockIcon runAction:[CCEaseBackOut actionWithAction:[CCActionTween actionWithDuration:0.5f key:@"scale" from:lockIcon.scale to:1.0]]];
			lockDisplay = YES;
		}
		if (checkDisplay) {
			[checkIcon runAction:[CCEaseBackIn actionWithAction:[CCActionTween actionWithDuration:0.5f key:@"scale" from:checkIcon.scale to:0.0]]];
			checkDisplay = NO;
		}
		if (crossDisplay) {
			[crossIcon runAction:[CCEaseBackIn actionWithAction:[CCActionTween actionWithDuration:0.5f key:@"scale" from:crossIcon.scale to:0.0]]];
			crossDisplay = NO;
		}
	} else if (badge == kLevelIconBadgeCheck) {
		if (lockDisplay) {
			[lockIcon runAction:[CCEaseBackIn actionWithAction:[CCActionTween actionWithDuration:0.5f key:@"scale" from:lockIcon.scale to:0.0]]];		
			lockDisplay = NO;
		}
		if (!checkDisplay) {
			[checkIcon runAction:[CCEaseBackOut actionWithAction:[CCActionTween actionWithDuration:0.5f key:@"scale" from:checkIcon.scale to:1.0]]];
			checkDisplay = YES;
		}
		if (crossDisplay) {
			[crossIcon runAction:[CCEaseBackIn actionWithAction:[CCActionTween actionWithDuration:0.5f key:@"scale" from:crossIcon.scale to:0.0]]];
			crossDisplay = NO;
		}
	} else if (badge == kLevelIconBadgeCross) {
		if (lockDisplay) {
			[lockIcon runAction:[CCEaseBackIn actionWithAction:[CCActionTween actionWithDuration:0.5f key:@"scale" from:lockIcon.scale to:0.0]]];		
			lockDisplay = NO;
		}
		if (checkDisplay) {
			[checkIcon runAction:[CCEaseBackIn actionWithAction:[CCActionTween actionWithDuration:0.5f key:@"scale" from:checkIcon.scale to:0.0]]];
			checkDisplay = NO;
		}
		if (!crossDisplay) {
			[crossIcon runAction:[CCEaseBackOut actionWithAction:[CCActionTween actionWithDuration:0.5f key:@"scale" from:crossIcon.scale to:1.0]]];
			crossDisplay = YES;
		}
	} else {
		if (lockDisplay) {
			[lockIcon runAction:[CCEaseBackIn actionWithAction:[CCActionTween actionWithDuration:0.5f key:@"scale" from:lockIcon.scale to:0.0]]];		
			lockDisplay = NO;
		}
		if (checkDisplay) {
			[checkIcon runAction:[CCEaseBackIn actionWithAction:[CCActionTween actionWithDuration:0.5f key:@"scale" from:checkIcon.scale to:0.0]]];
			checkDisplay = NO;
		}
		if (crossDisplay) {
			[crossIcon runAction:[CCEaseBackIn actionWithAction:[CCActionTween actionWithDuration:0.5f key:@"scale" from:crossIcon.scale to:0.0]]];
			crossDisplay = NO;
		}
	}
	if (level == 1) {
		[previousLevelMenuItem runAction:[CCActionTween actionWithDuration:1.0f key:@"opacity" from:previousLevelMenuItem.opacity to:0]];
		[previousLevelMenuItem setIsEnabled:NO];
	} else {
		[previousLevelMenuItem runAction:[CCActionTween actionWithDuration:1.0f key:@"opacity" from:previousLevelMenuItem.opacity to:255]];
		[previousLevelMenuItem setIsEnabled:YES];
	}
	if ((level == kWireTileMapLevelCountTraining    && levelType == kLevelTypeTraining) ||
		(level == kWireTileMapLevelCountCompetition && levelType == kLevelTypeCompetition)) {
		[nextLevelMenuItem runAction:[CCActionTween actionWithDuration:1.0f key:@"opacity" from:nextLevelMenuItem.opacity to:0]];
		[nextLevelMenuItem setIsEnabled:NO];		
	} else {
		[nextLevelMenuItem runAction:[CCActionTween actionWithDuration:1.0f key:@"opacity" from:nextLevelMenuItem.opacity to:255]];
		[nextLevelMenuItem setIsEnabled:YES];
	}	
	[[SoundManager instance] playLevelChangeTransitionSound];
}

- (void)update:(ccTime)dt {
	retroSun.rotation += (2 * dt);
	if (retroSun.rotation >= 360) {
		retroSun.rotation = retroSun.rotation - (floor(retroSun.rotation / 360) * 360);
	}
}

- (void)back:(CCMenuItem *)menuItem {
	[[SoundManager instance] playBackButtonSound];
	[[UserData instance] setCurrentLevel:self.level];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFadeBL transitionWithDuration:1.5f scene:[HotWireMenuScene scene]]];
	[[SoundManager instance] playSceneTransitionSound];
}

- (void)previous:(CCMenuItem *)menuItem {
	[[SoundManager instance] playMenu1ButtonSound];
	if (self.level > 1) {
		self.level--;
	}
	[self updateInfo];
}

- (void)next:(CCMenuItem *)menuItem {
	[[SoundManager instance] playMenu1ButtonSound];
	if ((level < kWireTileMapLevelCountTraining    && levelType == kLevelTypeTraining) ||
		(level < kWireTileMapLevelCountCompetition && levelType == kLevelTypeCompetition)) {
		self.level++;
	}
	[self updateInfo];
}

- (void)scores:(CCMenuItem *)menuItem {
	[[SoundManager instance] playMenu1ButtonSound];
    [[GameCenterClient instance] showLeaderboardForLevel:self.level];
}

- (void)clearScore:(CCMenuItem *)menuItem {
	[[SoundManager instance] playMenu1ButtonSound];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Clear your highscore?" message:@"Do you really want to clear your highscore?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Yes"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                [[SoundManager instance] playMenu1ButtonSound];
                                                [[UserData instance] clearLevelHighscore:self.level];
                                                [yourHighscore updateHighscore:0];
                                            }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"No"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * action) {
                                                [[SoundManager instance] playMenu1ButtonSound];
                                            }]];
    
    [[CCDirector sharedDirector].navigationController presentViewController:alert
                                                                   animated:YES completion:nil];
}

- (void)play:(CCMenuItem *)menuItem {
	if ([[UserData instance] getLevelIconBadge:self.level] != kLevelIconBadgeLock) {
		[[GameCenterClient instance] retrieveAchievements];
		[[UserData instance] setCurrentLevel:self.level];
		[[UserData instance] setDifficulty:[GameData getLevelDifficulty:self.level andType:self.levelType]];
		[[SoundManager instance] playMenu1ButtonSound];
		CCScene *scene = [HotWireGameScene scene];
		if (wireTileMapID == 1) {
			[wireTileMap1 zoomInAnimated];
			[self reorderChild:wireTileMap1 z:100];
		} else {
			[wireTileMap2 zoomInAnimated];
			[self reorderChild:wireTileMap2 z:100];
		}	
		[[CCDirector sharedDirector] replaceScene:[CCTransitionFadeTR transitionWithDuration:1.5f scene:scene]];
		[[SoundManager instance] playSceneTransitionSound];
	} else {
		[[SoundManager instance] playErrorSound];
		id zoomInAction = [CCScaleTo actionWithDuration:0.1 scale:1.3];
		id zoomOutAction = [CCScaleTo actionWithDuration:0.1 scale:1.0];
		[lockIcon runAction:[CCSequence actions:zoomInAction, zoomOutAction, nil]];
	}
}

- (void)showFailed {
	if ([[UserData instance] getLevelIconBadge:self.level] == kLevelIconBadgeNone) {
		[[UserData instance] setLevelIconBadge:self.level andBadge:kLevelIconBadgeCross];
		[[CCActionManager sharedManager] removeAllActionsFromTarget:crossIcon];		
		crossIcon.opacity = 0;
		crossIcon.scale = 5.0;
		crossDisplay = YES;
		id scaleTo = [CCScaleTo actionWithDuration:0.5f scale:1.0];
		id fadeIn = [CCFadeIn actionWithDuration:0.5f];
		[crossIcon runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.5], [CCSpawn actions:scaleTo, fadeIn, nil], nil]];
		[[SoundManager instance] playOptionCloseTransitionSound];
	}
}

- (void)showSuccess {
	BOOL congratulation = NO;
	if ([[UserData instance] getLevelIconBadge:level] != kLevelIconBadgeCheck) {
		[[UserData instance] setLevelIconBadge:level andBadge:kLevelIconBadgeCheck];
		if ((level == kWireTileMapLevelCountTraining && levelType == kLevelTypeTraining) ||
    		(level == kWireTileMapLevelCountCompetition && levelType == kLevelTypeCompetition)) {
			congratulation = YES;
		}
		[[CCActionManager sharedManager] removeAllActionsFromTarget:crossIcon];
		[[CCActionManager sharedManager] removeAllActionsFromTarget:checkIcon];
		crossIcon.scale = 0.0;
		crossDisplay = NO;
		checkIcon.scale = 5.0;
		checkIcon.opacity = 0;
		checkDisplay = YES;
		id scaleTo = [CCScaleTo actionWithDuration:0.5f scale:1.0];
		id fadeIn = [CCFadeIn actionWithDuration:0.5f];
		[checkIcon runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.0], [CCSpawn actions:scaleTo, fadeIn, nil], nil]];
		[[SoundManager instance] playOptionCloseTransitionSound];
	}
	if ((level < kWireTileMapLevelCountTraining && levelType == kLevelTypeTraining) ||
		(level < kWireTileMapLevelCountCompetition && levelType == kLevelTypeCompetition)) {
		int nextLevel = self.level+1;
		if ([[UserData instance] getLevelIconBadge:nextLevel] == kLevelIconBadgeLock) {
			[[UserData instance] setLevelIconBadge:nextLevel andBadge:kLevelIconBadgeNone];
		}
	}
	if (congratulation) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Congratulation!" message:@"You completed all levels!" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * action) {
                                                    [[SoundManager instance] playMenu1ButtonSound];
                                                }]];
        
        [[CCDirector sharedDirector].navigationController presentViewController:alert
                                                                       animated:YES completion:nil];
	}
	[[HotWireAppDelegate instance] saveContext];
}

- (void)dealloc {
	[[TextureManager instance] unloadLevel];
	[super dealloc];
}

@end
