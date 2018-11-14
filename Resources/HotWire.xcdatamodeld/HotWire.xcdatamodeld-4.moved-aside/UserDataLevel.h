//
//  UserDataLevel.h
//  HotWire
//
//  Created by Oliver on 01.03.11.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface UserDataLevel :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSString * wireId;
@property (nonatomic, retain) NSNumber * failed;
@property (nonatomic, retain) NSNumber * locked;
@property (nonatomic, retain) NSNumber * success;
@property (nonatomic, retain) NSNumber * highscore;
@property (nonatomic, retain) NSNumber * difficulty;
@property (nonatomic, retain) NSNumber * achievement;

@end



