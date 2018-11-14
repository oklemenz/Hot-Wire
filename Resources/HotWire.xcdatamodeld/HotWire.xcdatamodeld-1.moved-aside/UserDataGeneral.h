//
//  UserDataGeneral.h
//  HotWire
//
//  Created by Oliver on 06.02.11.
//  Copyright 2011 SAP AG. All rights reserved.
//

#import <CoreData/CoreData.h>

@class UserDataLevel;

@interface UserDataGeneral :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSNumber * theme;
@property (nonatomic, retain) NSNumber * sound;
@property (nonatomic, retain) NSNumber * music;
@property (nonatomic, retain) NSNumber * grid;
@property (nonatomic, retain) NSNumber * vibration;
@property (nonatomic, retain) NSNumber * currentLevelCompetition;
@property (nonatomic, retain) NSNumber * currentLevelType;
@property (nonatomic, retain) NSNumber * difficulty;
@property (nonatomic, retain) NSNumber * currentLevelTraining;
@property (nonatomic, retain) NSSet* trainingLevels;
@property (nonatomic, retain) NSSet* competitionLevels;

@end


@interface UserDataGeneral (CoreDataGeneratedAccessors)
- (void)addTrainingLevelsObject:(UserDataLevel *)value;
- (void)removeTrainingLevelsObject:(UserDataLevel *)value;
- (void)addTrainingLevels:(NSSet *)value;
- (void)removeTrainingLevels:(NSSet *)value;

- (void)addCompetitionLevelsObject:(UserDataLevel *)value;
- (void)removeCompetitionLevelsObject:(UserDataLevel *)value;
- (void)addCompetitionLevels:(NSSet *)value;
- (void)removeCompetitionLevels:(NSSet *)value;

@end

