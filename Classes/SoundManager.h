//
//  SoundManager.h
//  HotWire
//
//  Created by Oliver Klemenz on 19.01.11.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDXPropertyModifierAction.h"
#import "cocos2d.h"
#import "UserData.h"

#define kBackgroundMusicNone           0
#define kBackgroundMusicMenu           1
#define kBackgroundMusicLevel          2
#define kBackgroundMusicDayThemeGame   3
#define kBackgroundMusicNightThemeGame 4

@interface SoundManager : NSObject {

	CDSoundSource* sparksSound;
	
	SimpleAudioEngine *soundEngine;
	CDXPropertyModifierAction* faderAction;
	CCActionManager *actionManager;
	
	UserData *userData;
	
	BOOL sparksSoundPlaying;
	int backgroundMusic;
	BOOL paused;
}

@property (nonatomic, retain, readonly) UserData *userData;

@property BOOL sparksSoundPlaying;
@property int backgroundMusic;
@property BOOL paused;

- (void)setBackgroundVolume:(float)volume;
- (void)setEffectVolume:(float)volume;

- (void)playSparksSound;
- (void)stopSparksSound;

- (void)vibrate;

- (void)playElectricitySound;
- (void)playMenuElectricitySound;
- (void)playSplashSound;
- (void)playErrorSound;
- (void)playMenu1ButtonSound;
- (void)playMenu2ButtonSound;
- (void)playToggleButtonSound;
- (void)playBackButtonSound;
- (void)playSceneTransitionSound;
- (void)playOptionOpenTransitionSound;
- (void)playOptionCloseTransitionSound;
- (void)playLevelChangeTransitionSound;
- (void)playBackTransitionSound;

- (void)playMenuBackgroundMusic;
- (void)playLevelBackgroundMusic;
- (void)playDayThemeGameBackgroundMusic;
- (void)playNightThemeGameBackgroundMusic;

- (void)pauseBackgroundMusic;
- (void)resumeBackgroundMusic;

+ (SoundManager *)instance;

@end
