//
//  HotWireAppDelegate.m
//  HotWire
//
//  Created by Oliver Klemenz on 12.11.10.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#import "HotWireAppDelegate.h"
#import "cocos2d.h"
#import "HotWireCopyrightScene.h"
#import "HotWireLevelScene.h"
#import "HotWireGameScene.h"
#import "UserData.h"
#import "SoundManager.h"
#import "TextureManager.h"
#import "GameData.h"

@implementation HotWireAppDelegate

@synthesize window, game;

static BOOL isIPhone = YES;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Main Window
    window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Director
    director_ = (CCDirectorIOS*)[CCDirector sharedDirector];
    [director_ setDisplayStats:NO];
    [director_ setAnimationInterval:1.0/60];
    [director_.view setMultipleTouchEnabled:YES];
    
    // GL View
    CCGLView *__glView = [CCGLView viewWithFrame:[window_ bounds]
                                     pixelFormat:kEAGLColorFormatRGB565
                                     depthFormat:0 /* GL_DEPTH_COMPONENT24_OES */
                              preserveBackbuffer:NO
                                      sharegroup:nil
                                   multiSampling:NO
                                 numberOfSamples:0
                          ];
    
    [director_ setView:__glView];
    [director_ setDelegate:self];
    director_.wantsFullScreenLayout = YES;
    [director_ enableRetinaDisplay:NO];
    
    // Navigation Controller
    navController_ = [[UINavigationController alloc] initWithRootViewController:director_];
    navController_.navigationBarHidden = YES;
    
    // Set it as the root VC
    [window_ setRootViewController:navController_];
    
    [window_ makeKeyAndVisible];
	
	NSString *model = [[UIDevice currentDevice] model];
	if ([model rangeOfString:@"iPhone" options:NSCaseInsensitiveSearch].location == NSNotFound) {
		isIPhone = NO;
	}
        
	[SoundManager instance];
	[GameData instance];
	[[UserData instance] setup];
    
	[director_ pushScene: [HotWireCopyrightScene scene]];
    
    return YES;
}

- (void)saveContext {
    
    NSError *error = nil;
	NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}    


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext_ != nil) {
        return managedObjectContext_;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext_ = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"HotWire" ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return managedObjectModel_;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"HotWire.sqlite"];
    
    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
		[[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
	    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 
			 Typical reasons for an error here include:
			 * The persistent store is not accessible;
			 * The schema for the persistent store is incompatible with current managed object model.
			 Check the error message to determine what the actual problem was.
			 
			 
			 If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
			 
			 If you encounter schema incompatibility errors during development, you can reduce their frequency by:
			 * Simply deleting the existing store:
			 [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
			 
			 * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
			 [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
			 
			 Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
			 
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
    }    
    
    return persistentStoreCoordinator_;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
	if (game) {
		[game setPauseMode];
	}
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	if (!game) {
		[[CCDirector sharedDirector] resume];
	} else {
		[game resumeGame];
	}
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
	[self saveContext];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[UserData instance] reload];
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[[CCDirector sharedDirector] end];
	[self saveContext];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}

+ (HotWireAppDelegate *)instance {
	return (HotWireAppDelegate *)[[UIApplication sharedApplication] delegate];
}

+ (BOOL)isIPhone {
	return isIPhone;
}

@end
