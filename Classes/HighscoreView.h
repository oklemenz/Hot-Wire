//
//  HighscoreView.h
//  HotWire
//
//  Created by Oliver Klemenz on 04.02.11.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HighscoreView : CCLayer {
	CCLabelAtlas *hour1Label;
	CCLabelAtlas *hour2Label;
	CCLabelAtlas *minute1Label;
	CCLabelAtlas *minute2Label;
	CCLabelAtlas *second1Label;
	CCLabelAtlas *second2Label;
	CCLabelAtlas *milli1Label;
	CCLabelAtlas *milli2Label;
}

@property(nonatomic, retain) CCLabelAtlas *hour1Label;
@property(nonatomic, retain) CCLabelAtlas *hour2Label;
@property(nonatomic, retain) CCLabelAtlas *minute1Label;
@property(nonatomic, retain) CCLabelAtlas *minute2Label;
@property(nonatomic, retain) CCLabelAtlas *second1Label;
@property(nonatomic, retain) CCLabelAtlas *second2Label;
@property(nonatomic, retain) CCLabelAtlas *milli1Label;
@property(nonatomic, retain) CCLabelAtlas *milli2Label;

- (void)updateHighscore:(double)time;

@end
