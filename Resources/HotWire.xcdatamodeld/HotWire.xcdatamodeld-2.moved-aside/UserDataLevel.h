//
//  UserDataLevel.h
//  HotWireFree
//
//  Created by Oliver on 20.02.11.
//  Copyright 2011 SAP AG. All rights reserved.
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

@end



