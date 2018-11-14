//
//  HotWirePlaySelect.h
//  HotWire
//
//  Created by Oliver Klemenz on 20.01.11.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class HotWireMenuScene;

@interface HotWirePlaySelect : CCLayer<CCRGBAProtocol> {

	HotWireMenuScene *menuScene;

	GLubyte	opacity_;
	ccColor3B color_;
}

@property (nonatomic) GLubyte opacity;
@property (nonatomic) ccColor3B color;

@property (nonatomic, retain) HotWireMenuScene *menuScene;

- (void)switchButtons:(BOOL)state;

- (void)showSelect:(HotWireMenuScene *)aMenuScene;
- (void)hideSelect:(CCMenuItem *)menuItem;

@end
