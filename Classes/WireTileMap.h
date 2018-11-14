//
//  WireTileSet.h
//  HotWire
//
//  Created by Oliver Klemenz on 18.01.11.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//
#define kCollisionPointInnerRadius      27
#define kCollisionPointOuterRadius      38
#define kCollisionPointRadiusOffsetNorm  0
#define kCollisionPointRadiusOffsetOrth  2

#define kCheckPointInnerNormRadius 8
#define kCheckPointInnerOrthRadius 4

#define kWireTileTypes        10
#define kWireTileTypeCount    25
#define kWireTileEndings	   5
#define kWireTileSetWidth     40
#define kWireTileSetHeight    40
#define kWireTileWidth        50
#define kWireTileHeight       50
#define kWireTileWidthBorder  52
#define kWireTileHeightBorder 52

#define kWireTileEndingHorizontalStart 251
#define kWireTileEndingHorizontalEnd   252
#define kWireTileEndingVerticalStart   253
#define kWireTileEndingVerticalEnd     254

#define kCrossTileGID1 2
#define kCrossTileGID2 4
#define kCrossTileGID3 6
#define kCrossTileGID4 8

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface WireTileMap : CCTMXTiledMap {

	CCTMXLayer *wireLayer;
	CCTMXLayer *wireLayerCross;	
	NSMutableArray *wireTiles;
	
	CGSize winSize;
	
	CGPoint topLeft;
	CGPoint bottomRight;
	CGPoint topLeftBorder;
	CGPoint bottomRightBorder;
	CGPoint topLeftGrid;
	CGPoint bottomRightGrid;
	CGPoint startTileCoord;
	CGPoint startPosition;
	CGPoint endTileCoord;
	CGPoint endPosition;
	CGPoint endFlagPosition;
	CGRect  endTileRect;
	CGPoint endDirection;
	
	NSString *wireId;
}

@property (nonatomic, retain) CCTMXLayer *wireLayer;
@property (nonatomic, retain) CCTMXLayer *wireLayerCross;
@property (nonatomic, retain) NSMutableArray *wireTiles;

@property CGSize winSize;

@property CGPoint topLeft;
@property CGPoint bottomRight;
@property CGPoint topLeftBorder;
@property CGPoint bottomRightBorder;
@property CGPoint topLeftGrid;
@property CGPoint bottomRightGrid;
@property CGPoint startTileCoord;
@property CGPoint startPosition;
@property CGPoint endTileCoord;
@property CGPoint endPosition;
@property CGPoint endFlagPosition;
@property CGRect  endTileRect;
@property CGPoint endDirection;

@property (nonatomic, retain) NSString *wireId;

+ (id)wireEmpty;
+ (id)wireWithFile:(NSString*)file;
+ (id)wireWithWireID:(NSString*)wireID;
+ (id)wireWithLevel:(int)level andType:(int)type;

- (id)initWithFile:(NSString*)file;
- (id)initWithWireID:(NSString*)wireID;
- (id)initWithLevel:(int)level andType:(int)type;
- (id)initEmpty;

- (void)setup;
- (void)validate;
- (void)zoomToFrame;
- (void)zoomToFrameAnimated;
- (void)zoomOutAnimated;
- (void)zoomInAnimated;

- (CGPoint)getCenterPosForTileCoord:(CGPoint)tileCoord;
- (CGPoint)getTileCoordForPos:(CGPoint)position;
- (CGPoint)getRelativePosInTile:(CGPoint)position;

- (CGFloat)checkAlphaValueForPos:(CGPoint)position;
- (BOOL)checkTileForPos:(CGPoint)position;
- (BOOL)hasWireTile:(CGPoint)position;

- (void)determineWireTiles;
- (NSString *)serializeWireTiles;
- (void)deserializeWireTiles:(NSString *)wireID;
- (void)deserializeWireTiles:(NSString *)wireID andClear:(BOOL)clear;
- (void)clearWireTiles:(NSString *)wireID;
- (void)clearWire;
- (void)clearAll;

- (BOOL)checkAtStartTile:(CGPoint)position;
- (BOOL)checkAtEndTile:(CGPoint)position;
- (BOOL)checkAtDoneTile:(CGPoint)position;

- (CGRect)drawTeslaPositions;

+ (NSArray *)calcCollisionPoints:(CGPoint)position andGradient:(CGPoint)normGradient;
+ (NSArray *)calcCheckPoints:(CGPoint)position andGradient:(CGPoint)normGradient;

+ (int)getDirectionIndex:(int)x andY:(int)y;

@end
