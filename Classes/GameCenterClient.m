//
//  GameCenterClient.m
//  HotWire
//
//  Created by Oliver Klemenz on 11.02.11.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//
#import "GameCenterClient.h"
#import "HotWireAppDelegate.h"
#import "SoundManager.h"
#import "GameData.h"

@implementation GameCenterClient

@synthesize gameCenterAvailable, authenticated, authenticationErrors, gameCenterError, inAuthentication, playerAlias;

+ (GameCenterClient *)instance {
	static GameCenterClient *_instance;
	@synchronized(self) {
		if (!_instance) {
			_instance = [[GameCenterClient alloc] init];
		}
	}
	return _instance;
}

- (id)init {
	if ((self = [super init])) {
		for (int i = 0; i < kWireTileMapLevelCountCompetition; i++) {
			bestTimes[i] = -1.0;
		}
		for (int i = 0; i < kWireTileMapLevelCountCompetition; i++) {
			perfectLevel[i] = -1;
		}
		scoreReportErrors = [[NSMutableArray alloc] init];
		achievementReportErrors = [[NSMutableArray alloc] init];
		gameCenterError = NO;
	 	authenticated = NO;
		gameCenterAvailable = [self isGameCenterAvailable];
		if (gameCenterAvailable) {
			[self registerForAuthenticationNotification];
		}
	}
	return self;
}

- (BOOL)isGameCenterAvailable {
	Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
	NSString *reqSysVer = @"4.1";
	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
	BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
	return gcClass && osVersionSupported;
}

- (void)authenticateLocalPlayer:(BOOL)popup {
	if (gameCenterAvailable) {
		if (!authenticated && !inAuthentication && authenticationErrors < kAuthenticationErrorsMax) {
			inAuthentication = YES;
			[[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
				if (error != nil) {
					if (popup) {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Game Center" message:@"Error connecting to Game Center!" preferredStyle:UIAlertControllerStyleAlert];
                        
                        [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * _Nonnull action) {
                                                                    [[SoundManager instance] playMenu1ButtonSound];
                                                                }]];
                        
                        [[CCDirector sharedDirector].navigationController presentViewController:alert animated:YES completion:nil];
					}
					authenticationErrors++;
					authenticated = NO;
					gameCenterError = YES;
				} else {
					authenticationErrors = 0;
					authenticated = YES;
					playerAlias = [GKLocalPlayer localPlayer].alias;
					[self handleReportErrors];
					[self loadLevelHighscores];
					[self retrieveAchievements];
				}
				inAuthentication = NO;
			}];
		}
	}
}

- (void)loadLevelHighscores {
	for (int i = 0; i < kWireTileMapLevelCountCompetition; i++) {
		[self retrieveTopScoreForLevel:i+1];
	}
}

- (void)registerForAuthenticationNotification {
	if (gameCenterAvailable) {
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		[nc addObserver:self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
	}
}

- (void)authenticationChanged {
	if (gameCenterAvailable) {
		if ([GKLocalPlayer localPlayer].isAuthenticated) {
			[self handleReportErrors];
			authenticated = YES;
			playerAlias = [GKLocalPlayer localPlayer].alias;
		} else {
			authenticated = NO;
			playerAlias = @"";
		}
	}
}

- (void)reportScore:(double)time forLevel:(int)level {
	if (gameCenterAvailable) {
		[self handleReportErrors];
		double globalHighscore = [self getBestTimeForLevel:level];
		if (globalHighscore == 0 || time < globalHighscore) { 
			bestTimes[level-1] = time;
		}
		int64_t score = time * 100.0;
		NSString *category = [NSString stringWithFormat:@"Level%i", level];
		GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];
		if (scoreReporter) {
			scoreReporter.value = score;
			[scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
				if (error != nil) {
					[scoreReportErrors addObject:scoreReporter];
					gameCenterError	= YES;
					return;
				}
			}];
		}
	}
}

- (void)retrieveTopScoreForLevel:(int)level {
	if (gameCenterAvailable) {
		[self handleReportErrors];
		GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] init];
		if (leaderboardRequest != nil) {
			NSString *category = [NSString stringWithFormat:@"Level%i", level];
			leaderboardRequest.playerScope = GKLeaderboardPlayerScopeGlobal;
			leaderboardRequest.timeScope = GKLeaderboardTimeScopeAllTime;
			leaderboardRequest.range = NSMakeRange(1, 1);
			leaderboardRequest.category = category;
			[leaderboardRequest loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {
				if (error != nil) {	
					bestTimes[level-1] = -1.0;
					gameCenterError = YES;
					return;
				}
				if (scores != nil && [scores count] > 0) {
					GKScore *score = [scores objectAtIndex:0];
					bestTimes[level-1] = score.value / 100.0;
				} else {
					bestTimes[level-1] = 0;
				}
			}];
		}
	}
}

- (void)reportAchievementForLevel:(int)level percentComplete:(double)percent {
	if (gameCenterAvailable) {
		[self handleReportErrors];
		if (percent == 100.0) {
			perfectLevel[level-1] = 1;
		}
		NSString *identifier = [NSString stringWithFormat:@"Level%i", level];
		GKAchievement *achievement = [[[GKAchievement alloc] initWithIdentifier:identifier] autorelease];
		if (achievement) {
			achievement.percentComplete = percent;
			[achievement reportAchievementWithCompletionHandler:^(NSError *error) {
				 if (error != nil) {
					 [achievementReportErrors addObject:achievement];
					 gameCenterError = YES;
					 return;
				 }
			}];
		}
	}
}

- (void)retrieveAchievements {  
	if (gameCenterAvailable) {
		[self handleReportErrors];	
		[GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error) {
			if (error == nil && achievements != nil && [achievements count] > 0) {
				for (GKAchievement *achievement in achievements) {
					int level = [[achievement.identifier substringFromIndex:5] intValue];
					if (level >= 1 && level <= kWireTileMapLevelCountCompetition && perfectLevel[level-1] != 1) {
						perfectLevel[level-1] = achievement.completed ? 1 : 0;
					}
				}
			}
		}];
	}
}

- (void)showLeaderboard {
	[self showLeaderboardForLevel:1];
}

- (void)showLeaderboardForLevel:(int)level {
	if (gameCenterAvailable) {
		if (authenticated) {
			[self handleReportErrors];
			UIViewController *tempVC = [[UIViewController alloc] init];
			GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
			if (leaderboardController) {
				leaderboardController.leaderboardDelegate = self;
				NSString *category = [NSString stringWithFormat:@"Level%i", level];
				leaderboardController.category = category;
				[[[CCDirector sharedDirector] openGLView] addSubview:tempVC.view];
				[tempVC presentViewController:leaderboardController animated:YES completion:nil];
			}
			[leaderboardController release];
		} else {
			[self authenticateLocalPlayer:YES];
		}
	}
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController {
	[[SoundManager instance] playMenu1ButtonSound];
	[viewController dismissViewControllerAnimated:YES completion:nil];
	[viewController.view removeFromSuperview];
}

- (void)showAchievements {
	if (gameCenterAvailable) {
		if (authenticated) {
			[self handleReportErrors];
			UIViewController *tempVC = [[UIViewController alloc] init];
			GKAchievementViewController *achievementsController = [[GKAchievementViewController alloc] init];
			if (achievementsController) {
				achievementsController.achievementDelegate = self;
				[[[CCDirector sharedDirector] openGLView] addSubview:tempVC.view];				
				[tempVC presentViewController:achievementsController animated:YES completion:nil];
			}
			[achievementsController release];
		} else {
			[self authenticateLocalPlayer:NO];
		}
	}
}

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController {
	[[SoundManager instance] playMenu1ButtonSound];
	[viewController dismissViewControllerAnimated:YES completion:nil];
	[viewController.view removeFromSuperview];
}

- (void)handleReportErrors {
	if (gameCenterAvailable && authenticated) {
		if ([scoreReportErrors count] > 0) {
			for (GKScore *score in [NSMutableArray arrayWithArray:scoreReportErrors]) {
				[score reportScoreWithCompletionHandler:^(NSError *error) {
					if (error == nil) {
						[scoreReportErrors removeObject:score];
					}
				}];
			}
		}
		if ([achievementReportErrors count] > 0) {
			for (GKAchievement *achievement in [NSMutableArray arrayWithArray:achievementReportErrors]) {
				[achievement reportAchievementWithCompletionHandler:^(NSError *error) {
					if (error == nil) {
						[achievementReportErrors removeObject:achievement];
					}
				}];
			}
		}
	}
}

- (BOOL)isBestTimeAvailableForLevel:(int)level {
	return bestTimes[level-1] >= 0;
}

- (double)getBestTimeForLevel:(int)level {
	return bestTimes[level-1];
}

- (BOOL)isPerfectlyArchievedAvailableForLevel:(int)level {
	return perfectLevel[level-1] >= 0;
}

- (BOOL)getPerfectlyArchievedForLevel:(int)level {
	return perfectLevel[level-1] == 1;
}

- (void)dealloc {
	[scoreReportErrors release];
	[achievementReportErrors release];
	[super dealloc];
}

@end
