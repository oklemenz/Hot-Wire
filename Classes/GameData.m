//
//  GameData.m
//  HotWire
//
//  Created by Oliver Klemenz on 30.01.11.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#import "GameData.h"
#import "WireTileMap.h"
#import "HotWireLevelScene.h"

@implementation GameData

/*                                          /   )   \   (             
									 -  |                  /  (    \   )  */
static CGFloat TileGIDDeltaX[10] = { 1, 0, -1, -1,  1,  1, 1, 1,  -1, -1 };
static CGFloat TileGIDDeltaY[10] = { 0, 1, -1, -1, -1, -1, 1, 1,   1,  1 };

static int combinationMap[4][10] = { { 3, 0, 0, 0, 5, 4, 1, 2, 0, 0 }, 
									 { 0, 3, 0, 0, 0, 0, 5, 4, 1, 2 },
									 { 3, 0, 1, 2, 0, 0, 0, 0, 5, 4 }, 
									 { 0, 3, 5, 4, 1, 2, 0, 0, 0, 0 } };

static CGFloat collisionMap[275][50][50];

static int trainingDifficulty[25];
static NSMutableArray *trainingWireIDs;
static int competitionDifficulty[25];
static NSMutableArray *competitionWireIDs;

+ (void)initialize {
	// Collision Matrix Setup
	UIImage *collisionImage = [UIImage imageNamed:@"wire_tileset.png"]; 
	int width = kWireTileTypeCount * kWireTileWidthBorder + 2; // (int)collisionImage.size.width;
	int height = (kWireTileTypes+1) * kWireTileHeightBorder + 2; // (int)collisionImage.size.height;
	CFDataRef imageData = CGDataProviderCopyData(CGImageGetDataProvider(collisionImage.CGImage)); 
	const UInt32 *pixels = (const UInt32*)CFDataGetBytePtr(imageData); 
	for (int i = 0; i < (width * height); i++) {
		int x = i % width;
		int y = i / width;
		if (x > 0 && x < width-1 && y > 0 && y < height-1) {
			x--;
			y--;
			int tx = x / kWireTileWidthBorder;
			int ty = y / kWireTileHeightBorder;
			int p = ty * ((width-2) / kWireTileWidthBorder) + tx;
			int rx = x % kWireTileWidthBorder;
			int ry = y % kWireTileHeightBorder;
			if (rx > 0 && rx < kWireTileWidth + 1 && ry > 0 && ry < kWireTileWidth + 1) {
				rx--;
				ry--;
				int alpha = pixels[i] >> 24;
				collisionMap[p][rx][ry] = alpha;
			}
		}
	}
	CFRelease(imageData);
	// Level Setup
	trainingDifficulty[0]  = 1;
	trainingDifficulty[1]  = 1;
	trainingDifficulty[2]  = 1;
	trainingDifficulty[3]  = 2;
	trainingDifficulty[4]  = 2;
	trainingDifficulty[5]  = 2;
	trainingDifficulty[6]  = 3;
	trainingDifficulty[7]  = 3;
	trainingDifficulty[8]  = 3;
	trainingDifficulty[9]  = 4;
	trainingDifficulty[10] = 4;
	trainingDifficulty[11] = 4;
	trainingDifficulty[12] = 5;
	trainingDifficulty[13] = 5;
	trainingDifficulty[14] = 5;
	trainingDifficulty[15] = 6;
	trainingDifficulty[16] = 6;
	trainingDifficulty[17] = 7;
	trainingDifficulty[18] = 7;
	trainingDifficulty[19] = 8;
	trainingDifficulty[20] = 8;
	trainingDifficulty[21] = 9;
	trainingDifficulty[22] = 9;	
	trainingDifficulty[23] = 10;
	trainingDifficulty[24] = 10;
	competitionDifficulty[0]  = 1;
	competitionDifficulty[1]  = 1;
	competitionDifficulty[2]  = 1;
	competitionDifficulty[3]  = 2;
	competitionDifficulty[4]  = 2;
	competitionDifficulty[5]  = 2;
	competitionDifficulty[6]  = 3;
	competitionDifficulty[7]  = 3;
	competitionDifficulty[8]  = 3;
	competitionDifficulty[9]  = 4;
	competitionDifficulty[10] = 4;
	competitionDifficulty[11] = 4;
	competitionDifficulty[12] = 5;
	competitionDifficulty[13] = 5;
	competitionDifficulty[14] = 5;
	competitionDifficulty[15] = 6;
	competitionDifficulty[16] = 6;
	competitionDifficulty[17] = 7;
	competitionDifficulty[18] = 7;
	competitionDifficulty[19] = 8;
	competitionDifficulty[20] = 8;
	competitionDifficulty[21] = 9;
	competitionDifficulty[22] = 9;	
	competitionDifficulty[23] = 10;
	competitionDifficulty[24] = 10;	
	trainingWireIDs = [[NSMutableArray alloc] init];
	competitionWireIDs = [[NSMutableArray alloc] init];
	if (kLoadWireTileMaps) {
		[GameData loadWireTileMaps];
	} else {
		[GameData readWireTileMaps];		
	}
}

+ (GameData *)instance {
	static GameData *_instance;
	@synchronized(self) {
		if (!_instance) {
			_instance = [[GameData alloc] init];
		}
	}
	return _instance;
}

+ (int)getTileGIDDeltaX:(int)gid {
	if (gid <= kWireTileTypes * kWireTileTypeCount) {
		return TileGIDDeltaX[(gid-1) / kWireTileTypeCount];
	} else if (gid == kWireTileEndingHorizontalStart || gid == kWireTileEndingHorizontalEnd) {
		return TileGIDDeltaX[0];
	} else if (gid == kWireTileEndingVerticalStart || gid == kWireTileEndingVerticalEnd) {
		return TileGIDDeltaX[1];
	}
	return 0;
}

+ (int)getTileGIDDeltaY:(int)gid {
	if (gid <= kWireTileTypes * kWireTileTypeCount) {
		return TileGIDDeltaY[(gid-1) / kWireTileTypeCount];	
	} else if (gid == kWireTileEndingHorizontalStart || gid == kWireTileEndingHorizontalEnd) {
		return TileGIDDeltaY[0];
	} else if (gid == kWireTileEndingVerticalStart || gid == kWireTileEndingVerticalEnd) {
		return TileGIDDeltaY[1];
	}
	return 0;
}

+ (int)getTileTypeDeltaX:(int)tileType {
	return TileGIDDeltaX[tileType];
}

+ (int)getTileTypeDeltaY:(int)tileType {
	return TileGIDDeltaY[tileType];
}

+ (int)getCollision:(int)gid andX:(int)x andY:(int)y {
	return collisionMap[gid][x][y];
}

+ (int)getCombinationWithDirectionIndex:(int)dirIndex andTileType:(int)tileType {
	return combinationMap[dirIndex][tileType];
}

+ (NSString *)getLevelWireID:(int)level andType:(int)type {
	if (type == kLevelTypeTraining) {
		if (level-1 < [trainingWireIDs count]) {
			return [trainingWireIDs objectAtIndex:level-1];
		}
	} else if (type == kLevelTypeCompetition) {
		if (level-1 < [competitionWireIDs count]) {
			return [competitionWireIDs objectAtIndex:level-1];
		}
	}
	return @"";
}

+ (int)getLevelDifficulty:(int)level andType:(int)type {
	if (type == kLevelTypeTraining) {
		return trainingDifficulty[level-1];
	} else if (type == kLevelTypeCompetition) {
		return competitionDifficulty[level-1];
	}
	return 0;
}

+ (void)readWireTileMaps {
	NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Levels.data"];
	NSString *levelsData = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL]; 
	if (levelsData) {  
		NSArray *levels = [levelsData componentsSeparatedByString:@"\r\n"];
		int i = 0;
		BOOL training = YES;
		for (NSString *level in levels) {
			if (training) {
				[trainingWireIDs addObject:level];
			} else {
				[competitionWireIDs addObject:level];
			}
			i++;
			if (i == kWireTileMapLevelCountTraining) {
				if (training) {
					training = NO;
				} else {
					break;
				}
				i = 0;				
			}
		}
	}  
}

+ (void)loadWireTileMaps {
	WireTileMap *wireTileMap;
	for (int i = 0; i < kWireTileMapLevelCountTraining; i++) {
		wireTileMap = [WireTileMap wireWithFile:[NSString stringWithFormat:@"wire_tilemap_t%02d.tmx", i+1]];
		NSString *wireID = [wireTileMap serializeWireTiles];
		[trainingWireIDs addObject:wireID];
	}
	for (int i = 0; i < kWireTileMapLevelCountCompetition; i++) {
		wireTileMap = [WireTileMap wireWithFile:[NSString stringWithFormat:@"wire_tilemap_c%02d.tmx", i+1]];
		NSString *wireID = [wireTileMap serializeWireTiles];
		[competitionWireIDs addObject:wireID];
	}
	NSString *levelsData = @"";
	if (kLogWireTileMaps) {
		NSLog(@"----------------------------- WireTileMap WireIDs ---------------------------------->");
	}
	int i = 1;
	for (NSString *wireID in trainingWireIDs) {
		if (i > 1) {
			levelsData = [levelsData stringByAppendingFormat:@"\r\n"];
		}
		levelsData = [levelsData stringByAppendingFormat:@"%@", wireID];
		if (kLogWireTileMaps) {
			NSLog(@"%02i. [trainingWireIDs addObject:@\"%@\"];", i, wireID);
		}
		i++;
	}
	i = 1;
	for (NSString *wireID in competitionWireIDs) {
		levelsData = [levelsData stringByAppendingFormat:@"\r\n%@", wireID];
		if (kLogWireTileMaps) {
			NSLog(@"%02i. [competitionWireIDs addObject:@\"%@\"];", i, wireID);
		}
		i++;
	}
	[levelsData writeToFile:@"/Users/oklemenz/Documents/iPhone/HotWire 2016/Resources/Levels.data" atomically:YES encoding:NSUTF8StringEncoding error:NULL];
	if (kLogWireTileMaps) {
		NSLog(@"<---------------------------- WireTileMap WireIDs -----------------------------------");
	}
}

- (void)dealloc {
	[trainingWireIDs release];
	[competitionWireIDs release];
	[super dealloc];
}

@end
