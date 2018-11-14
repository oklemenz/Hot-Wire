//
//  UserData.h
//  HotWire
//
//  Created by Oliver Klemenz on 19.01.11.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#define kLevelIconBadgeNone  0
#define kLevelIconBadgeCheck 1
#define kLevelIconBadgeCross 2
#define kLevelIconBadgeLock  3
#define kLevelIconBadgeStar  4

#import <Foundation/Foundation.h>
#import "HotWireAppDelegate.h"
#import "UserDataGeneral.h"
#import "UserDataLevel.h"
#import "CoreData/CoreData.h"

@interface UserData : NSObject {

	HotWireAppDelegate *appDelegate;
	NSManagedObjectContext *context;
	UserDataGeneral *data;
 
}

@property (nonatomic, retain, readonly) UserDataGeneral *data;
@property (nonatomic, retain, readonly) NSManagedObjectContext *context;

- (void)setup;
- (void)load;
- (void)reload;
- (void)reset;
- (void)store;

- (void)setMusic:(BOOL)state;
- (void)setSound:(BOOL)state;
- (void)setVibration:(BOOL)state;
- (void)setGrid:(BOOL)state;
- (void)setTheme:(int)theme;
- (void)setCurrentLevelType:(int)type;
- (void)setCurrentLevelTraining:(int)level;
- (void)setCurrentLevelCompetition:(int)level;
- (void)setCurrentLevel:(int)level;
- (void)setDifficulty:(int)difficulty;

- (BOOL)getMusic;
- (BOOL)getSound;
- (BOOL)getVibration;
- (BOOL)getGrid;
- (int)getTheme;
- (int)getCurrentLevelType;
- (int)getCurrentLevelTraining;
- (int)getCurrentLevelCompetition;
- (int)getCurrentLevel;
- (int)getDifficulty;

- (UserDataLevel *)getTrainingLevel:(int)level;
- (UserDataLevel *)getCompetitionLevel:(int)level;
- (UserDataLevel *)getLevel:(int)level;

- (UserDataLevel *)createTrainingLevel:(int)level withWireID:(NSString *)wireId andDifficulty:(int)difficulty;
- (UserDataLevel *)createCompetitionLevel:(int)level withWireID:(NSString *)wireId andDifficulty:(int)difficulty;

- (double)getTrainingLevelHighscore:(int)level;
- (double)getCompetitionLevelHighscore:(int)level;
- (double)getLevelHighscore:(int)level;

- (void)clearTrainingLevelHighscore:(int)level;
- (void)clearCompetitionLevelHighscore:(int)level;
- (void)clearLevelHighscore:(int)level;

- (void)setTrainingLevelHighscore:(int)level withHighscore:(double)highscore;
- (void)setCompetitionLevelHighscore:(int)level withHighscore:(double)highscore;
- (void)setLevelHighscore:(int)level withHighscore:(double)highscore;

- (BOOL)getCompetitionAchievement:(int)level;
- (BOOL)getLevelAchievment:(int)level;

- (void)setCompetitionAchievement:(int)level;
- (void)setLevelAchievment:(int)level;

- (int)getTrainingLevelIconBadge:(int)level;
- (int)getCompetitionLevelIconBadge:(int)level;
- (int)getLevelIconBadge:(int)level;

- (void)setTrainingIconBadge:(int)level andBadge:(int)badge;
- (void)setCompetitionIconBadge:(int)level andBadge:(int)badge;
- (void)setLevelIconBadge:(int)level andBadge:(int)badge;

+ (UserData *)instance;

@end
