//
//  WireTileSet.m
//  HotWire
//
//  Created by Oliver Klemenz on 18.01.11.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#import "WireTileMap.h"
#import "Tile.h"
#import "Utilities.h"
#import "GameData.h"

@implementation WireTileMap

@synthesize wireLayer, wireLayerCross, wireTiles;
@synthesize winSize, topLeft, bottomRight, topLeftBorder, bottomRightBorder, topLeftGrid, bottomRightGrid;
@synthesize startTileCoord, startPosition, endTileCoord, endPosition, endFlagPosition, endTileRect, endDirection;
@synthesize wireId;

+ (id)wireEmpty {
	return [[[self alloc] initEmpty] autorelease];
}

+ (id)wireWithFile:(NSString*)file {
	return [[[self alloc] initWithFile:file] autorelease];
}

+ (id)wireWithWireID:(NSString*)wireID {
	return [[[self alloc] initWithWireID:wireID] autorelease];
}

+ (id)wireWithLevel:(int)level andType:(int)type {
	return [[[self alloc] initWithLevel:level andType:type] autorelease];
}

- (id)initEmpty {
	if ((self = [super initWithTMXFile:@"wire_tilemap_empty.tmx"])) {
		[self setup];
		[wireLayer removeTileAt:startTileCoord];
		[wireLayerCross removeTileAt:startTileCoord];
		[self validate];
	}
	return self;
}

- (id)initWithFile:(NSString*)file {
	if ((self = [super initWithTMXFile:file])) {
		[self setup];
		[self determineWireTiles];
		NSString *fileWireID = [self serializeWireTiles];
		[self clearWire];
		[self deserializeWireTiles:fileWireID];
	}
	return self;
}

- (id)initWithWireID:(NSString*)wireID {
	if ((self = [self initEmpty])) {	
		[self setup];
		[self deserializeWireTiles:wireID];
	}
	return self;
}

- (id)initWithLevel:(int)level andType:(int)type {
	NSString *wireID = [GameData getLevelWireID:level andType:type];
	if ((self = [self initWithWireID:wireID])) {	
		[self setup];
		[self deserializeWireTiles:wireID];
	}
	return self;
}

- (void)setup {
	winSize = [[CCDirector sharedDirector] winSize];
	
	wireLayer = [self layerNamed:@"Wire"];
	wireLayer.scale = 1.0;
	wireLayerCross = [self layerNamed:@"CrossWire"];
	wireLayerCross.scale = 1.0;
	
	startTileCoord = ccp(0, 36);
	startPosition = [self getCenterPosForTileCoord:startTileCoord];
	startPosition = ccp(startPosition.x, startPosition.y - 2);
}

- (void)validate {
	CGFloat left = self.mapSize.width * self.tileSize.width;
	CGFloat top = self.mapSize.height * self.tileSize.height;
	CGFloat right = 0;
	CGFloat bottom = 0;
	for (int x = 0; x < wireLayer.layerSize.width; x++) {
		for (int y = 0; y < wireLayer.layerSize.height; y++) {
			unsigned int gid = [wireLayer tileGIDAt:ccp(x,y)];
			if (gid == 0) {
				gid = [wireLayerCross tileGIDAt:ccp(x,y)];
			}
			if (gid != 0) {
				CGFloat tileLeft = x * self.tileSize.width;
				if (tileLeft < left) {
					left = tileLeft;
				}
				CGFloat tileTop = y * self.tileSize.height;
				if (tileTop < top) {
					top = tileTop;
				}
				CGFloat tileRight = (x+1) * self.tileSize.width;
				if (tileRight > right) {
					right = tileRight;
				}
				CGFloat tileBottom = (y+1) * self.tileSize.height;
				if (tileBottom > bottom) {
					bottom = tileBottom;
				}					
			}
		}
	}
	topLeftGrid = ccp(left, top);
	bottomRightGrid = ccp(right, bottom);
	topLeftBorder = ccp(0.5 * winSize.width, 0.5 * winSize.height);
	bottomRightBorder = ccp(0.5 * winSize.width, 0.5 * winSize.height);
	topLeft = ccp(-left + topLeftBorder.x, top - (wireLayer.layerSize.height * self.tileSize.height - topLeftBorder.y));
	bottomRight = ccp(winSize.width - right - bottomRightBorder.x, bottom - wireLayer.layerSize.height * self.tileSize.height + bottomRightBorder.y);
	if (bottomRight.x > 0) {
		bottomRight = ccp(0, bottomRight.y);
	}
		
	endPosition = [self getCenterPosForTileCoord:endTileCoord];
	double halfTileWidth = kWireTileWidth / 2.0;
	double halfTileHeight = kWireTileHeight / 2.0;
	if (endDirection.x == -1) {
		endTileRect = CGRectMake(endPosition.x - halfTileWidth, endPosition.y - halfTileHeight, halfTileWidth, kWireTileHeight);
		endFlagPosition = ccp(endPosition.x - 40, endPosition.y + 25);
	} else if (endDirection.x == 1) {
		endTileRect = CGRectMake(endPosition.x, endPosition.y - halfTileHeight, halfTileWidth, kWireTileHeight);
		endFlagPosition = ccp(endPosition.x + 40, endPosition.y + 25);
	} else if (endDirection.y == -1) {
		endTileRect = CGRectMake(endPosition.x - halfTileWidth, endPosition.y, kWireTileWidth, halfTileHeight);
		endFlagPosition = ccp(endPosition.x + 40, endPosition.y + 30);
	} else if (endDirection.y == 1) {
		endTileRect = CGRectMake(endPosition.x - halfTileWidth, endPosition.y - halfTileHeight, kWireTileWidth, halfTileHeight);
		endFlagPosition = ccp(endPosition.x + 35, endPosition.y - 25);
	}
}
	 
- (void)zoomToFrame {
	self.scale = MIN(197.0 / bottomRightGrid.x, 194.0 / (self.mapSize.height * self.tileSize.height - topLeftGrid.y));
}

- (void)zoomToFrameAnimated {
	self.scale = 0.0;
	float scale = MIN(197.0 / bottomRightGrid.x, 194.0 / (self.mapSize.height * self.tileSize.height - topLeftGrid.y));
	id zoom = [CCScaleTo actionWithDuration:0.5 scale:scale];
	[self runAction:zoom];
}

- (void)zoomOutAnimated {
	id zoom = [CCScaleTo actionWithDuration:0.5 scale:0.0];
	[self runAction:zoom];
}

- (void)zoomInAnimated {
	id zoom = [CCScaleTo actionWithDuration:0.5 scale:1.0];
	id move = [CCMoveTo actionWithDuration:0.5 position:ccp(0, 0)];
	[self runAction:[CCSpawn actions: zoom, move, nil]];
}

- (CGPoint)getCenterPosForTileCoord:(CGPoint)tileCoord {
	return ccp((tileCoord.x + 0.5) * self.tileSize.width, (self.mapSize.height * self.tileSize.height) - (tileCoord.y + 0.5) * self.tileSize.height);
}

- (CGPoint)getTileCoordForPos:(CGPoint)position {
	position = [wireLayer convertToNodeSpace:position];
	int x = position.x / self.tileSize.width;
	int y = ((self.mapSize.height * self.tileSize.height) - position.y) / self.tileSize.height;
	return ccp(x, y);
}

- (CGPoint)getRelativePosInTile:(CGPoint)position {
	CGPoint tileCoord = [self getTileCoordForPos:position];
	position = [wireLayer convertToNodeSpace:position];	
	int x = position.x - tileCoord.x * self.tileSize.width;
	int y = ((self.mapSize.height * self.tileSize.height) - position.y) - tileCoord.y * self.tileSize.height;
	return ccp(x, y);
}

- (CGFloat)checkAlphaValueForPos:(CGPoint)position {
	CGFloat alpha = 0.0;
	CGPoint tileCoord = [self getTileCoordForPos:position];
	if (tileCoord.x >= 0 && tileCoord.x < self.mapSize.width && tileCoord.y >= 0 && tileCoord.y < self.mapSize.height) {
		int tileGID = [wireLayer tileGIDAt:tileCoord];
		if (tileGID != 0) {
			CGPoint relPos = [self getRelativePosInTile:position];
			if (relPos.x >= 0 && relPos.x < self.tileSize.width && relPos.y >= 0 && relPos.y < self.tileSize.height) {
				alpha = [GameData getCollision:tileGID-1 andX:(int)relPos.x andY:(int)relPos.y];
			}
		}
		tileGID = [wireLayerCross tileGIDAt:tileCoord];
		if (tileGID != 0) {
			CGPoint relPos = [self getRelativePosInTile:position];
			if (relPos.x >= 0 && relPos.x < self.tileSize.width && relPos.y >= 0 && relPos.y < self.tileSize.height) {
				CGFloat alpha2 = [GameData getCollision:tileGID-1 andX:(int)relPos.x andY:(int)relPos.y];
				if (alpha2 > alpha) {
					alpha = alpha2;
				}
			}
		}
	}
	return alpha;
}

- (BOOL)checkTileForPos:(CGPoint)position {
	return [self checkAlphaValueForPos:position] != 0;
}

- (BOOL)hasWireTile:(CGPoint)position {
	CGPoint tileCoord = [self getTileCoordForPos:position];
	if (tileCoord.x >= 0 && tileCoord.x < self.mapSize.width && tileCoord.y >= 0 && tileCoord.y < self.mapSize.height) {
		int tileGID = [wireLayer tileGIDAt:tileCoord];
		if (tileGID != 0) {
			return YES;
		}
		tileGID = [wireLayerCross tileGIDAt:tileCoord];
		if (tileGID != 0) {
			return YES;
		}
	}
	return NO;
}

- (void)determineWireTiles {
	if (wireTiles) {
		[wireTiles release];
	}
	wireTiles = [[NSMutableArray alloc] init];
	CGPoint axis = ccp(1, 0);
	CGPoint direction = ccp(1, 0);
	CGPoint tileCoord = startTileCoord;
	int currentGID = [wireLayer tileGIDAt:tileCoord];
	while (currentGID != 0) {
		Tile *tile = [[Tile alloc] initWithGID:currentGID andPosition:tileCoord];
		[wireTiles addObject:tile];
		[tile release];
		//NSLog(@"(%f, %f)", tileCoord.x, tileCoord.y);
		int dX = [GameData getTileGIDDeltaX:currentGID];
		int dY = [GameData getTileGIDDeltaY:currentGID];
		if (dX != 0 && dY != 0) {
			axis = ccp(axis.y, axis.x);
			direction = ccp(axis.x * dX, axis.y * dY);
		}
		endTileCoord = tileCoord;
		endDirection = direction;
		tileCoord = ccp(tileCoord.x + direction.x, tileCoord.y + direction.y);
		if (tileCoord.x >= 0 && tileCoord.x < self.mapSize.width && tileCoord.y >= 0 && tileCoord.y < self.mapSize.height) {
			currentGID = [wireLayer tileGIDAt:tileCoord];
			if (currentGID == 0) {
				currentGID = [wireLayerCross tileGIDAt:tileCoord];
			}
			if (currentGID != 0) {
				int ndX = [GameData getTileGIDDeltaX:currentGID];
				int ndY = [GameData getTileGIDDeltaY:currentGID];
				if ((direction.x != 0 && direction.x != -ndX) || (direction.y != 0 && direction.y != -ndY)) {
					if ((ndY != 0 || direction.x != ndX) && (ndX != 0 || direction.y != ndY)) {
						int tileType = [Tile getTileType:currentGID];;
						if (tileType == kCrossTileGID1 || tileType == kCrossTileGID2 || tileType == kCrossTileGID3 || tileType == kCrossTileGID4) {
							if (currentGID != 0) {
								currentGID = [wireLayerCross tileGIDAt:tileCoord];
								ndX = [GameData getTileGIDDeltaX:currentGID];
								ndY = [GameData getTileGIDDeltaY:currentGID];
								if ((direction.x != 0 && direction.x != -ndX) || (direction.y != 0 && direction.y != -ndY)) {
									//NSLog(@"Error in tilemap at position (%f, %f). Wire tiles are not connected.", tileCoord.x, tileCoord.y);
									break;
								}
							}
						} 
						else {
							//NSLog(@"Error in tilemap at position (%f, %f). Wire tiles are not connected.", tileCoord.x, tileCoord.y);
							break;
						}
					}
				}
			}
		} else {
			currentGID = 0;
		}		
	}
}

- (NSString *)serializeWireTiles {
	NSString *wireID = @"";
	for (Tile *tile in wireTiles) {
		wireID = [wireID stringByAppendingFormat:@"%i", tile.type];
	}
	self.wireId = wireID;
	return wireID;
}

- (void)deserializeWireTiles:(NSString *)wireID {
	[self deserializeWireTiles:wireID andClear:NO];
}

- (void)deserializeWireTiles:(NSString *)wireID andClear:(BOOL)clear {
	self.wireId = wireID;
	if (wireTiles) {
		[wireTiles release];
	}		
	wireTiles = [[NSMutableArray alloc] init];
	CGPoint axis = ccp(1, 0);
	CGPoint direction = ccp(1, 0);
	CGPoint tileCoord = startTileCoord;
	int previousTileType = -1;
	CGPoint previousDirection = direction;
	int length = (int)[wireID length];
	for (int i = 0; i < length; i++) {		
		NSString *tileTypeString = [wireID substringWithRange:NSMakeRange(i, 1)];
		if(![[NSScanner scannerWithString:tileTypeString] scanFloat:NULL]) {
			//NSLog(@"Error in tilemap at position (%i). Wire tiles are not connected.", i);
			break;
		}
		int tileType = [tileTypeString intValue];
		int dX = [GameData getTileTypeDeltaX:tileType];
		int dY = [GameData getTileTypeDeltaY:tileType];
		if (dX != 0 && dY != 0) {
			axis = ccp(axis.y, axis.x);
			direction = ccp(axis.x * dX, axis.y * dY);
		}
		NSString *nextTileTypeString = nil;
		int nextTileType = -1;
		if (i < [wireID length]-1) {
			nextTileTypeString = [wireID substringWithRange:NSMakeRange(i+1, 1)];
			nextTileType = [nextTileTypeString intValue];
		}
		int p = 2;
		int n = 2;
		int previousDirIndex = [WireTileMap getDirectionIndex:-previousDirection.x andY:-previousDirection.y];
		if (previousTileType != -1) {
			if ([GameData getCombinationWithDirectionIndex:previousDirIndex andTileType:previousTileType] != 0) {
				p = [GameData getCombinationWithDirectionIndex:previousDirIndex andTileType:previousTileType] - 1;
			}
		}
		int	nextDirIndex = [WireTileMap getDirectionIndex:direction.x andY:direction.y];
		if (nextTileType != -1) {
			if ([GameData getCombinationWithDirectionIndex:nextDirIndex andTileType:nextTileType] != 0) {
				n = [GameData getCombinationWithDirectionIndex:nextDirIndex andTileType:nextTileType] - 1;
			}
		}
		/*
		 0 -> 1, 2, 3
		 1 -> 2, 3
		 2 -> 3 
		 3 -> 
		 */
		if (nextDirIndex < previousDirIndex) {
			int tmp = n;
			n = p;
			p = tmp;
		}
		// | (p)previous: 1 | (t)current: 25 | (n)next: 5 |
		int currentGID = 1 + tileType * kWireTileTypeCount + n * kWireTileEndings + p;
		if (i == 0) {
			if (tileType == 0) {
				currentGID = kWireTileEndingHorizontalStart;
			} if (tileType == 1) { 
				currentGID = kWireTileEndingVerticalStart;
			}
		} else if (i == length-1) {
			if (tileType == 0) {
				if (direction.x == -1) {
					currentGID = kWireTileEndingHorizontalStart;
				} else if (direction.x == 1) {
					currentGID = kWireTileEndingHorizontalEnd;
				}
			} if (tileType == 1) { 
				if (direction.y == -1) {
					currentGID = kWireTileEndingVerticalStart;
				} else if (direction.y == 1) {
					currentGID = kWireTileEndingVerticalEnd;
				}
			}
		}
		if (!clear) {
			Tile *tile = [[Tile alloc] initWithGID:currentGID andPosition:tileCoord];
			[wireTiles addObject:tile];
			[tile release];
			//NSLog(@"(%f, %f) - %i", tileCoord.x, tileCoord.y, currentGID);
			int existingGID = [wireLayer tileGIDAt:tileCoord];
			if (existingGID == 0 || [Tile getTileType:existingGID] == tileType) {
				[wireLayer setTileGID:currentGID at:tileCoord];
			} else {
				[wireLayerCross setTileGID:currentGID at:tileCoord];
			}
		} else {
			[wireLayer removeTileAt:tileCoord];
			[wireLayerCross removeTileAt:tileCoord];
		}
		endTileCoord = tileCoord;
		endDirection = direction;
		tileCoord = ccp(tileCoord.x + direction.x, tileCoord.y + direction.y);
		previousTileType = tileType;
		previousDirection = direction;
	}
	if (clear) {
		self.wireId = @"";
		endTileCoord = CGPointZero;
		endDirection = ccp(1, 0);
	}
	[self validate];
}

- (void)clearWireTiles:(NSString *)wireID {
	[self deserializeWireTiles:wireID andClear:YES];
}

- (void)clearWire {
	[self clearWireTiles:self.wireId];
}

- (void)clearAll {
	for (int i = 0; i < self.mapSize.height; i++) {
		for (int j = 0; j < self.mapSize.width; j++) {
			CGPoint tileCoord = ccp(i, j);
			[wireLayer removeTileAt:tileCoord];
			[wireLayerCross removeTileAt:tileCoord];
		}
	}
	[self validate];
}

- (BOOL)checkAtStartTile:(CGPoint)position {
	CGPoint tileCoord = [self getTileCoordForPos:position];
	return tileCoord.x == startTileCoord.x && tileCoord.y == startTileCoord.y;
}

- (BOOL)checkAtEndTile:(CGPoint)position {
	CGPoint tileCoord = [self getTileCoordForPos:position];
	return tileCoord.x == endTileCoord.x && tileCoord.y == endTileCoord.y;
}

- (BOOL)checkAtDoneTile:(CGPoint)position {
	position = [wireLayer convertToNodeSpace:position];
	return position.x >= endTileRect.origin.x && 
		   position.x <= endTileRect.origin.x + endTileRect.size.width && 
		   position.y >= endTileRect.origin.y &&
		   position.y <= endTileRect.origin.y + endTileRect.size.height;
}

- (CGRect)drawTeslaPositions {
	int count = (int)[wireTiles count];
	int r1 = [Utilities getRandomWithMin:0 andMax:count];
	CGPoint tileCoord1 = ((Tile*)[wireTiles objectAtIndex:r1]).position;
	int c1GID = [wireLayer tileGIDAt:tileCoord1];
	CGPoint pos1 = [self getCenterPosForTileCoord:tileCoord1];
	if ([GameData getTileGIDDeltaX:c1GID] != 0 && [GameData getTileGIDDeltaY:c1GID] != 0) {
		pos1 = ccp(pos1.x + [GameData getTileGIDDeltaX:c1GID] * 10, pos1.y - [GameData getTileGIDDeltaY:c1GID] * 10);
	}		
	if (pos1.x >= -self.position.x && pos1.x <= -self.position.x + winSize.width && 
		pos1.y >= -self.position.y && pos1.y <= -self.position.y + winSize.height) {
		CGPoint tileCoord2 = CGPointZero;
		if ([Utilities getFloatHalfRandom] >= 0) {
			int r2 = 0;
			if ([Utilities getBoolRandom]) {
				r2 = r1 + [Utilities getRandomWithMin:2 andMax:6]; 
			}
			else {
				r2 = r1 - [Utilities getRandomWithMin:2 andMax:6]; 
			}
			if (r2 < 0) {
				r2 = 0;
			}
			if (r2 >= count) {
				r2 = count-1;
			}
			tileCoord2 = ((Tile*)[wireTiles objectAtIndex:r2]).position;
		} else {
			NSMutableArray *teslaPoints = [[NSMutableArray alloc] init];
			for (int i = 0; i < 5; i++) {
				for (int j = 0; j < 5; j++) {
					if (i != 2 && j != 2) {
						CGPoint tileCoord2 = ccp(tileCoord1.x + i - 2, tileCoord1.y + j - 2);
						if (tileCoord2.x >= 0 && tileCoord2.x < self.mapSize.width && tileCoord2.y >= 0 && tileCoord2.y < self.mapSize.height) {
							int c2GID = [wireLayer tileGIDAt:tileCoord2];
							if (c2GID != 0) {
								[teslaPoints addObject:[NSValue valueWithCGPoint:tileCoord2]];
							}
						}
					}
				}
			}
			int count = (int)[teslaPoints count];
			if (count > 0) {
				int r2 = [Utilities getRandomWithMin:0 andMax:count];
				tileCoord2 = [[teslaPoints objectAtIndex:r2] CGPointValue];
			}
			[teslaPoints release];
		}
		if (tileCoord2.x != 0 && tileCoord2.y != 0) {
			int c2GID = [wireLayer tileGIDAt:tileCoord2];
			CGPoint pos2 = [self getCenterPosForTileCoord:tileCoord2];
			if ([GameData getTileGIDDeltaX:c2GID] != 0 && [GameData getTileGIDDeltaY:c2GID] != 0) {
				pos2 = ccp(pos2.x + [GameData getTileGIDDeltaX:c2GID] * 10, pos2.y - [GameData getTileGIDDeltaY:c2GID] * 10);
			}	
			if (pos2.x >= -self.position.x-10 && pos2.x <= -self.position.x + winSize.width+10 && 
				pos2.y >= -self.position.y-10 && pos2.y <= -self.position.y + winSize.height+10) {
				return CGRectMake(pos1.x, pos1.y, pos2.x, pos2.y);
			}
		}
	}
	return CGRectZero;
}

+ (NSArray *)calcCollisionPoints:(CGPoint)position andGradient:(CGPoint)normGradient {
	NSMutableArray *collisionPoints = [[NSMutableArray alloc] init];
	CGPoint orthGradient = ccp(-normGradient.y, normGradient.x);
	CGFloat innerDistanceX = normGradient.x * kCollisionPointInnerRadius;
	CGFloat innerDistanceY = normGradient.y * kCollisionPointInnerRadius;
	CGFloat innerOffsetNormDistanceX = innerDistanceX; // - (normGradient.x * kCollisionPointRadiusOffsetNorm);
	CGFloat innerOffsetNormDistanceY = innerDistanceY; // - (normGradient.y * kCollisionPointRadiusOffsetNorm);
	CGFloat outerDistanceX = normGradient.x * kCollisionPointOuterRadius;
	CGFloat outerDistanceY = normGradient.y * kCollisionPointOuterRadius;
	CGFloat outerOffsetNormDistanceX = outerDistanceX; // - (normGradient.x * kCollisionPointRadiusOffsetNorm);
	CGFloat outerOffsetNormDistanceY = outerDistanceY; // - (normGradient.y * kCollisionPointRadiusOffsetNorm);
	CGFloat offsetOrthDistanceX = orthGradient.x * kCollisionPointRadiusOffsetOrth;
	CGFloat offsetOrthDistanceY = orthGradient.y * kCollisionPointRadiusOffsetOrth;
	// Top
	[collisionPoints addObject:[NSValue valueWithCGPoint:ccpAdd(position, ccp(innerDistanceX, innerDistanceY))]];
	[collisionPoints addObject:[NSValue valueWithCGPoint:ccpAdd(position, ccp(innerOffsetNormDistanceX - offsetOrthDistanceX, innerOffsetNormDistanceY - offsetOrthDistanceY))]];	
	[collisionPoints addObject:[NSValue valueWithCGPoint:ccpAdd(position, ccp(innerOffsetNormDistanceX + offsetOrthDistanceX, innerOffsetNormDistanceY + offsetOrthDistanceY))]];	
	[collisionPoints addObject:[NSValue valueWithCGPoint:ccpAdd(position, ccp(outerDistanceX, outerDistanceY))]];
	[collisionPoints addObject:[NSValue valueWithCGPoint:ccpAdd(position, ccp(outerOffsetNormDistanceX - offsetOrthDistanceX, outerOffsetNormDistanceY - offsetOrthDistanceY))]];	
	[collisionPoints addObject:[NSValue valueWithCGPoint:ccpAdd(position, ccp(outerOffsetNormDistanceX + offsetOrthDistanceX, outerOffsetNormDistanceY + offsetOrthDistanceY))]];	
	// Bottom
	[collisionPoints addObject:[NSValue valueWithCGPoint:ccpAdd(position, ccp(-innerDistanceX, -innerDistanceY))]];
	[collisionPoints addObject:[NSValue valueWithCGPoint:ccpAdd(position, ccp(-innerOffsetNormDistanceX - offsetOrthDistanceX, -innerOffsetNormDistanceY - offsetOrthDistanceY))]];	
	[collisionPoints addObject:[NSValue valueWithCGPoint:ccpAdd(position, ccp(-innerOffsetNormDistanceX + offsetOrthDistanceX, -innerOffsetNormDistanceY + offsetOrthDistanceY))]];	
	[collisionPoints addObject:[NSValue valueWithCGPoint:ccpAdd(position, ccp(-outerDistanceX, -outerDistanceY))]];
	[collisionPoints addObject:[NSValue valueWithCGPoint:ccpAdd(position, ccp(-outerOffsetNormDistanceX - offsetOrthDistanceX, -outerOffsetNormDistanceY - offsetOrthDistanceY))]];	
	[collisionPoints addObject:[NSValue valueWithCGPoint:ccpAdd(position, ccp(-outerOffsetNormDistanceX + offsetOrthDistanceX, -outerOffsetNormDistanceY + offsetOrthDistanceY))]];	
	return collisionPoints;
}	

+ (NSArray *)calcCheckPoints:(CGPoint)position andGradient:(CGPoint)normGradient {
	NSMutableArray *checkPoints = [[NSMutableArray alloc] init];
	[checkPoints addObject:[NSValue valueWithCGPoint:position]];
	CGPoint orthGradient = ccp(-normGradient.y, normGradient.x);
	CGFloat normDistanceX = normGradient.x * kCheckPointInnerNormRadius;
	CGFloat normDistanceY = normGradient.y * kCheckPointInnerNormRadius;
	CGFloat orthDistanceX = orthGradient.x * kCheckPointInnerOrthRadius;
	CGFloat orthDistanceY = orthGradient.y * kCheckPointInnerOrthRadius;
	[checkPoints addObject:[NSValue valueWithCGPoint:ccpAdd(position, ccp(normDistanceX, normDistanceY))]];
	[checkPoints addObject:[NSValue valueWithCGPoint:ccpAdd(position, ccp(-normDistanceX, -normDistanceY))]];
	[checkPoints addObject:[NSValue valueWithCGPoint:ccpAdd(position, ccp(orthDistanceX, orthDistanceY))]];
	[checkPoints addObject:[NSValue valueWithCGPoint:ccpAdd(position, ccp(-orthDistanceX, -orthDistanceY))]];
	normDistanceX *= 2;
	normDistanceY *= 2;
	orthDistanceX *= 2;
	orthDistanceY *= 2;
	[checkPoints addObject:[NSValue valueWithCGPoint:ccpAdd(position, ccp(normDistanceX, normDistanceY))]];
	[checkPoints addObject:[NSValue valueWithCGPoint:ccpAdd(position, ccp(-normDistanceX, -normDistanceY))]];
	[checkPoints addObject:[NSValue valueWithCGPoint:ccpAdd(position, ccp(orthDistanceX, orthDistanceY))]];
	[checkPoints addObject:[NSValue valueWithCGPoint:ccpAdd(position, ccp(-orthDistanceX, -orthDistanceY))]];
	return checkPoints;
}

+ (int)getDirectionIndex:(int)x andY:(int)y {
	if (x == -1 && y == 0) {
		return 0;
	} else if (x == 0 && y == -1) {
		return 1;
	} else if (x == 1 && y == 0) {
		return 2;
	} else if (x == 0 && y == 1) {
		return 3;
	}
	return -1;
}

- (void)dealloc {
	[wireTiles release];
	[super dealloc];
}

@end
