//
//  HelloWorldLayer.h
//  HotWire
//
//  Created by Oliver Klemenz on 12.11.10.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#define kBackgroundThemeNight 0
#define kBackgroundThemeDay   1

#define kBackgroundOffsetX    0
#define kBackgroundOffsetY -100

#define kBackgroundDayMoveSpeedRatio      0.14
#define kBackgroundNightMoveSpeedRatio	  0.04
#define kBackgroundNightRotatioSpeedRatio 0.03

#define kFilterFactor 0.05
#define kFingerNone   0
#define kFingerFirst  1
#define kFingerSecond 2
#define kFingerTopNone  -0
#define kFingerTopFirst  0
#define kFingerTopSecond 1

#define kFingerRadius			30
#define kFingerSpotOpacity		150
#define kFingerSpotFadeDuration 0.5
#define kRingRadius             30

#define kFingerBiasSteps 30

#define kCollisionAlpha 255
#define kSparksAlpha 100

#define kElectricityShow    0.3
#define kElectricityShowVar 0.5
#define kElectricityHide    1.0
#define kElectricityHideVar 3.0

#define kPowerMin 5
#define kPowerMax 162
#define kPowerPercentMax 100
#define kPowerReduceFactorExp 0.3
#define kPowerReduceFactorLin 4.0

#define kBlackBackgroundOpacity 150

#import "cocos2d.h"

#import "WireTileMap.h"
#import "SparksParticle.h"
#import "Lightning.h"
#import "GridView.h"
#import "CheckedFlag.h"
#import "BlackBackground.h"

@class HotWireAppDelegate;

@interface HotWireGameScene : CCLayer <UIApplicationDelegate> {
	
	int level;
	GridView *gridView;
	WireTileMap *wireTileMap;

	CCSprite *daySky;
	CCSprite *dayCloudsTop;
	CCSprite *dayCloudsBottom;
	CCSprite *daySun;
	CCSprite *dayMountains;
	CCSprite *dayRainbow;
	
	CCSprite *nightSky;
	CCSprite *nightLittleStars;
	CCSprite *nightBigStars;
	CCSprite *nightMoon;
	CCSprite *nightEarth;
	
	CCSprite *ringLeft;
	CCSprite *ringRight;
	CCSprite *leftFinger;
	CCSprite *rightFinger;

	CCSprite *powerDisplay;
	
	CCSprite *pauseDisplay;
	CCSprite *levelDoneDisplay;
	CCSprite *gameOverDisplay;
	CCSprite *outOfPowerDisplay;
	CCSprite *outsideWireDisplay;
	CCSprite *yourScoreDisplay;
	CCSprite *yourHighscoreDisplay;
	CCSprite *aNewHighscoreDisplay;
	CCSprite *aNewAchievementDisplay;

	CCLabelAtlas *scoreLabel;
	CCSprite *scoreBack;
	
	CCMenuItemToggle *pausePlayMenuItem;
	CCMenuItemImage *menuMenuItem;

	CCLabelAtlas *timeLabel;
	
	SparksParticle *sparks;
	Tesla *tesla1;
	Tesla *tesla2;
	
	CheckedFlag *checkedFlag;
	
	BlackBackground *blackBackground;
	
	CGSize winSize;
	CGPoint gradient;
	
	int topTouchIndex;
	int leftFingerSet;
	int rightFingerSet;
	CGFloat prevAngle;
	
	CGFloat ringAngle;
	CGPoint ringPosition;
    CGPoint moveTouchPos;

	int fingerBiasCounter;
	CGPoint firstFingerBiasDelta;
	CGPoint firstFingerBias;
	CGPoint secondFingerBiasDelta;
	CGPoint secondFingerBias;
	
	int currentTileIndex;
	CGPoint currentTilePos;
	CGPoint previousTilePos;
	CGPoint previous2TilePos;	
	CGPoint nextTilePos;
	CGPoint nextTile2Pos;
	
	double difficulty;
	double reduceFactor;
	double power;
	double time;
	BOOL paused;
	BOOL inPausing;
	BOOL stopped;
	BOOL gameOver;
	BOOL highscore;
	BOOL done;
	BOOL newAchievement;
	int touchCount;

}

@property int level;

@property (nonatomic, retain) GridView *gridView;
@property (nonatomic, retain) CCTMXTiledMap *wireTileMap;

@property (nonatomic, retain) CCSprite *daySky;
@property (nonatomic, retain) CCSprite *dayCloudsTop;
@property (nonatomic, retain) CCSprite *dayCloudsBottom;
@property (nonatomic, retain) CCSprite *daySun;
@property (nonatomic, retain) CCSprite *dayMountains;
@property (nonatomic, retain) CCSprite *dayRainbow;

@property (nonatomic, retain) CCSprite *nightSky;
@property (nonatomic, retain) CCSprite *nightLittleStars;
@property (nonatomic, retain) CCSprite *nightBigStars;
@property (nonatomic, retain) CCSprite *nightMoon;
@property (nonatomic, retain) CCSprite *nightEarth;

@property (nonatomic, retain) CCSprite *ringLeft;
@property (nonatomic, retain) CCSprite *ringRight;
@property (nonatomic, retain) CCSprite *leftFinger;
@property (nonatomic, retain) CCSprite *rightFinger;

@property (nonatomic, retain) CCSprite *powerDisplay;

@property (nonatomic, retain) CCSprite *pauseDisplay;
@property (nonatomic, retain) CCSprite *levelDoneDisplay;
@property (nonatomic, retain) CCSprite *gameOverDisplay;
@property (nonatomic, retain) CCSprite *outOfPowerDisplay;
@property (nonatomic, retain) CCSprite *outsideWireDisplay;
@property (nonatomic, retain) CCSprite *yourScoreDisplay;
@property (nonatomic, retain) CCSprite *yourHighscoreDisplay;
@property (nonatomic, retain) CCSprite *aNewHighscoreDisplay;
@property (nonatomic, retain) CCSprite *aNewAchievementDisplay;

@property (nonatomic, retain) CCLabelAtlas *scoreLabel;
@property (nonatomic, retain) CCSprite *scoreBack;

@property (nonatomic, retain) CCMenuItemToggle *pausePlayMenuItem;
@property (nonatomic, retain) CCMenuItemImage *menuMenuItem;

@property (nonatomic, retain) CCLabelAtlas *timeLabel;

@property (nonatomic, retain) SparksParticle *sparks;
@property (nonatomic, retain) Tesla *tesla1;
@property (nonatomic, retain) Tesla *tesla2;

@property (nonatomic, retain) CheckedFlag *checkedFlag;

@property (nonatomic, retain) BlackBackground *blackBackground;

@property CGSize winSize;
@property CGPoint gradient;

@property int topTouchIndex;
@property int leftFingerSet;
@property int rightFingerSet;
@property CGFloat prevAngle;

@property CGFloat ringAngle;
@property CGPoint ringPosition;
@property CGPoint moveTouchPos;

@property int fingerBiasCounter;
@property CGPoint firstFingerBiasDelta;
@property CGPoint firstFingerBias;
@property CGPoint secondFingerBiasDelta;
@property CGPoint secondFingerBias;

@property int currentTileIndex;
@property CGPoint currentTilePos;
@property CGPoint previousTilePos;
@property CGPoint previous2TilePos;
@property CGPoint nextTilePos;
@property CGPoint next2TilePos;

@property double difficulty;
@property double reduceFactor;
@property double power;
@property double time;
@property BOOL paused;
@property BOOL inPausing;
@property BOOL stopped;
@property BOOL gameOver;
@property BOOL highscore;
@property BOOL done;
@property BOOL newAchievement;
@property int touchCount;

- (void)gameCheck:(BOOL)inUpdate;

- (void)placeTesla:(Tesla *)aTesla;
- (void)createSparks:(CGPoint)position;

- (CGFloat)calcRotation:(CGPoint)start andEnd:(CGPoint)end;
- (void)reducePower:(CGFloat)alpha;

- (void)showBlackBackground;
- (void)hideBlackBackground;
- (void)setPauseMode;
- (void)pause:(CCMenuItem *)menuItem;
- (void)resumeGame;
- (void)showBackToHome:(CCMenuItem *)menuItem;
- (void)backToHome;
- (void)unloadLevel;
- (void)showLevelDone;
- (void)showGameOver:(BOOL)outsideWire;
- (void)showHighscore;
- (void)stopControlMode;
- (void)resetFingers;
- (void)updateTilePositions;
- (CGPoint)calcScrollingAll:(CGPoint)delta;

+ (id)scene;

@end
