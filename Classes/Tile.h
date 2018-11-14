//
//  Tile.h
//  HotWire
//
//  Created by Oliver Klemenz on 28.11.10.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Tile : NSObject {
	int gid;
	int type;
	CGPoint position;
}

@property int gid;
@property int type;
@property CGPoint position;

- (id)initWithGID:(int)aGID andPosition:(CGPoint)pos;

+ (int)getTileType:(int)aGID;

@end
