//
//  HotWireCopyrightScene.h
//  HotWire
//
//  Created by Oliver Klemenz on 25.01.11.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HotWireCopyrightScene : CCLayerColor {

	CCSprite *copyright;
	CCSprite *copyright2;
	
}

@property(nonatomic, retain) CCSprite *copyright;
@property(nonatomic, retain) CCSprite *copyright2;

+ (id)scene;

- (void)splash:(id)sender;
- (void)show:(id)sender;
- (void)menu:(id)sender;

@end
