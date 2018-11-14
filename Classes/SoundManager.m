//
//  SoundManager.m
//  HotWire
//
//  Created by Oliver Klemenz on 19.01.11.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#import "SoundManager.h"
#import "HotWireAppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation SoundManager

@synthesize sparksSoundPlaying, backgroundMusic, userData, paused;

+ (SoundManager *)instance {
	static SoundManager *_instance;
	@synchronized(self) {
		if (!_instance) {
			_instance = [[SoundManager alloc] init];
		}
	}
	return _instance;
}

- (id)init {
	if ((self = [super init])) {
		userData = [UserData instance];

		soundEngine = [SimpleAudioEngine sharedEngine];
		[[CDAudioManager sharedManager] setResignBehavior:kAMRBStopPlay autoHandle:YES];
		actionManager = [CCActionManager sharedManager];
		
		[soundEngine preloadBackgroundMusic:@"menu.caf"];
		[soundEngine preloadBackgroundMusic:@"level.caf"];
		[soundEngine preloadBackgroundMusic:@"night_theme.caf"];
		[soundEngine preloadBackgroundMusic:@"day_theme.caf"];
		
		if (soundEngine.willPlayBackgroundMusic) {
			soundEngine.backgroundMusicVolume = 0.5f;
		}
		soundEngine.effectsVolume = 1.0f;

		[soundEngine preloadEffect:@"sparks.caf"];
		[soundEngine preloadEffect:@"electricity.caf"];
		[soundEngine preloadEffect:@"menu_electricity.caf"];
		[soundEngine preloadEffect:@"splash.caf"];
		[soundEngine preloadEffect:@"error.caf"];
		[soundEngine preloadEffect:@"button_click1.caf"];
		[soundEngine preloadEffect:@"button_click2.caf"];
		[soundEngine preloadEffect:@"button_click3.caf"];
		[soundEngine preloadEffect:@"button_click4.caf"];
		[soundEngine preloadEffect:@"transition1.caf"];
		[soundEngine preloadEffect:@"transition2.caf"];
		[soundEngine preloadEffect:@"transition3.caf"];
		[soundEngine preloadEffect:@"transition4.caf"];
		[soundEngine preloadEffect:@"transition5.caf"];
		
		sparksSound = [[soundEngine soundSourceForFile:@"sparks.caf"] retain];
		sparksSound.gain = 0.0f;
	}
	return self;
}

- (void)setBackgroundVolume:(float)volume {
	if (soundEngine.willPlayBackgroundMusic) {
		soundEngine.backgroundMusicVolume = volume;
	}
}

- (void)setEffectVolume:(float)volume {
	soundEngine.effectsVolume = volume;
}

- (void)playSparksSound {
	if ([userData getSound] && !sparksSoundPlaying) {
		[[CCActionManager sharedManager] removeAllActionsFromTarget:sparksSound];
		sparksSound.looping = YES;
		[sparksSound play];
		[CDXPropertyModifierAction fadeSoundEffect:0.25f finalVolume:1.0f curveType:kIT_Linear shouldStop:NO effect:sparksSound];
		sparksSoundPlaying = YES;
	}
}

- (void)stopSparksSound {
	if ([userData getSound] && sparksSoundPlaying) {
		[[CCActionManager sharedManager] removeAllActionsFromTarget:sparksSound];
		[CDXPropertyModifierAction fadeSoundEffect:0.5f finalVolume:0.0f curveType:kIT_Linear shouldStop:YES effect:sparksSound];
		sparksSoundPlaying = NO;
	}
}

- (void)vibrate {
	if ([HotWireAppDelegate isIPhone] && [userData getVibration]) {
		AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);		
	}
}

- (void)playElectricitySound {
	if ([userData getSound]) {
		[soundEngine playEffect:@"electricity.caf"];	
	}
}

- (void)playMenuElectricitySound {
	if ([userData getSound]) {
		[soundEngine playEffect:@"menu_electricity.caf"];	
	}
}

- (void)playSplashSound {
	if ([userData getSound]) {
		[soundEngine playEffect:@"splash.caf"];	
	}
}

- (void)playErrorSound {
	if ([userData getSound]) {
		[soundEngine playEffect:@"error.caf"];	
	}
}

- (void)playMenu1ButtonSound {
	if ([userData getSound]) {
		[soundEngine playEffect:@"button_click3.caf"];	
	}
}

- (void)playMenu2ButtonSound {
	if ([userData getSound]) {
		[soundEngine playEffect:@"button_click2.caf"];	
	}
}

- (void)playToggleButtonSound {
	if ([userData getSound]) {
		[soundEngine playEffect:@"button_click1.caf"];	
	}	
}

- (void)playBackButtonSound {
	if ([userData getSound]) {
		[soundEngine playEffect:@"button_click4.caf"];	
	}
}

- (void)playSceneTransitionSound {
	if ([userData getSound]) {
		[soundEngine playEffect:@"transition5.caf"];	
	}
}

- (void)playOptionOpenTransitionSound {
	if ([userData getSound]) {
		[soundEngine playEffect:@"transition3.caf"];	
	}
}

- (void)playOptionCloseTransitionSound {
	if ([userData getSound]) {
		[soundEngine playEffect:@"transition4.caf"];	
	}
}

- (void)playLevelChangeTransitionSound {
	if ([userData getSound]) {
		[soundEngine playEffect:@"transition1.caf"];	
	}
}

- (void)playBackTransitionSound {
	if ([userData getSound]) {
		[soundEngine playEffect:@"transition2.caf"];	
	}
}

- (void)playMenuBackgroundMusic {
	if ([userData getMusic]) {
		if (backgroundMusic == kBackgroundMusicMenu) {
			[self resumeBackgroundMusic];
		} else {
			[soundEngine stopBackgroundMusic];
			[soundEngine playBackgroundMusic:@"menu.caf"];	
			backgroundMusic = kBackgroundMusicMenu;
		}
	}
}

- (void)playLevelBackgroundMusic {
	if ([userData getMusic]) {
		if (backgroundMusic == kBackgroundMusicLevel) {
			[self resumeBackgroundMusic];
		} else {
			[soundEngine stopBackgroundMusic];
			[soundEngine playBackgroundMusic:@"level.caf"];	
			backgroundMusic = kBackgroundMusicLevel;
		}
	}
	
}

- (void)playDayThemeGameBackgroundMusic {
	if ([userData getMusic]) {
		if (backgroundMusic == kBackgroundMusicDayThemeGame) {
			[self resumeBackgroundMusic];
		} else {
			[soundEngine stopBackgroundMusic];
			[soundEngine playBackgroundMusic:@"day_theme.caf"];	
			backgroundMusic = kBackgroundMusicDayThemeGame;
		}
	}
}

- (void)playNightThemeGameBackgroundMusic {
	if ([userData getMusic]) {
		if (backgroundMusic == kBackgroundMusicNightThemeGame) {
			[self resumeBackgroundMusic];
		} else {
			[soundEngine stopBackgroundMusic];
			[soundEngine playBackgroundMusic:@"night_theme.caf"];	
			backgroundMusic = kBackgroundMusicNightThemeGame;
		}
	}
}

- (void)pauseBackgroundMusic {
	if (!paused) {
		[soundEngine pauseBackgroundMusic];
		paused = YES;
	}
}

- (void)resumeBackgroundMusic {
	if (paused) {
		[soundEngine resumeBackgroundMusic];
		paused = NO;
	}
}

-(void) dealloc {
	[actionManager removeAllActionsFromTarget:sparksSound];
	[actionManager removeAllActionsFromTarget:[[CDAudioManager sharedManager] audioSourceForChannel:kASC_Left]];
	[actionManager removeAllActionsFromTarget:[CDAudioManager sharedManager].soundEngine];
	[sparksSound release];
	[SimpleAudioEngine end];
	soundEngine = nil;
	[super dealloc];
}	

@end
