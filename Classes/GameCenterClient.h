//
//  GameCenterClient.h
//  HotWire
//
//  Created by Oliver Klemenz on 11.02.11.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#define kAuthenticationErrorsMax 3

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"

@interface GameCenterClient : NSObject <UIApplicationDelegate, GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate> {
	double bestTimes[25];
	int perfectLevel[25];
	
	NSMutableArray *scoreReportErrors;
	NSMutableArray *achievementReportErrors;

	BOOL gameCenterAvailable;
	BOOL authenticated;
	int authenticationErrors;
	BOOL gameCenterError;
	BOOL inAuthentication;
	
	NSString *playerAlias;
}

@property BOOL gameCenterAvailable;
@property BOOL authenticated;
@property int authenticationErrors;
@property BOOL gameCenterError;
@property BOOL inAuthentication;

@property (nonatomic, retain, readonly) NSString *playerAlias;

+ (GameCenterClient *)instance;

- (BOOL)isGameCenterAvailable;
- (void)authenticateLocalPlayer:(BOOL)popup;
- (void)loadLevelHighscores;
- (void)registerForAuthenticationNotification;
- (void)authenticationChanged;

- (void)reportScore:(double)time forLevel:(int)level;
- (void)retrieveTopScoreForLevel:(int)level;
- (void)reportAchievementForLevel:(int)level percentComplete:(double)percent;
- (void)retrieveAchievements;
	
- (void)showLeaderboard;
- (void)showLeaderboardForLevel:(int)level;
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController;
- (void)showAchievements;
- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController;

- (void)handleReportErrors;

- (BOOL)isBestTimeAvailableForLevel:(int)level;
- (double)getBestTimeForLevel:(int)level;
- (BOOL)isPerfectlyArchievedAvailableForLevel:(int)level;
- (BOOL)getPerfectlyArchievedForLevel:(int)level;

@end
