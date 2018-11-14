//
//  HotWireLevelScene.h
//  HotWire
//
//  Created by Oliver Klemenz on 03.01.11.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class WireTileMap, HighscoreView;

#define kLevelTypeTraining    1
#define kLevelTypeCompetition 2

@interface HotWireLevelScene : CCLayer <UIApplicationDelegate> {

	int levelType;
	int level;
	int wireSize;
	int wireTileMapID;

	WireTileMap *wireTileMap1;
	WireTileMap *wireTileMap2;
	
	CCSprite *retroSun;
	CCSprite *lightning;
	CCSprite *levelFrameBack;
	CCLabelAtlas *highscoreLabel;
	CCLabelAtlas *levelLabel;
	CCLabelAtlas *levelSizeLabel;
	
	CCSprite *difficulty;
	CCLabelAtlas *difficultyLabel;
	
	CCSprite *checkIcon;
	CCSprite *crossIcon;
	CCSprite *lockIcon;
	CCSprite *starIcon;
	
	BOOL checkDisplay;
	BOOL crossDisplay;
	BOOL lockDisplay;
	BOOL starDisplay;
	
	CCMenuItemImage *previousLevelMenuItem;
	CCMenuItemImage *nextLevelMenuItem;
	
	HighscoreView *yourHighscore;
	HighscoreView *bestHighscore;
	CCSprite *notAvailable;
}

@property int levelType;
@property int wireSize;
@property int level;
@property int wireTileMapID;

@property(nonatomic, retain) WireTileMap *wireTileMap1;
@property(nonatomic, retain) WireTileMap *wireTileMap2;

@property(nonatomic, retain) CCSprite *retroSun;
@property(nonatomic, retain) CCSprite *lightning;
@property(nonatomic, retain) CCSprite *levelFrameBack;
@property(nonatomic, retain) CCLabelAtlas *highscoreLabel;
@property(nonatomic, retain) CCLabelAtlas *levelLabel;
@property(nonatomic, retain) CCLabelAtlas *levelSizeLabel;

@property(nonatomic, retain) CCSprite *difficulty;
@property(nonatomic, retain) CCLabelAtlas *difficultyLabel;

@property(nonatomic, retain) CCSprite *checkIcon;
@property(nonatomic, retain) CCSprite *crossIcon;
@property(nonatomic, retain) CCSprite *lockIcon;
@property(nonatomic, retain) CCSprite *starIcon;

@property BOOL checkDisplay;
@property BOOL crossDisplay;
@property BOOL lockDisplay;
@property BOOL starDisplay;

@property(nonatomic, retain) CCMenuItemImage *previousLevelMenuItem;
@property(nonatomic, retain) CCMenuItemImage *nextLevelMenuItem;

@property(nonatomic, retain) HighscoreView *yourHighscore;
@property(nonatomic, retain) HighscoreView *bestHighscore;

@property(nonatomic, retain) CCSprite *notAvailable;

+ (id)scene;

- (void)electricity:(id)sender;
- (void)updateInfo;
- (void)update:(ccTime)dt;

- (void)back:(CCMenuItem *)menuItem;
- (void)previous:(CCMenuItem *)menuItem;
- (void)next:(CCMenuItem *)menuItem;
- (void)scores:(CCMenuItem *)menuItem;
- (void)clearScore:(CCMenuItem *)menuItem;
- (void)play:(CCMenuItem *)menuItem;

- (void)showFailed;
- (void)showSuccess;

@end
