//
//  HighscoreView.m
//  HotWire
//
//  Created by Oliver Klemenz on 04.02.11.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#import "HighscoreView.h"


@implementation HighscoreView

@synthesize hour1Label, hour2Label, minute1Label, minute2Label, second1Label, second2Label, milli1Label, milli2Label;

- (id)init {
	if ((self = [super init])) {
		float space = 1.2;
		hour1Label = [CCLabelAtlas labelWithString:@"0" charMapFile:@"highscore_font.png" itemWidth:22 itemHeight:22 startCharMap:'.'];
		hour1Label.anchorPoint = ccp(0, 0);
		hour1Label.position = ccp(0 * space, 0);
		[self addChild:hour1Label];
		hour2Label = [CCLabelAtlas labelWithString:@"0" charMapFile:@"highscore_font.png" itemWidth:22 itemHeight:22 startCharMap:'.'];
		hour2Label.anchorPoint = ccp(0, 0);
		hour2Label.position = ccp(10 * space, 0);
		[self addChild:hour2Label];
		CCLabelAtlas *dot1Label = [CCLabelAtlas labelWithString:@"." charMapFile:@"highscore_font.png" itemWidth:22 itemHeight:22 startCharMap:'.'];
		dot1Label.anchorPoint = ccp(0, 0);
		dot1Label.position = ccp(20 * space, 0);
		[self addChild:dot1Label];
		minute1Label = [CCLabelAtlas labelWithString:@"0" charMapFile:@"highscore_font.png" itemWidth:22 itemHeight:22 startCharMap:'.'];
		minute1Label.anchorPoint = ccp(0, 0);
		minute1Label.position = ccp(30 * space, 0);
		[self addChild:minute1Label];
		minute2Label = [CCLabelAtlas labelWithString:@"0" charMapFile:@"highscore_font.png" itemWidth:22 itemHeight:22 startCharMap:'.'];
		minute2Label.anchorPoint = ccp(0, 0);
		minute2Label.position = ccp(40 * space, 0);
		[self addChild:minute2Label];
		CCLabelAtlas *dot2Label = [CCLabelAtlas labelWithString:@"." charMapFile:@"highscore_font.png" itemWidth:22 itemHeight:22 startCharMap:'.'];
		dot2Label.anchorPoint = ccp(0, 0);
		dot2Label.position = ccp(50 * space, 0);
		[self addChild:dot2Label];
		second1Label = [CCLabelAtlas labelWithString:@"0" charMapFile:@"highscore_font.png" itemWidth:22 itemHeight:22 startCharMap:'.'];
		second1Label.anchorPoint = ccp(0, 0);
		second1Label.position = ccp(60 * space, 0);
		[self addChild:second1Label];
		second2Label = [CCLabelAtlas labelWithString:@"0" charMapFile:@"highscore_font.png" itemWidth:22 itemHeight:22 startCharMap:'.'];
		second2Label.anchorPoint = ccp(0, 0);
		second2Label.position = ccp(70 * space, 0);
		[self addChild:second2Label];
		CCLabelAtlas *dot3Label = [CCLabelAtlas labelWithString:@"." charMapFile:@"highscore_font.png" itemWidth:22 itemHeight:22 startCharMap:'.'];
		dot3Label.anchorPoint = ccp(0, 0);
		dot3Label.position = ccp(80 * space, 0);
		[self addChild:dot3Label];
		milli1Label = [CCLabelAtlas labelWithString:@"0" charMapFile:@"highscore_font.png" itemWidth:22 itemHeight:22 startCharMap:'.'];
		milli1Label.anchorPoint = ccp(0, 0);
		milli1Label.position = ccp(90 * space, 0);
		[self addChild:milli1Label];
		milli2Label = [CCLabelAtlas labelWithString:@"0" charMapFile:@"highscore_font.png" itemWidth:22 itemHeight:22 startCharMap:'.'];
		milli2Label.anchorPoint = ccp(0, 0);
		milli2Label.position = ccp(100 * space, 0);
		[self addChild:milli2Label];
	}
	return self;
}

- (void)updateHighscore:(double)time {
	int hour = time / 3600;
	int minute = (time - hour * 3600) / 60;
	int second = time - (hour * 3600 + minute * 60);
	int milli  = round((time - (hour * 3600 + minute * 60 + second)) * 100);
	NSString *hourString = [NSString stringWithFormat:@"%02i", hour];
	NSString *hour1String = [hourString substringToIndex:1];
	NSString *hour2String = [hourString substringWithRange:NSMakeRange(1, 1)];
	NSString *minuteString = [NSString stringWithFormat:@"%02i", minute];
	NSString *minute1String = [minuteString substringToIndex:1];
	NSString *minute2String = [minuteString substringWithRange:NSMakeRange(1, 1)];
	NSString *secondString = [NSString stringWithFormat:@"%02i", second];
	NSString *second1String = [secondString substringToIndex:1];
	NSString *second2String = [secondString substringWithRange:NSMakeRange(1, 1)];
	NSString *milliString = [NSString stringWithFormat:@"%02i", milli];
	NSString *milli1String = [milliString substringToIndex:1];
	NSString *milli2String = [milliString substringWithRange:NSMakeRange(1, 1)];
	[hour1Label setString:hour1String];	
	[hour2Label setString:hour2String];	
	[minute1Label setString:minute1String];
	[minute2Label setString:minute2String];	
	[second1Label setString:second1String];
	[second2Label setString:second2String];	
	[milli1Label setString:milli1String];	
	[milli2Label setString:milli2String];	
}

@end
