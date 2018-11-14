//
//  TextureManager.h
//  HotWire
//
//  Created by Oliver Klemenz on 30.01.11.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface TextureManager : CCNode {
}

+ (TextureManager *)instance;

- (void)unloadAll;
- (void)unloadCopyright;
- (void)unloadHelp;
- (void)unloadMenu;
- (void)unloadLevel;
- (void)unloadGame;
- (void)unloadDayTheme;
- (void)unloadNightTheme;

@end
