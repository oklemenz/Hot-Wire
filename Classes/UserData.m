//
//  UserData.m
//  HotWire
//
//  Created by Oliver Klemenz on 19.01.11.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#import "UserData.h"
#import "SoundManager.h"
#import "HotWireLevelScene.h"
#import "GameData.h"

@implementation UserData

@synthesize context, data;

+ (UserData *)instance {
	static UserData *_instance;
	@synchronized(self) {
		if (!_instance) {
			_instance = [[UserData alloc] init];
		}
	}
	return _instance;
}

- (id)init {
	if ((self = [super init])) {
		
		context = [[HotWireAppDelegate instance] managedObjectContext];
		
		[self load];
		
		if (!data) {
			[self reset];
		}
	}
	return self;
}

- (void)setup {
}

- (void)load {
	NSError *error;
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"General" inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	for (data in fetchedObjects) {
		break;
	}
	[data retain];
	[fetchRequest release];
}

- (void)reload {
	if (data) {
		[data release];
	}
	[self load];
}

- (void)reset {
	data = [NSEntityDescription insertNewObjectForEntityForName:@"General" inManagedObjectContext:context];
	[data retain];
	data.music = [NSNumber numberWithBool:YES];
	data.sound = [NSNumber numberWithBool:YES];
	data.vibration = [NSNumber numberWithBool:NO];
	data.grid = [NSNumber numberWithBool:NO];
	data.theme = [NSNumber numberWithInt:0];
	data.difficulty = [NSNumber numberWithInt:1];
	data.currentLevelType = [NSNumber numberWithInt:1];
	data.currentLevelTraining = [NSNumber numberWithInt:1];
	data.currentLevelCompetition = [NSNumber numberWithInt:1];
	for (int i = 0; i < kWireTileMapLevelCountTraining; i++) {
		int level = i+1;
		[self createTrainingLevel:level withWireID:@"" andDifficulty:1];
	}
	for (int i = 0; i < kWireTileMapLevelCountCompetition; i++) {
		int level = i+1;
		[self createCompetitionLevel:level withWireID:@"" andDifficulty:1];
	}
}

- (void)store {
	[appDelegate saveContext];
}

- (void)setMusic:(BOOL)state {
	data.music = [NSNumber numberWithBool:state];
	if (state) {
		[[SoundManager instance] playMenuBackgroundMusic];
	} else {
		[[SoundManager instance] pauseBackgroundMusic];
	}
}

- (void)setSound:(BOOL)state {
	data.sound = [NSNumber numberWithBool:state];
}

- (void)setVibration:(BOOL)state {
	data.vibration = [NSNumber numberWithBool:state];
}

- (void)setGrid:(BOOL)state {
	data.grid = [NSNumber numberWithBool:state];
}

- (void)setTheme:(int)theme {
	data.theme = [NSNumber numberWithBool:theme];
}

- (void)setCurrentLevelType:(int)type {
	data.currentLevelType = [NSNumber numberWithInteger:type];
}

- (void)setCurrentLevelTraining:(int)level {
	data.currentLevelTraining = [NSNumber numberWithInteger:level];
}

- (void)setCurrentLevelCompetition:(int)level {
	data.currentLevelCompetition = [NSNumber numberWithInteger:level];
}

- (void)setCurrentLevel:(int)level {
	if ([self getCurrentLevelType] == kLevelTypeTraining) {
		[self setCurrentLevelTraining:level];
	} else if ([self getCurrentLevelType] == kLevelTypeCompetition) {
		[self setCurrentLevelCompetition:level];
	}
}
- (void)setDifficulty:(int)difficulty {
	data.difficulty = [NSNumber numberWithInteger:difficulty];
}

- (BOOL)getMusic {
	return [data.music boolValue];
}

- (BOOL)getSound {
	return [data.sound boolValue];
}

- (BOOL)getVibration {
	return [data.vibration boolValue];
}

- (BOOL)getGrid {
	return [data.grid boolValue];
}

- (int)getTheme {
	return [data.theme intValue];
}

- (int)getCurrentLevelType {
	return [data.currentLevelType intValue];
}

- (int)getCurrentLevelTraining {
	return [data.currentLevelTraining intValue];
}

- (int)getCurrentLevelCompetition {
	return [data.currentLevelCompetition intValue];
}

- (int)getCurrentLevel {
	if ([self getCurrentLevelType] == kLevelTypeTraining) {
		return [self getCurrentLevelTraining];
	} else if ([self getCurrentLevelType] == kLevelTypeCompetition) {
		return [self getCurrentLevelCompetition];
	}
	return 0;
}

- (int)getDifficulty {
	return [data.difficulty intValue];
}

- (UserDataLevel *)getTrainingLevel:(int)level {
	for (UserDataLevel *levelData in [data trainingLevels]) {
		if ([levelData.number intValue] == level) {
			return levelData;
		}
	}
	return nil;
}

- (UserDataLevel *)getCompetitionLevel:(int)level {
	for (UserDataLevel *levelData in [data competitionLevels]) {
		if ([levelData.number intValue] == level) {
			return levelData;
		}
	}
	return nil;
}

- (UserDataLevel *)getLevel:(int)level {
	if ([self getCurrentLevelType] == kLevelTypeTraining) {
		return [self getTrainingLevel:level];
	} else if ([self getCurrentLevelType] == kLevelTypeCompetition) {
		return [self getCompetitionLevel:level];
	}
	return nil;
}

- (UserDataLevel *)createTrainingLevel:(int)level withWireID:(NSString *)wireId andDifficulty:(int)difficulty {
	UserDataLevel *newLevel = [NSEntityDescription insertNewObjectForEntityForName:@"Level" inManagedObjectContext:context];
	newLevel.number = [NSNumber numberWithInt:level];
	newLevel.wireId = wireId;
	newLevel.difficulty = [NSNumber numberWithInt:difficulty];
	newLevel.locked = [NSNumber numberWithBool:level > 1];
	newLevel.failed = [NSNumber numberWithBool:NO];
	newLevel.success = [NSNumber numberWithBool:NO];
	newLevel.highscore = [NSNumber numberWithDouble:0];
	newLevel.achievement = [NSNumber numberWithBool:NO];
	[data addTrainingLevelsObject:newLevel];
	return newLevel;
}

- (UserDataLevel *)createCompetitionLevel:(int)level withWireID:(NSString *)wireId andDifficulty:(int)difficulty {
	UserDataLevel *newLevel = [NSEntityDescription insertNewObjectForEntityForName:@"Level" inManagedObjectContext:context];
	newLevel.number = [NSNumber numberWithInt:level];
	newLevel.wireId = wireId;
	newLevel.difficulty = [NSNumber numberWithInt:difficulty];
	newLevel.locked = [NSNumber numberWithBool:level > 1];
	newLevel.failed = [NSNumber numberWithBool:NO];
	newLevel.success = [NSNumber numberWithBool:NO];
	newLevel.highscore = [NSNumber numberWithDouble:0];
	newLevel.achievement = [NSNumber numberWithBool:NO];
	[data addCompetitionLevelsObject:newLevel];
	return newLevel;
}

- (double)getTrainingLevelHighscore:(int)level {
	return [[self getTrainingLevel:level].highscore doubleValue];
}

- (double)getCompetitionLevelHighscore:(int)level {
	return [[self getCompetitionLevel:level].highscore doubleValue];
}

- (double)getLevelHighscore:(int)level {
	if ([self getCurrentLevelType] == kLevelTypeTraining) {
		return [self getTrainingLevelHighscore:level];
	} else if ([self getCurrentLevelType] == kLevelTypeCompetition) {
		return [self getCompetitionLevelHighscore:level];
	}
	return 0;
}

- (void)clearTrainingLevelHighscore:(int)level {
	return [self setTrainingLevelHighscore:level withHighscore:0];
}

- (void)clearCompetitionLevelHighscore:(int)level {
	return [self setCompetitionLevelHighscore:level withHighscore:0];
}

- (void)clearLevelHighscore:(int)level {
	if ([self getCurrentLevelType] == kLevelTypeTraining) {
		[self clearTrainingLevelHighscore:level];
	} else if ([self getCurrentLevelType] == kLevelTypeCompetition) {
		[self clearCompetitionLevelHighscore:level];
	}
}

- (void)setTrainingLevelHighscore:(int)level withHighscore:(double)highscore {
	for (UserDataLevel *dataLevel in data.trainingLevels) {
		if ([dataLevel.number intValue] == level) {
			dataLevel.highscore = [NSNumber numberWithDouble:highscore];
			break;
		}
	}
}

- (void)setCompetitionLevelHighscore:(int)level withHighscore:(double)highscore {
	for (UserDataLevel *dataLevel in data.competitionLevels) {
		if ([dataLevel.number intValue] == level) {
			dataLevel.highscore = [NSNumber numberWithDouble:highscore];
			break;
		}
	}
}

- (void)setLevelHighscore:(int)level withHighscore:(double)highscore {
	if ([self getCurrentLevelType] == kLevelTypeTraining) {
		[self setTrainingLevelHighscore:level withHighscore:highscore];
	} else if ([self getCurrentLevelType] == kLevelTypeCompetition) {
		[self setCompetitionLevelHighscore:level withHighscore:highscore];
	}	
}

- (BOOL)getCompetitionAchievement:(int)level {
	return [[self getCompetitionLevel:level].achievement boolValue];
}

- (BOOL)getLevelAchievment:(int)level {
	return [self getCompetitionAchievement:level];
}

- (void)setCompetitionAchievement:(int)level {
	for (UserDataLevel *dataLevel in data.competitionLevels) {
		if ([dataLevel.number intValue] == level) {
			dataLevel.achievement = [NSNumber numberWithBool:YES];
			break;
		}
	}
}

- (void)setLevelAchievment:(int)level {
	[self setCompetitionAchievement:level];
}

- (int)getTrainingLevelIconBadge:(int)level {
	UserDataLevel *dataLevel = [self getTrainingLevel:level];
	if ([dataLevel.locked boolValue]) {
		return kLevelIconBadgeLock;
	} else if ([dataLevel.success boolValue]) {
		return kLevelIconBadgeCheck;
	} else if ([dataLevel.failed boolValue]) {
		return kLevelIconBadgeCross;
	}
	return kLevelIconBadgeNone;
}

- (int)getCompetitionLevelIconBadge:(int)level {
	UserDataLevel *dataLevel = [self getCompetitionLevel:level];
	if ([dataLevel.locked boolValue]) {
		return kLevelIconBadgeLock;
	} else if ([dataLevel.success boolValue]) {
		return kLevelIconBadgeCheck;
	} else if ([dataLevel.failed boolValue]) {
		return kLevelIconBadgeCross;
	}
	return kLevelIconBadgeNone;
}

- (int)getLevelIconBadge:(int)level {
	if ([self getCurrentLevelType] == kLevelTypeTraining) {
		return [self getTrainingLevelIconBadge:level];
	} else if ([self getCurrentLevelType] == kLevelTypeCompetition) {
		return [self getCompetitionLevelIconBadge:level];
	}	
	return kLevelIconBadgeNone;
}

- (void)setTrainingIconBadge:(int)level andBadge:(int)badge {
	UserDataLevel *dataLevel = [self getTrainingLevel:level];
	if (badge == kLevelIconBadgeLock) {
		dataLevel.locked = [NSNumber numberWithBool:YES];
		dataLevel.success = [NSNumber numberWithBool:NO];
		dataLevel.failed = [NSNumber numberWithBool:NO];
	} else if (badge == kLevelIconBadgeCheck) {
		dataLevel.success = [NSNumber numberWithBool:YES];
	} else if (badge == kLevelIconBadgeCross) {
		dataLevel.failed = [NSNumber numberWithBool:YES];
	} else if (badge == kLevelIconBadgeNone) {
		dataLevel.locked = [NSNumber numberWithBool:NO];
		dataLevel.success = [NSNumber numberWithBool:NO];
		dataLevel.failed = [NSNumber numberWithBool:NO];		
	}
}

- (void)setCompetitionIconBadge:(int)level andBadge:(int)badge {
	UserDataLevel *dataLevel = [self getCompetitionLevel:level];
	if (badge == kLevelIconBadgeLock) {
		dataLevel.locked = [NSNumber numberWithBool:YES];
		dataLevel.success = [NSNumber numberWithBool:NO];
		dataLevel.failed = [NSNumber numberWithBool:NO];
	} else if (badge == kLevelIconBadgeCheck) {
		dataLevel.success = [NSNumber numberWithBool:YES];
	} else if (badge == kLevelIconBadgeCross) {
		dataLevel.failed = [NSNumber numberWithBool:YES];
	} else if (badge == kLevelIconBadgeNone) {
		dataLevel.locked = [NSNumber numberWithBool:NO];
		dataLevel.success = [NSNumber numberWithBool:NO];
		dataLevel.failed = [NSNumber numberWithBool:NO];		
	}
}

- (void)setLevelIconBadge:(int)level andBadge:(int)badge {
	if ([self getCurrentLevelType] == kLevelTypeTraining) {
		[self setTrainingIconBadge:level andBadge:badge];
	} else if ([self getCurrentLevelType] == kLevelTypeCompetition) {
		[self setCompetitionIconBadge:level andBadge:badge];
	}		
}

- (void)dealloc {
	[data release];
	[super dealloc];
}

@end
