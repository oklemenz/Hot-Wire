//
//  HotWireOptions.h
//  HotWire
//
//  Created by Oliver Klemenz on 20.01.11.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class HotWireMenuScene;

@interface HotWireOptions : CCLayer <CCRGBAProtocol> {

	HotWireMenuScene *menuScene;
	CCMenuItemToggle *musicMenuItem;
	CCMenuItemToggle *soundMenuItem;
	CCMenuItemToggle *vibrationMenuItem;
	CCMenuItemToggle *gridMenuItem;
	
	GLubyte	opacity_;
	ccColor3B color_;
}

@property (nonatomic, retain) HotWireMenuScene *menuScene;
@property (nonatomic, retain) CCMenuItemToggle *musicMenuItem;
@property (nonatomic, retain) CCMenuItemToggle *soundMenuItem;
@property (nonatomic, retain) CCMenuItemToggle *vibrationMenuItem;
@property (nonatomic, retain) CCMenuItemToggle *gridMenuItem;

@property (nonatomic) GLubyte opacity;
@property (nonatomic) ccColor3B color;

- (void)switchButtons:(BOOL)state;

- (void)showOptions:(HotWireMenuScene *)aMenuScene;
- (void)music:(CCMenuItem *)menuItem;
- (void)sound:(CCMenuItem *)menuItem;
- (void)vibration:(CCMenuItem *)menuItem;
- (void)grid:(CCMenuItem *)menuItem;
- (void)hideOptions:(CCMenuItem *)menuItem;

@end
