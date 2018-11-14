//
//  Tile.m
//  HotWire
//
//  Created by Oliver Klemenz on 28.11.10.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#import "Tile.h"
#import "WireTileMap.h"

@implementation Tile

@synthesize gid, type, position;

- (id)initWithGID:(int)aGID andPosition:(CGPoint)pos {
	if ((self = [super init])) {
		self.gid = aGID;
		self.type = [Tile getTileType:aGID];
		self.position = pos;
	}
	return self;
}

+ (int)getTileType:(int)aGID {
	if (aGID < (kWireTileTypes * kWireTileTypeCount)) {
		return (aGID-1) / kWireTileTypeCount;
	} else if (aGID == kWireTileEndingHorizontalStart || aGID == kWireTileEndingHorizontalEnd) {
		return 0;
	} else if (aGID == kWireTileEndingVerticalStart || aGID == kWireTileEndingVerticalEnd) {
		return 1;
	}
	return 0;
}

@end
