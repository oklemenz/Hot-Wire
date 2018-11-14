//
//  HotWireAppDelegate.h
//  HotWire
//
//  Created by Oliver Klemenz on 12.11.10.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreData/CoreData.h"
#import "cocos2d.h"

@class HotWireGameScene;

@interface HotWireAppDelegate : NSObject <UIApplicationDelegate, CCDirectorDelegate> {
	UIWindow *window_;
    UINavigationController *navController_;
    CCDirectorIOS *director_;
    
	HotWireGameScene *game;
	
@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;
@property (nonatomic, retain) HotWireGameScene* game;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;

+ (HotWireAppDelegate *)instance;

+ (BOOL)isIPhone;

@end
