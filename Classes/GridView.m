//
//  GridView.m
//  HotWire
//
//  Created by Oliver Klemenz on 25.11.10.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#import "GridView.h"
#include <OpenGLES/ES1/gl.h>

@implementation GridView

- (void)draw {
	glColor4f(0.3, 0.3, 0.3, 0.2);
    glLineWidth(0.5f);
	for (int i = 0; i < 40; i++) {
		ccDrawLine(ccp(i*50, 0), ccp(i*50, 40*50));
	}
	for (int j = 0; j < 40; j++) {
		ccDrawLine(ccp(0, j*50), ccp(40*50, j*50));
	}
}

@end
