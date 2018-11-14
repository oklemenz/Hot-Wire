//
//  HelloWorldLayer.m
//  HotWire
//
//  Created by Oliver Klemenz on 12.11.10.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#import "HotWireGameScene.h"
#import "HotWireAppDelegate.h"
#import "HotWireLevelScene.h"
#import "Tile.h"
#import "Utilities.h"
#import "UserData.h"
#import "SoundManager.h"
#import "TextureManager.h"
#import "GameCenterClient.h"
#import "CheckedFlag.h"

@implementation HotWireGameScene

@synthesize level, daySky, dayCloudsTop, dayCloudsBottom, daySun, dayMountains, dayRainbow, nightSky, nightLittleStars, nightBigStars, nightMoon, nightEarth;
@synthesize gridView, wireTileMap, ringLeft, ringRight, leftFinger, rightFinger, winSize, tesla1, tesla2, checkedFlag, blackBackground;
@synthesize sparks, topTouchIndex, leftFingerSet, rightFingerSet, ringAngle, ringPosition, moveTouchPos;
@synthesize timeLabel, pausePlayMenuItem, menuMenuItem, powerDisplay, gradient, prevAngle;
@synthesize fingerBiasCounter, firstFingerBiasDelta, firstFingerBias, secondFingerBiasDelta, secondFingerBias, currentTileIndex, currentTilePos, previousTilePos, previous2TilePos, nextTilePos, next2TilePos;
@synthesize difficulty, reduceFactor, power, time, paused, inPausing, stopped, gameOver, highscore, done, newAchievement, touchCount;
@synthesize pauseDisplay, levelDoneDisplay, gameOverDisplay, outOfPowerDisplay, outsideWireDisplay, yourScoreDisplay, yourHighscoreDisplay, aNewHighscoreDisplay, aNewAchievementDisplay, scoreLabel, scoreBack;

+ (id)scene {
	CCScene *scene = [CCScene node];
	HotWireGameScene *layer = [HotWireGameScene node];
	[scene addChild:layer];
	return scene;
}

- (id)init {
	if ((self = [super init])) {
		
		level = [[UserData instance] getCurrentLevel];
		[HotWireAppDelegate instance].game = self;
		
		winSize = [[CCDirector sharedDirector] winSize];
		CGPoint center = ccp(winSize.width / 2, winSize.height / 2);

		if ([[UserData instance] getTheme] == kBackgroundThemeNight) {
			
			nightSky = [CCSprite spriteWithFile:@"night_sky.png"];
			nightSky.anchorPoint = CGPointZero;
			nightSky.position = ccp(kBackgroundOffsetX + 500, kBackgroundOffsetY + 500);
			nightSky.anchorPoint = ccp(0.5, 0.5);
			nightSky.rotation = 0;
			[self addChild:nightSky z:-20];
			nightLittleStars = [CCSprite spriteWithFile:@"night_little_stars.png"];
			nightLittleStars.anchorPoint = CGPointZero;
			nightLittleStars.position = ccp(kBackgroundOffsetX, kBackgroundOffsetY);
			nightLittleStars.anchorPoint = ccp(0.5, 0.5);
			nightLittleStars.rotation = 0;
			[self addChild:nightLittleStars z:-19];
			nightBigStars = [CCSprite spriteWithFile:@"night_big_stars.png"];
			nightBigStars.anchorPoint = CGPointZero;
			nightBigStars.position = ccp(kBackgroundOffsetX, kBackgroundOffsetY);
			nightBigStars.anchorPoint = ccp(0.5, 0.5);
			nightBigStars.rotation = 0;
			[self addChild:nightBigStars z:-18];
			nightMoon = [CCSprite spriteWithFile:@"night_moon.png"];
			nightMoon.anchorPoint = CGPointZero;
			nightMoon.position = ccp(400, 300);
			nightMoon.anchorPoint = ccp(0.5, 0.5);
			nightMoon.rotation = 0;
			[self addChild:nightMoon z:-17];			
			nightEarth = [CCSprite spriteWithFile:@"night_earth.png"];
			nightEarth.anchorPoint = CGPointZero;
			nightEarth.position = ccp(kBackgroundOffsetX - 70, kBackgroundOffsetY + 60);
			[self addChild:nightEarth z:-16];
			[[SoundManager instance] playNightThemeGameBackgroundMusic];
		} else {
			daySky = [CCSprite spriteWithFile:@"day_sky.png"];
			daySky.anchorPoint = CGPointZero;
			daySky.position = ccp(kBackgroundOffsetX - 40, kBackgroundOffsetY);
			[self addChild:daySky z:-20];
			dayCloudsTop = [CCSprite spriteWithFile:@"day_clouds_top.png"];
			dayCloudsTop.anchorPoint = CGPointZero;
			dayCloudsTop.position = ccp(kBackgroundOffsetX - 40, kBackgroundOffsetY - 50);
			[self addChild:dayCloudsTop z:-19];
			dayCloudsBottom = [CCSprite spriteWithFile:@"day_clouds_bottom.png"];
			dayCloudsBottom.anchorPoint = CGPointZero;
			dayCloudsBottom.position = ccp(kBackgroundOffsetX - 40, kBackgroundOffsetY + 50);
			[self addChild:dayCloudsBottom z:-18];
			daySun = [CCSprite spriteWithFile:@"day_sun.png"];
			daySun.position = ccp(400, 300);
			daySun.anchorPoint = ccp(0.5, 0.5);
			daySun.rotation = 0;			
			[self addChild:daySun z:-17];
			dayMountains = [CCSprite spriteWithFile:@"day_mountains.png"];
			dayMountains.anchorPoint = CGPointZero;
			dayMountains.position = ccp(kBackgroundOffsetX - 60, kBackgroundOffsetY + 65);
			[self addChild:dayMountains z:-16];
			dayRainbow = [CCSprite spriteWithFile:@"day_rainbow.png"];
			dayRainbow.anchorPoint = CGPointZero;
			dayRainbow.position = ccp(0, 0);
			[self addChild:dayRainbow z:99];
			[[SoundManager instance] playDayThemeGameBackgroundMusic];
		}
		
		if ([[UserData instance] getGrid]) {
			gridView = [GridView node];
			gridView.opacity = 10;
			gridView.visible = YES;
			[self addChild:gridView z:-10];
		}
		
		wireTileMap = [WireTileMap wireWithLevel:self.level andType:[[UserData instance] getCurrentLevelType]]; 
		[self addChild:wireTileMap z:0];

		ringLeft = [CCSprite spriteWithFile:@"ring_l.png"];
		ringLeft.anchorPoint = ccp(0.5, 0.5);
		ringLeft.position = wireTileMap.startPosition;
		[self addChild:ringLeft z:-5];
		ringRight = [CCSprite spriteWithFile:@"ring_r.png"];
		ringRight.anchorPoint = ccp(0.5, 0.5);
		ringRight.position = wireTileMap.startPosition;
		[self addChild:ringRight z:5];		
		
		leftFinger = [CCSprite spriteWithFile:@"finger_pos.png"];
		leftFinger.opacity = kFingerSpotOpacity;
		leftFinger.anchorPoint = ccp(0.5, 0.5);
		leftFinger.position = ccp(ringLeft.position.x, ringLeft.position.y + 65);
		[self addChild:leftFinger z:20];

		rightFinger = [CCSprite spriteWithFile:@"finger_pos.png"];
		rightFinger.opacity = kFingerSpotOpacity;
		rightFinger.anchorPoint = ccp(0.5, 0.5);
		rightFinger.position = ccp(ringLeft.position.x, ringLeft.position.y - 70);
		[self addChild:rightFinger z:21];
		
		ringPosition = ccpMidpoint(ringLeft.position, ringRight.position);
		ringAngle = 0.0;
		
		self.touchEnabled = YES;
		
		topTouchIndex = topTouchIndex = kFingerTopNone;
		touchCount = 0;
		
		tesla1 = [[Tesla alloc] initTesla];
		[self addChild:tesla1 z:1];
		tesla2 = [[Tesla alloc] initTesla];
		[self addChild:tesla2 z:2];

		difficulty = [[UserData instance] getDifficulty];
		reduceFactor = pow(difficulty, kPowerReduceFactorExp) / kPowerReduceFactorLin;
		power = kPowerPercentMax;
		time = 0;
		
		CCSprite *powerBack = [CCSprite spriteWithFile:@"power_back.png"];
		powerBack.position = ccp(center.x, winSize.height - 20);
		[self addChild:powerBack z:10];

		powerDisplay = [CCSprite spriteWithFile:@"power_display.png"];
		powerDisplay.anchorPoint = ccp(0, 0.5);
		powerDisplay.position = ccp(center.x - kPowerMax / 2, winSize.height - 20);
		[self addChild:powerDisplay z:11];		
		
		CCSprite *powerFront = [CCSprite spriteWithFile:@"power_front.png"];
		powerFront.position = ccp(center.x, winSize.height - 20);
		[self addChild:powerFront z:12];		
		
		timeLabel = [CCLabelAtlas labelWithString:@"00:00:00.00" charMapFile:@"time_font.png" itemWidth:18 itemHeight:20 startCharMap:'.'];
		timeLabel.position = ccp(winSize.width - 11 * 18 - 5, 5);
		[self addChild:timeLabel z:13];
		
		checkedFlag = [[CheckedFlag node] initWithPosition:wireTileMap.endFlagPosition];
		[self addChild:checkedFlag z:14];
		
		blackBackground = [BlackBackground node];
		[blackBackground setOpacity:0];
		[self addChild:blackBackground z:100];
		
		CCMenu *pauseMenu = [CCMenu menuWithItems:nil];
		CCMenuItemImage *pauseMenuItem = [CCMenuItemImage itemFromNormalImage:@"game_pause.png" selectedImage:@"game_pause_p.png"];
		CCMenuItemImage *playMenuItem = [CCMenuItemImage itemFromNormalImage:@"game_play.png" selectedImage:@"game_play_p.png"];
		pausePlayMenuItem = [CCMenuItemToggle itemWithTarget:self selector:@selector(pause:) items:pauseMenuItem, playMenuItem, nil];
		[pauseMenu addChild:pausePlayMenuItem];
		[pauseMenu alignItemsVertically];
		pauseMenu.position = ccp(25, winSize.height - 25);
		[self addChild:pauseMenu z:101];
		
		CCMenu *menuMenu = [CCMenu menuWithItems:nil];
		menuMenuItem = [CCMenuItemImage itemFromNormalImage:@"game_menu.png" selectedImage:@"game_menu_p.png" target:self selector:@selector(showBackToHome:)];
		[menuMenu addChild:menuMenuItem];		
		[menuMenu alignItemsVertically];
		menuMenu.position = ccp(winSize.width - 25, winSize.height - 25);
		[self addChild:menuMenu z:102];
								
		pauseDisplay = [CCSprite spriteWithFile:@"game_pause_title.png"]; 
		pauseDisplay.position = center;
		pauseDisplay.scale = 0;
		pauseDisplay.opacity = 0;
		[self addChild:pauseDisplay z:150];

		levelDoneDisplay = [CCSprite spriteWithFile:@"game_level_done.png"]; 
		levelDoneDisplay.position = center;
		levelDoneDisplay.scale = 0;
		levelDoneDisplay.opacity = 0;
		[self addChild:levelDoneDisplay z:151];
		
		gameOverDisplay = [CCSprite spriteWithFile:@"game_game_over.png"]; 
		gameOverDisplay.position = center;
		gameOverDisplay.scale = 0;
		gameOverDisplay.opacity = 0;
		[self addChild:gameOverDisplay z:152];

		outOfPowerDisplay = [CCSprite spriteWithFile:@"game_out_of_power.png"]; 
		outOfPowerDisplay.position = center;
		outOfPowerDisplay.scale = 0;
		outOfPowerDisplay.opacity = 0;
		[self addChild:outOfPowerDisplay z:153];
		
		outsideWireDisplay = [CCSprite spriteWithFile:@"game_outside_wire.png"]; 
		outsideWireDisplay.position = center;
		outsideWireDisplay.scale = 0;
		outsideWireDisplay.opacity = 0;
		[self addChild:outsideWireDisplay z:154];

		yourScoreDisplay = [CCSprite spriteWithFile:@"game_your_score.png"]; 
		yourScoreDisplay.position = center;
		yourScoreDisplay.scale = 0;
		yourScoreDisplay.opacity = 0;
		[self addChild:yourScoreDisplay z:155];

		yourHighscoreDisplay = [CCSprite spriteWithFile:@"game_your_highscore.png"]; 
		yourHighscoreDisplay.position = center;
		yourHighscoreDisplay.scale = 0;
		yourHighscoreDisplay.opacity = 0;
		[self addChild:yourHighscoreDisplay z:156];

		aNewHighscoreDisplay = [CCSprite spriteWithFile:@"game_new_highscore.png"];
		aNewHighscoreDisplay.position = center;
		aNewHighscoreDisplay.scale = 0;
		aNewHighscoreDisplay.opacity = 0;
		[self addChild:aNewHighscoreDisplay z:157];

		aNewAchievementDisplay = [CCSprite spriteWithFile:@"game_new_achievement.png"];
		aNewAchievementDisplay.position = center;
		aNewAchievementDisplay.scale = 0;
		aNewAchievementDisplay.opacity = 0;
		[self addChild:aNewAchievementDisplay z:158];
		
		scoreBack = [CCSprite spriteWithFile:@"game_score_back.png"];
		scoreBack.position = center;
		scoreBack.scale = 0;
		scoreBack.opacity = 0;
		[self addChild:scoreBack z:159];
		
		scoreLabel = [CCLabelAtlas labelWithString:@"00:00:00.00" charMapFile:@"level_font.png" itemWidth:28 itemHeight:30 startCharMap:'.'];
		scoreLabel.position = ccp(39, 22);
		[scoreBack addChild:scoreLabel];
		 
		gradient = ccp(0, 1);
		stopped = YES;
		
		currentTileIndex = 0;
		[self updateTilePositions];
		
		[self scheduleUpdate];
	}
	return self;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	touchCount = (int)[[event allTouches] count];
	if (gameOver || done) {
		[self backToHome];
		return;
	} else if (highscore) {
		[self showHighscore];
		return;
	}
	[menuMenuItem setIsEnabled:NO];
	[pausePlayMenuItem setIsEnabled:NO];
    moveTouchPos = CGPointZero;
	[self ccTouchesMoved:touches withEvent:event];
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (paused || gameOver || highscore || done) {
		return;
	}
	NSSet *allTouches = [event allTouches];
	if ([allTouches count] == 2) {
		
		BOOL prevBothFingersSet = NO;
		if (leftFingerSet != kFingerNone && rightFingerSet != kFingerNone) {
			prevBothFingersSet = YES;
		}
		
		UITouch *touch = [[allTouches allObjects] objectAtIndex:kFingerTopFirst];
		CGPoint firstTouchPos = [touch locationInView:[touch view]];
		firstTouchPos = [[CCDirector sharedDirector] convertToGL:firstTouchPos];

		touch = [[allTouches allObjects] objectAtIndex:kFingerTopSecond];		
		CGPoint secondTouchPos = [touch locationInView:[touch view]];
		secondTouchPos = [[CCDirector sharedDirector] convertToGL:secondTouchPos];
		
		if (!leftFingerSet && ccpDistance(leftFinger.position, firstTouchPos) <= kFingerRadius) {
			[leftFinger runAction:[CCActionTween actionWithDuration:kFingerSpotFadeDuration key:@"opacity" from:leftFinger.opacity to:0]];
			leftFingerSet = kFingerFirst;
		} else if (!rightFingerSet && ccpDistance(rightFinger.position, firstTouchPos) <= kFingerRadius) {
			[rightFinger runAction:[CCActionTween actionWithDuration:kFingerSpotFadeDuration key:@"opacity" from:rightFinger.opacity to:0]];			
			rightFingerSet = kFingerFirst;
		}

		if (!leftFingerSet && ccpDistance(leftFinger.position, secondTouchPos) <= kFingerRadius) {
			[leftFinger runAction:[CCActionTween actionWithDuration:kFingerSpotFadeDuration key:@"opacity" from:leftFinger.opacity to:0]];
			leftFingerSet = kFingerSecond;
		} else if (!rightFingerSet && ccpDistance(rightFinger.position, secondTouchPos) <= kFingerRadius) {
			[rightFinger runAction:[CCActionTween actionWithDuration:kFingerSpotFadeDuration key:@"opacity" from:rightFinger.opacity to:0]];			
			rightFingerSet = kFingerSecond;
		}	
		
		if (leftFingerSet != kFingerNone && rightFingerSet != kFingerNone) {
			
			if (!prevBothFingersSet) {
				topTouchIndex = kFingerTopFirst;
				fingerBiasCounter = kFingerBiasSteps;
				if (leftFingerSet == kFingerFirst) {
					firstFingerBias = ccpSub(leftFinger.position, firstTouchPos);
					firstFingerBiasDelta = ccp(firstFingerBias.x / fingerBiasCounter, firstFingerBias.y / fingerBiasCounter);
				} else if (leftFingerSet == kFingerSecond) {
					secondFingerBias = ccpSub(leftFinger.position, secondTouchPos);
					secondFingerBiasDelta = ccp(secondFingerBias.x / fingerBiasCounter, secondFingerBias.y / fingerBiasCounter);
				}
				if (rightFingerSet == kFingerFirst) {
					firstFingerBias = ccpSub(rightFinger.position, firstTouchPos);
					firstFingerBiasDelta = ccp(firstFingerBias.x / fingerBiasCounter, firstFingerBias.y / fingerBiasCounter);
				} else if (rightFingerSet == kFingerSecond) {
					secondFingerBias = ccpSub(rightFinger.position, secondTouchPos);
					secondFingerBiasDelta = ccp(secondFingerBias.x / fingerBiasCounter, secondFingerBias.y / fingerBiasCounter);
				}			

				prevBothFingersSet = YES;
			}

			firstTouchPos  = ccpAdd(firstTouchPos, firstFingerBias);
			secondTouchPos = ccpAdd(secondTouchPos, secondFingerBias);
			
			if (leftFingerSet == kFingerFirst) {
				leftFinger.position = firstTouchPos;
			} else if (leftFingerSet == kFingerSecond) {
				leftFinger.position = secondTouchPos;
			}
			if (rightFingerSet == kFingerFirst) {
				rightFinger.position = firstTouchPos;
			} else if (rightFingerSet == kFingerSecond) {
				rightFinger.position = secondTouchPos;
			}
						
			ringPosition = ccpMidpoint(firstTouchPos, secondTouchPos);
						
			CGPoint start = topTouchIndex == kFingerTopFirst ? firstTouchPos : secondTouchPos;
			CGPoint end   = topTouchIndex == kFingerTopSecond ? firstTouchPos : secondTouchPos;
			gradient = ccpNormalize(ccpSub(end, start));
			CGFloat rotationAngle = [self calcRotation:start andEnd:end];
			if ((rotationAngle < 0 && prevAngle > 0) || (rotationAngle > 0 && prevAngle < 0)) {
				if (fabs(rotationAngle) + fabs(prevAngle) >= 160 && fabs(rotationAngle) + fabs(prevAngle) <= 200) {
					if (topTouchIndex == kFingerTopFirst) {
						topTouchIndex = kFingerTopSecond;
					} else {
						topTouchIndex = kFingerTopFirst;
					}
					rotationAngle = [self calcRotation:end andEnd:start];
				}
			}
			prevAngle = ringAngle;
			if ((rotationAngle < 0 && prevAngle > 0) || (rotationAngle > 0 && prevAngle < 0)) {
				if (fabs(rotationAngle) + fabs(prevAngle) >= 160 && fabs(rotationAngle) + fabs(prevAngle) <= 200) {
					if (prevAngle < 0) {
						prevAngle += 180; 
					} else {
						prevAngle -= 180; 
					}
				}
			}
			ringAngle = rotationAngle;
			
			if (fingerBiasCounter > 0) {
				fingerBiasCounter--;
				firstFingerBias  = ccpSub(firstFingerBias, firstFingerBiasDelta);
				secondFingerBias = ccpSub(secondFingerBias, secondFingerBiasDelta);
			} else {
				firstFingerBias = CGPointZero;
				firstFingerBiasDelta = CGPointZero;
				secondFingerBias = CGPointZero;
				secondFingerBiasDelta = CGPointZero;
			}
            
            ringLeft.position = ringPosition;
            ringRight.position = ringPosition;
            ringLeft.rotation  = ringAngle;
            ringRight.rotation = ringAngle;
            
			stopped = NO;
		}
    } else if ([allTouches count] == 1) {
        if (leftFingerSet == kFingerNone && rightFingerSet == kFingerNone) {
            UITouch *touch = [[allTouches allObjects] objectAtIndex:kFingerTopFirst];
            CGPoint firstTouchPos = [touch locationInView:[touch view]];
            firstTouchPos = [[CCDirector sharedDirector] convertToGL:firstTouchPos];
            if (CGPointEqualToPoint(moveTouchPos, CGPointZero)) {
                moveTouchPos = firstTouchPos;
            } else {
                CGPoint delta = ccpSub(firstTouchPos, moveTouchPos);
                [self updatePositions:delta];
                moveTouchPos = firstTouchPos;
            }
        }
	} else {
		[self stopControlMode];
	}
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	touchCount = 0;
    moveTouchPos = CGPointZero;
	[self stopControlMode];
}

- (void)stopControlMode {
	if (!gameOver && !highscore && !done) {
		[menuMenuItem setIsEnabled:YES];
		[pausePlayMenuItem setIsEnabled:YES];
	}
	if (!paused) {
		[self resetFingers];
	}
}

- (void)resetFingers {
	topTouchIndex = kFingerTopNone;
	leftFingerSet = kFingerNone;
	rightFingerSet = kFingerNone;
	fingerBiasCounter = 0;
	firstFingerBias = CGPointZero;
	firstFingerBiasDelta = CGPointZero;
	secondFingerBias = CGPointZero;
	secondFingerBiasDelta = CGPointZero;
	[leftFinger runAction:[CCActionTween actionWithDuration:kFingerSpotFadeDuration key:@"opacity" from:leftFinger.opacity to:kFingerSpotOpacity]];
	[rightFinger runAction:[CCActionTween actionWithDuration:kFingerSpotFadeDuration key:@"opacity" from:rightFinger.opacity to:kFingerSpotOpacity]];
}

- (void)update:(ccTime)dt {
	if (paused || gameOver || highscore || done) {
		[[SoundManager instance] stopSparksSound];
		return;
	}
	[self gameCheck:YES];
	// Tesla
	[tesla1 update:dt];
	[self placeTesla:tesla1];
	[tesla2 update:dt];
	[self placeTesla:tesla2];
	if (!stopped) {
		// Timer
		time += dt;
		[timeLabel setString:[Utilities getTimeString:time]];
	}
}

- (void)updatePositions:(CGPoint)change {
    CGFloat newX = wireTileMap.position.x + change.x;
    CGFloat newY = wireTileMap.position.y + change.y;
    // Restricted by finger position and ring
    if (newX > wireTileMap.topLeft.x) {
        newX = wireTileMap.topLeft.x;
    }
    if (newX < wireTileMap.bottomRight.x) {
        newX = wireTileMap.bottomRight.x;
    }
    if (newY < wireTileMap.topLeft.y) {
        newY = wireTileMap.topLeft.y;
    }
    if (newY > wireTileMap.bottomRight.y) {
        newY = wireTileMap.bottomRight.y;
    }
    CGPoint newPos = ccp(newX, newY);
    CGPoint delta = ccpSub(newPos, wireTileMap.position);
    delta = [self calcScrollingAll:delta];
    if (delta.x != 0 || delta.y != 0) {
        newPos = ccpAdd(wireTileMap.position, delta);
        if (gridView) {
            gridView.position = newPos;
        }
        tesla1.position = newPos;
        tesla2.position = newPos;
        checkedFlag.position = newPos;
        wireTileMap.position = newPos;
        if ([[UserData instance] getTheme] == kBackgroundThemeNight) {
            nightSky.anchorPoint = CGPointZero;
            nightSky.position = ccp(kBackgroundOffsetX + 500 + newPos.x * 2.0 * kBackgroundNightMoveSpeedRatio, kBackgroundOffsetY + 500 + newPos.y * 2.0 * kBackgroundNightMoveSpeedRatio);
            nightSky.anchorPoint =ccp(0.5, 0.5);
            nightSky.rotation =  kBackgroundNightRotatioSpeedRatio * ccpLength(newPos);
            nightLittleStars.anchorPoint = CGPointZero;
            nightLittleStars.position = ccp(kBackgroundOffsetX + newPos.x * kBackgroundNightMoveSpeedRatio, kBackgroundOffsetY + newPos.y * kBackgroundNightMoveSpeedRatio);
            nightLittleStars.anchorPoint = ccp(0.5, 0.5);
            nightLittleStars.rotation = 2.5 * kBackgroundNightRotatioSpeedRatio * ccpLength(newPos);
            nightBigStars.anchorPoint = CGPointZero;
            nightBigStars.position = ccp(kBackgroundOffsetX + newPos.x * kBackgroundNightMoveSpeedRatio, kBackgroundOffsetY + newPos.y * kBackgroundNightMoveSpeedRatio);
            nightBigStars.anchorPoint = ccp(0.5, 0.5);
            nightBigStars.rotation = 3.0 * kBackgroundNightRotatioSpeedRatio * ccpLength(newPos);
            nightMoon.anchorPoint = CGPointZero;
            nightMoon.position = ccp(400 + 3 * newPos.x * kBackgroundNightMoveSpeedRatio, 300 + 3 * newPos.y * kBackgroundNightMoveSpeedRatio);
            nightMoon.anchorPoint = ccp(0.5, 0.5);
            nightMoon.rotation = 2.0 * kBackgroundNightRotatioSpeedRatio * ccpLength(newPos);
            nightEarth.position = ccp(kBackgroundOffsetX - 70 + 6 * newPos.x * kBackgroundNightMoveSpeedRatio, kBackgroundOffsetY + 60 + 6 * newPos.y * kBackgroundNightMoveSpeedRatio);
        } else {
            daySky.position = ccp(kBackgroundOffsetX - 40 + newPos.x * kBackgroundDayMoveSpeedRatio, kBackgroundOffsetY + newPos.y * kBackgroundDayMoveSpeedRatio);
            dayCloudsTop.position = ccp(kBackgroundOffsetX - 40 + 2.0 * newPos.x * kBackgroundDayMoveSpeedRatio, kBackgroundOffsetY - 50 + 1.5 * newPos.y * kBackgroundDayMoveSpeedRatio);
            dayCloudsBottom.position = ccp(kBackgroundOffsetX - 40 + 2.5 * newPos.x * kBackgroundDayMoveSpeedRatio, kBackgroundOffsetY + 50 + 2.0 * newPos.y * kBackgroundDayMoveSpeedRatio);
            daySun.anchorPoint = CGPointZero;
            daySun.position = ccp(400 + 1.0 * newPos.x * kBackgroundDayMoveSpeedRatio, 300 + 1.0 * newPos.y * kBackgroundDayMoveSpeedRatio);
            daySun.anchorPoint = ccp(0.5, 0.5);
            daySun.rotation = 2 * kBackgroundNightRotatioSpeedRatio * ccpLength(newPos);	
            dayMountains.position = ccp(kBackgroundOffsetX - 60 + 1.7 * newPos.x * kBackgroundDayMoveSpeedRatio, kBackgroundOffsetY + 65 + 1.4 * newPos.y * kBackgroundDayMoveSpeedRatio);
        }
    }
}

- (void)gameCheck:(BOOL)inUpdate {
	// Control Check
	BOOL found = NO;
	NSArray *checkPoints = [WireTileMap calcCheckPoints:ringLeft.position andGradient:gradient];
	for (NSValue *checkPoint in checkPoints) {
		CGPoint point = [checkPoint CGPointValue];
		if ([wireTileMap checkTileForPos:point]) {
			found = YES;
			break;
		}
	}
	[checkPoints release];
	// Tile Order check	
	BOOL tileOK = NO;
	CGPoint newTilePos = [wireTileMap getTileCoordForPos:ringLeft.position];
	if (newTilePos.x == currentTilePos.x && newTilePos.y == currentTilePos.y) {
		tileOK = YES;
	} else if (newTilePos.x == nextTilePos.x && newTilePos.y == nextTilePos.y) {
		currentTileIndex++;
		[self updateTilePositions];
		tileOK = YES;
	} else if (newTilePos.x == next2TilePos.x && newTilePos.y == next2TilePos.y) {
		currentTileIndex += 2;
		[self updateTilePositions];
		tileOK = YES;
	} else if (newTilePos.x == previousTilePos.x && newTilePos.y == previousTilePos.y) {
		currentTileIndex--;
		[self updateTilePositions];
		tileOK = YES;
	} else if (newTilePos.x == previous2TilePos.x && newTilePos.y == previous2TilePos.y) {
		currentTileIndex -= 2;
		[self updateTilePositions];
		tileOK = YES;
	} else if (![wireTileMap hasWireTile:ringLeft.position]) {
		tileOK = YES;
	}
	if (!found || !tileOK) {
		power = 0;
		powerDisplay.textureRect = CGRectZero;
		[self showGameOver:YES];
		return;
	}
	// Level Done Check
	if ([wireTileMap checkAtDoneTile:ringLeft.position]) {
		[self showLevelDone];
		return;
	}
	if (inUpdate) {
		// Collision Check
		NSArray *collisionPoints = [WireTileMap calcCollisionPoints:ringLeft.position andGradient:gradient];
		BOOL collision = NO;
		for (NSValue *collisionPoint in collisionPoints) {
			CGPoint point = [collisionPoint CGPointValue];
			CGFloat alpha = [wireTileMap checkAlphaValueForPos:point];
			if (alpha >= kCollisionAlpha) {
				[self reducePower:alpha];
				[self createSparks:point];
				[[SoundManager instance] playSparksSound];
				collision = YES;
			}
		}
		if (!collision) {
			[[SoundManager instance] stopSparksSound];
		}
		[collisionPoints release];
	}
}

- (CGPoint)calcScrollingAll:(CGPoint)delta {
	CGPoint prevLeftFinger = leftFinger.position;
	CGPoint prevRightFinger = rightFinger.position;
	CGPoint prevRingLeft = ringLeft.position;
	CGPoint prevRingRight = ringRight.position;
	CGPoint nextLeftFinger = ccpAdd(prevLeftFinger, delta);
	CGPoint nextRightFinger = ccpAdd(prevRightFinger, delta);
	CGPoint nextRingLeft = ccpAdd(prevRingLeft, delta);
	CGPoint nextRingRight = ccpAdd(prevRingRight, delta);
	// Left Finger
	if (nextLeftFinger.x - kFingerRadius < 0) {
		if (nextLeftFinger.x < prevLeftFinger.x) {
			delta.x = max(delta.x, kFingerRadius - prevLeftFinger.x);
		}
	}
	if (nextLeftFinger.y - kFingerRadius < 0) {
		if (nextLeftFinger.y < prevLeftFinger.y) {
			delta.y = max(delta.y, kFingerRadius - prevLeftFinger.y);
		}
	}
	if (nextLeftFinger.x + kFingerRadius > winSize.width) {
		if (nextLeftFinger.x > prevLeftFinger.x) {
			delta.x = min(delta.x, winSize.width - kFingerRadius - prevLeftFinger.x);
		}
	}
	if (nextLeftFinger.y + kFingerRadius > winSize.height) {
		if (nextLeftFinger.y > prevLeftFinger.y) {
			delta.y = min(delta.y, winSize.height - kFingerRadius - prevLeftFinger.y);
		}
	}
	// Right Finger
	if (nextRightFinger.x - kFingerRadius < 0) {
		if (nextRightFinger.x < prevRightFinger.x) {
			delta.x = max(delta.x, kFingerRadius - prevRightFinger.x);
		}
	}
	if (nextRightFinger.y - kFingerRadius < 0) {
		if (nextRightFinger.y < prevRightFinger.y) {
			delta.y = max(delta.y, kFingerRadius - prevRightFinger.y);
		}
	}
	if (nextRightFinger.x + kFingerRadius > winSize.width) {
		if (nextRightFinger.x > prevRightFinger.x) {
			delta.x = min(delta.x, winSize.width - kFingerRadius - prevRightFinger.x);
		}
	}
	if (nextRightFinger.y + kFingerRadius > winSize.height) {
		if (nextRightFinger.y > prevRightFinger.y) {
			delta.y = min(delta.y, winSize.height - kFingerRadius - prevRightFinger.y);
		}
	}
	// Ring Left
	if (nextRingLeft.x - kRingRadius < 0) {
		if (nextRingLeft.x < prevRingLeft.x) {
            delta.x = max(delta.x, kRingRadius - prevRingLeft.x);
		}
	}
	if (nextRingLeft.y - kRingRadius < 0) {
		if (nextRingLeft.y < prevRingLeft.y) {
			delta.y = max(delta.y, kRingRadius - prevRingLeft.y);
		}
	}
	if (nextRingLeft.x + kRingRadius > winSize.width) {
		if (nextRingLeft.x > prevRingLeft.x) {
			delta.x = min(delta.x, winSize.width - kRingRadius - prevRingLeft.x);
		}
	}
	if (nextRingLeft.y + kRingRadius > winSize.height) {
		if (nextRingLeft.y > prevRingLeft.y) {
			delta.y = min(delta.y, winSize.height - kRingRadius - prevRingLeft.y);
		}
	}	
	// Ring Right
	if (nextRingRight.x - kRingRadius < 0) {
		if (nextRingRight.x < prevRingRight.x) {
			delta.x = max(delta.x, kRingRadius - prevRingRight.x);
		}
	}
	if (nextRingRight.y - kRingRadius < 0) {
		if (nextRingRight.y < prevRingRight.y) {
			delta.y = max(delta.y, kRingRadius - prevRingRight.y);
		}
	}
	if (nextRingRight.x + kRingRadius > winSize.width) {
		if (nextRingRight.x > prevRingRight.x) {
			delta.x = min(delta.x, winSize.width - kRingRadius - prevRingRight.x);
		}
	}
	if (nextRingRight.y + kRingRadius > winSize.height) {
		if (nextRingRight.y > prevRingRight.y) {
			delta.y = min(delta.y, winSize.height - kRingRadius - prevRingRight.y);
		}
	}
	leftFinger.position = ccpAdd(prevLeftFinger, delta);
	rightFinger.position = ccpAdd(prevRightFinger, delta);
	ringLeft.position = ccpAdd(prevRingLeft, delta);
	ringRight.position = ccpAdd(prevRingRight, delta);
	return delta;
}

- (void)placeTesla:(Tesla *)aTesla {
	if (aTesla.status == kElectricityStatusHide) {
		CGRect teslaPosition = [wireTileMap drawTeslaPositions];
		if (!CGRectEqualToRect(teslaPosition, CGRectZero)) {
			CGFloat hideDuration = kElectricityHide	+ [Utilities getFloatRandom:kElectricityHideVar];
			CGFloat showDuration = kElectricityShow + [Utilities getFloatRandom:kElectricityShowVar];
			[aTesla showAtPos:ccp(teslaPosition.origin.x, teslaPosition.origin.y) andPos:ccp(teslaPosition.size.width, teslaPosition.size.height) andHideDuration:hideDuration andShowDuration:showDuration];
		}
	}
}
										
- (void)createSparks:(CGPoint)position {
	sparks = [[SparksParticle alloc] initParticleAtPos:position];
	sparks.autoRemoveOnFinish = YES;
	[self addChild:sparks];
	[sparks release];
}
										
- (CGFloat)calcRotation:(CGPoint)start andEnd:(CGPoint)end {
	CGFloat angle = 0;
	if (end.x - start.x == 0) {
		angle = end.y > start.y ? M_PI_2 : -M_PI_2;
	} else {
		angle = atan((start.y - end.y) / (end.x - start.x));
	}
	CGFloat rotationAngle = CC_RADIANS_TO_DEGREES(angle) + 90;
	if (start.x < end.x) {
		rotationAngle -= 180;
	}
	return rotationAngle;
}

- (void)reducePower:(CGFloat)alpha {
	power -= reduceFactor; // * (alpha / kCollisionAlpha);
	double powerCalc = (kPowerMax * power / 100.0) - kPowerMin;
	if (powerCalc <= kPowerMin) {
		power = 0;
		[self showGameOver:NO];
	}
	powerDisplay.textureRect = CGRectMake(0, 0, powerCalc, 25);
}

- (void)showBlackBackground {
	[blackBackground runAction:[CCFadeTo actionWithDuration:0.5f opacity:kBlackBackgroundOpacity]];
}

- (void)hideBlackBackground {
	[blackBackground runAction:[CCFadeTo actionWithDuration:0.5f opacity:0]];
}

- (void)setPauseMode {
	if (!paused && !gameOver && !highscore && !done) {
		paused = YES;
		stopped = YES;
        [blackBackground setOpacity:kBlackBackgroundOpacity];
		pauseDisplay.opacity = 255;
		pauseDisplay.scale = 1.0;
		[[CCDirector sharedDirector] pause];
		tesla1.paused = YES;
		tesla2.paused = YES;
		pausePlayMenuItem.selectedIndex = 1;
		[pausePlayMenuItem setIsEnabled:YES];
		[menuMenuItem setIsEnabled:YES];
		[self resetFingers];
	}
}

- (void)pause:(CCMenuItem *)menuItem {
	if (inPausing) {
		return;
	}
	if (menuItem) {
		[[SoundManager instance] playMenu2ButtonSound];
	} else {
		pausePlayMenuItem.selectedIndex = 1;
	}
	paused = !paused;
	inPausing = YES;
	[pausePlayMenuItem setIsEnabled:NO];
	if (paused) {
		stopped = YES;
		[[SoundManager instance] stopSparksSound];
		[self showBlackBackground];
		id fadeIn = [CCFadeIn actionWithDuration:0.5f];
		id scaleIn = [CCScaleTo actionWithDuration:0.5f scale:1.0];
		[pauseDisplay runAction:[CCSequence actions:[CCSpawn actions:[CCEaseBackOut actionWithAction:scaleIn], fadeIn, nil], [CCCallFuncN actionWithTarget:self selector:@selector(directorPause:)], nil]];
		tesla1.paused = YES;
		tesla2.paused = YES;
		[[SoundManager instance] playOptionCloseTransitionSound];
	} else {
		[[CCDirector sharedDirector] resume];
		[self hideBlackBackground];
		id fadeOut = [CCFadeOut actionWithDuration:0.5f];
		id scaleOut = [CCScaleTo actionWithDuration:0.5f scale:0.0];
		[pauseDisplay runAction:[CCSequence actions:[CCSpawn actions:[CCEaseBackIn actionWithAction:scaleOut], fadeOut, nil], [CCCallFuncN actionWithTarget:self selector:@selector(directorResume:)], nil]];
		tesla1.paused = NO;
		tesla2.paused = NO;
		[[SoundManager instance] playOptionOpenTransitionSound];
	}
}

- (void)resumeGame {
	if (gameOver || highscore || done) {
		[[CCDirector sharedDirector] resume];
	}
}

- (void)directorPause:(id)sender {
	[[CCDirector sharedDirector] pause];
	[pausePlayMenuItem setIsEnabled:YES];
	inPausing = NO;
}

- (void)directorResume:(id)sender {
	[pausePlayMenuItem setIsEnabled:YES];
	inPausing = NO;
}

- (void)showBackToHome:(CCMenuItem *)menuItem {
	[[SoundManager instance] playBackButtonSound];
	if (!paused && !inPausing) {
		[self pause:nil];
	}
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Quit Level?" message:@"Do you want to quit current level?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Yes"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                [[SoundManager instance] playMenu1ButtonSound];
                                                [self backToHome];
                                            }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"No"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * action) {
                                                [[SoundManager instance] playMenu1ButtonSound];
                                            }]];
    
    [[CCDirector sharedDirector].navigationController presentViewController:alert
                                                                   animated:YES completion:nil];
}

- (void)backToHome {
	[self unloadLevel];
	if (done && highscore && !gameOver && newAchievement) {
		[[GameCenterClient instance] showAchievements];
	}
}

- (void)unloadLevel {
	stopped = YES;
	if (paused) {
		pausePlayMenuItem.selectedIndex = 0;
		[[CCDirector sharedDirector] resume];
	}
	[[SoundManager instance] stopSparksSound];
	[HotWireAppDelegate instance].game = nil;
	CCScene *scene = [HotWireLevelScene scene];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFadeBL transitionWithDuration:1.5f scene:scene]];
	[[SoundManager instance] playSceneTransitionSound];
	HotWireLevelScene *levelScene = [scene.children objectAtIndex:0];
	if (gameOver) {
		[levelScene showFailed];
	} else if (done) {
		[levelScene showSuccess];
	}
}

- (void)showLevelDone {
	if (!done) {
		levelDoneDisplay.scale = 0.0;
		[self showBlackBackground];
		BOOL globalAchievement = NO;
		BOOL localAchievement = NO;
		if ([[UserData instance] getCurrentLevelType] == kLevelTypeCompetition && [GameCenterClient instance].gameCenterAvailable) {
			globalAchievement = [[GameCenterClient instance] getPerfectlyArchievedForLevel:self.level];
			[[GameCenterClient instance] reportAchievementForLevel:self.level percentComplete:power];
			localAchievement = [[UserData instance] getLevelAchievment:self.level];
		}
		if (([[UserData instance] getCurrentLevelType] == kLevelTypeCompetition && [GameCenterClient instance].gameCenterAvailable) && 
			power == kPowerPercentMax && !localAchievement && !globalAchievement) {
			newAchievement = YES;
			[[UserData instance] setLevelAchievment:self.level];
			id fadeIn = [CCFadeIn actionWithDuration:0.5f];
			id scaleIn = [CCScaleTo actionWithDuration:0.5f scale:1.0];
			id moveBy = [CCMoveBy actionWithDuration:0.5f position:ccp(0, 40)];
			[levelDoneDisplay runAction:[CCSpawn actions:[CCEaseBackOut actionWithAction:scaleIn], moveBy, fadeIn, nil]];
			id fadeIn2 = [CCFadeIn actionWithDuration:0.5f];
			id scaleIn2 = [CCScaleTo actionWithDuration:0.5f scale:1.0];
			id moveBy2 = [CCMoveBy actionWithDuration:0.5f position:ccp(0, -40)];
			[aNewAchievementDisplay runAction:[CCSpawn actions:[CCEaseBackOut actionWithAction:scaleIn2], moveBy2, fadeIn2, nil]];
		} else {
			id fadeIn = [CCFadeIn actionWithDuration:0.5f];
			id scaleIn = [CCScaleTo actionWithDuration:0.5f scale:1.0];
			[levelDoneDisplay runAction:[CCSpawn actions:[CCEaseBackOut actionWithAction:scaleIn], fadeIn, nil]];
		}
		[[SoundManager instance] playOptionCloseTransitionSound];
		[self resetFingers];
		tesla1.paused = YES;
		tesla2.paused = YES;
		[pausePlayMenuItem setIsEnabled:NO];
		[menuMenuItem setIsEnabled:NO];
		highscore = YES;
	}
}

- (void)showHighscore {
	time = [Utilities getRoundedTime:time];
	id fadeOut = [CCFadeOut actionWithDuration:0.5f];
	id scaleOut = [CCScaleTo actionWithDuration:0.5f scale:0.0];
	[levelDoneDisplay runAction:[CCSpawn actions:[CCEaseBackIn actionWithAction:scaleOut], fadeOut, nil]];
	if (newAchievement) {
		id fadeOut2 = [CCFadeOut actionWithDuration:0.5f];
		id scaleOut2 = [CCScaleTo actionWithDuration:0.5f scale:0.0];
		[aNewAchievementDisplay runAction:[CCSpawn actions:[CCEaseBackIn actionWithAction:scaleOut2], fadeOut2, nil]];
	}
	id fadeIn = [CCFadeIn actionWithDuration:0.5f];
	id scaleIn = [CCScaleTo actionWithDuration:0.5f scale:1.0];
	id moveBy = [CCMoveBy actionWithDuration:0.5f position:ccp(0, 40)];
	BOOL global = NO;
	if ([[UserData instance] getCurrentLevelType] == kLevelTypeCompetition && [GameCenterClient instance].gameCenterAvailable) {
		double globalHighscore = [[GameCenterClient instance] getBestTimeForLevel:self.level];
		if (globalHighscore == 0 || time < globalHighscore) { 
			global = YES;
			[aNewHighscoreDisplay runAction:[CCSpawn actions:[CCEaseBackOut actionWithAction:scaleIn], moveBy, fadeIn, nil]];
		}
		[[GameCenterClient instance] reportScore:time forLevel:self.level];
	} 
	double localHighscore = [[UserData instance] getLevelHighscore:self.level];
	if (localHighscore == 0 || time < localHighscore) {
		[[UserData instance] setLevelHighscore:self.level withHighscore:time];
		if (!global) {
			[yourHighscoreDisplay runAction:[CCSpawn actions:[CCEaseBackOut actionWithAction:scaleIn], moveBy, fadeIn, nil]];
		}
	} else {
		if (!global) {
			[yourScoreDisplay runAction:[CCSpawn actions:[CCEaseBackOut actionWithAction:scaleIn], moveBy, fadeIn, nil]];
		}
	}
	id fadeIn2 = [CCFadeIn actionWithDuration:0.5f];
	id scaleIn2 = [CCScaleTo actionWithDuration:0.5f scale:1.0];
	id moveBy2 = [CCMoveBy actionWithDuration:0.5f position:ccp(0, -40)];
	[scoreLabel setString:[Utilities getTimeString:time]];
	[scoreBack runAction:[CCSpawn actions:[CCEaseBackOut actionWithAction:scaleIn2], moveBy2, fadeIn2, nil]];
	[[SoundManager instance] playOptionCloseTransitionSound];
	done = YES;
}

- (void)showGameOver:(BOOL)outsideWire {
	if (!gameOver) {		
		[[SoundManager instance] vibrate];
		gameOverDisplay.scale = 0.0;
		[self showBlackBackground];		
		id fadeIn = [CCFadeIn actionWithDuration:0.5f];
		id scaleIn = [CCScaleTo actionWithDuration:0.5f scale:1.0];
		id moveBy = [CCMoveBy actionWithDuration:0.5f position:ccp(0, -40)];
		if (outsideWire) {
			[outsideWireDisplay runAction:[CCSpawn actions:[CCEaseBackOut actionWithAction:scaleIn], moveBy, fadeIn, nil]];
		} else {
			[outOfPowerDisplay runAction:[CCSpawn actions:[CCEaseBackOut actionWithAction:scaleIn], moveBy, fadeIn, nil]];
		}
		id fadeIn2 = [CCFadeIn actionWithDuration:0.5f];
		id scaleIn2 = [CCScaleTo actionWithDuration:0.5f scale:1.0];
		id moveBy2 = [CCMoveBy actionWithDuration:0.5f position:ccp(0, 40)];
		[gameOverDisplay runAction:[CCSpawn actions:[CCEaseBackOut actionWithAction:scaleIn2], moveBy2, fadeIn2, nil]];
		[[SoundManager instance] playOptionCloseTransitionSound];
		[self resetFingers];
		tesla1.paused = YES;
		tesla2.paused = YES;
		[pausePlayMenuItem setIsEnabled:NO];
		[menuMenuItem setIsEnabled:NO];
		gameOver = YES;
	}
}

- (void)updateTilePositions {
	currentTilePos = ((Tile*)[[wireTileMap wireTiles] objectAtIndex:currentTileIndex]).position;
	if (currentTileIndex > 0) {
		previousTilePos = ((Tile*)[[wireTileMap wireTiles] objectAtIndex:currentTileIndex-1]).position;
	} else {
		previousTilePos = CGPointZero;
		nextTilePos = CGPointZero;
	}
	if (currentTileIndex > 1) {
		previous2TilePos = ((Tile*)[[wireTileMap wireTiles] objectAtIndex:currentTileIndex-2]).position;
	} else {
		previous2TilePos = CGPointZero;
		next2TilePos = CGPointZero;
	}
	if (currentTileIndex < [[wireTileMap wireTiles] count]-1) {
		nextTilePos = ((Tile*)[[wireTileMap wireTiles] objectAtIndex:currentTileIndex+1]).position;
	} else {

	}
	if (currentTileIndex < [[wireTileMap wireTiles] count]-2) {
		next2TilePos = ((Tile*)[[wireTileMap wireTiles] objectAtIndex:currentTileIndex+2]).position;
	} else {

	}
}

- (void)dealloc {
	[[TextureManager instance] unloadGame];
	[super dealloc];
}

@end
