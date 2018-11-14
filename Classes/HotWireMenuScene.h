//
//  HotWireMenuScene.h
//  HotWire
//
//  Created by Oliver Klemenz on 02.01.11.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class HotWireOptions;
@class HotWirePlaySelect;
@class HotWireGameCenterSelect;

@interface HotWireMenuScene : CCLayer {
	CCSprite *retroSun;

	CCSprite *moonRotate;
	CCSprite *sunRotate;

	CCSprite *lightning1;
	CCSprite *lightning2;
	
	CGPoint moonPosition;	
	CGPoint sunPosition;
	CGFloat currentAngle;

	CCMenuItemToggle *themeMenuItem;
	HotWireOptions *options;
	HotWirePlaySelect *playSelect;
	HotWireGameCenterSelect *gameCenterSelect;
}

@property(nonatomic, retain) CCSprite *retroSun;
@property(nonatomic, retain) CCSprite *moonRotate;
@property(nonatomic, retain) CCSprite *sunRotate;
@property(nonatomic, retain) CCSprite *lightning1;
@property(nonatomic, retain) CCSprite *lightning2;

@property CGPoint moonPosition;
@property CGPoint sunPosition;
@property CGFloat currentAngle;

@property (nonatomic, retain) CCMenuItemToggle *themeMenuItem;
@property (nonatomic, retain) HotWireOptions *options;
@property (nonatomic, retain) HotWirePlaySelect *playSelect;
@property (nonatomic, retain) HotWireGameCenterSelect *gameCenterSelect;

- (void)update:(ccTime)dt;

- (void)electricity:(id)sender;
- (void)switchButtons:(BOOL)state;

- (void)help:(CCMenuItem *)menuItem;
- (void)options:(CCMenuItem *)menuItem;
- (void)optionsClosed;
- (void)theme:(CCMenuItem *)menuItem;

- (void)play:(CCMenuItem *)menuItem;
- (void)playClosed;
- (void)showLevel:(int)type;
- (void)gameCenter:(CCMenuItem *)menuItem;
- (void)gameCenterClosed;

+ (id)scene;

@end
