//
//  GameData.h
//  HotWire
//
//  Created by Oliver Klemenz on 30.01.11.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#define kLoadWireTileMaps NO
#define kLogWireTileMaps NO
#define kWireTileMapLevelCountTraining 25
#define kWireTileMapLevelCountCompetition 25

@interface GameData : NSObject {
}

+ (GameData *)instance;

+ (int)getTileGIDDeltaX:(int)gid;
+ (int)getTileGIDDeltaY:(int)gid;
+ (int)getTileTypeDeltaX:(int)tileType;
+ (int)getTileTypeDeltaY:(int)tileType;
+ (int)getCollision:(int)gid andX:(int)x andY:(int)y;
+ (int)getCombinationWithDirectionIndex:(int)dirIndex andTileType:(int)tileType;
+ (NSString *)getLevelWireID:(int)level andType:(int)type;
+ (int)getLevelDifficulty:(int)level andType:(int)type;
+ (void)readWireTileMaps;
+ (void)loadWireTileMaps;

@end
