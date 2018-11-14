//
//  TextureManager.m
//  HotWire
//
//  Created by Oliver Klemenz on 30.01.11.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#import "TextureManager.h"

@implementation TextureManager

+ (TextureManager *)instance {
	static TextureManager *_instance;
	@synchronized(self) {
		if (!_instance) {
			_instance = [[TextureManager alloc] init];
		}
	}
	return _instance;
}

- (void)unloadAll {
	[CCTextureCache purgeSharedTextureCache];	
}

- (void)unloadCopyright {
	CCTextureCache *textureCache = [CCTextureCache sharedTextureCache];
	[textureCache removeTextureForKey:@"copyright.png"];
}

- (void)unloadHelp {
	CCTextureCache *textureCache = [CCTextureCache sharedTextureCache];
	[textureCache removeTextureForKey:@"help.png"];
}

- (void)unloadMenu {
	/*CCTextureCache *textureCache = [CCTextureCache sharedTextureCache];
	[textureCache removeTextureForKey:@"game_center_achievements.png"];
	[textureCache removeTextureForKey:@"game_center_achievements_p.png"];
	[textureCache removeTextureForKey:@"game_center_leaderboards.png"];
	[textureCache removeTextureForKey:@"game_center_leaderboards_p.png"];
	[textureCache removeTextureForKey:@"game_center_title.png"];
	[textureCache removeTextureForKey:@"hot_wire.png"];
	[textureCache removeTextureForKey:@"menu.png"];
	[textureCache removeTextureForKey:@"menu_back.png"];
	[textureCache removeTextureForKey:@"menu_back_p.png"];
	[textureCache removeTextureForKey:@"menu_frame.png"];
	[textureCache removeTextureForKey:@"menu_frame_large.png"];
	[textureCache removeTextureForKey:@"menu_game_center.png"];
	[textureCache removeTextureForKey:@"menu_game_center_p.png"];
	[textureCache removeTextureForKey:@"menu_help_btn.png"];
	[textureCache removeTextureForKey:@"menu_help_btn_p.png"];
	[textureCache removeTextureForKey:@"menu_lightning1.png"];
	[textureCache removeTextureForKey:@"menu_lightning2.png"];
	[textureCache removeTextureForKey:@"menu_moon.png"];
	[textureCache removeTextureForKey:@"menu_options.png"];
	[textureCache removeTextureForKey:@"menu_options_p.png"];
	[textureCache removeTextureForKey:@"menu_play.png"];
	[textureCache removeTextureForKey:@"menu_play_p.png"];
	[textureCache removeTextureForKey:@"menu_scores.png"];
	[textureCache removeTextureForKey:@"menu_scores_p.png"];
	[textureCache removeTextureForKey:@"menu_sun.png"];
	[textureCache removeTextureForKey:@"menu_theme_moon.png"];
	[textureCache removeTextureForKey:@"menu_theme_p.png"];
	[textureCache removeTextureForKey:@"menu_theme_sun.png"];
	[textureCache removeTextureForKey:@"menu_wire.png"];
	[textureCache removeTextureForKey:@"white_sun.png"];
	[textureCache removeTextureForKey:@"options_grid_off.png"];
	[textureCache removeTextureForKey:@"options_grid_off_p.png"];
	[textureCache removeTextureForKey:@"options_grid_on.png"];
	[textureCache removeTextureForKey:@"options_grid_on_p.png"];
	[textureCache removeTextureForKey:@"options_invers_axis_off.png"];
	[textureCache removeTextureForKey:@"options_invers_axis_off_p.png"];
	[textureCache removeTextureForKey:@"options_invers_axis_on.png"];
	[textureCache removeTextureForKey:@"options_invers_axis_on_p.png"];
	[textureCache removeTextureForKey:@"options_music_off.png"];
	[textureCache removeTextureForKey:@"options_music_off_p.png"];
	[textureCache removeTextureForKey:@"options_music_on.png"];
	[textureCache removeTextureForKey:@"options_music_on_p.png"];
	[textureCache removeTextureForKey:@"options_sound_off.png"];
	[textureCache removeTextureForKey:@"options_sound_off_p.png"];
	[textureCache removeTextureForKey:@"options_sound_on.png"];
	[textureCache removeTextureForKey:@"options_sound_on_p.png"];
	[textureCache removeTextureForKey:@"options_title.png"];
	[textureCache removeTextureForKey:@"options_vibration_off.png"];
	[textureCache removeTextureForKey:@"options_vibration_off_p.png"];
	[textureCache removeTextureForKey:@"options_vibration_on.png"];
	[textureCache removeTextureForKey:@"options_vibration_on_p.png"];*/
}

- (void)unloadLevel {
	/*CCTextureCache *textureCache = [CCTextureCache sharedTextureCache];
	[textureCache removeTextureForKey:@"level_best_highscore.png"];
	[textureCache removeTextureForKey:@"level_check.png"];
	[textureCache removeTextureForKey:@"level_clear.png"];
	[textureCache removeTextureForKey:@"level_clear_p.png"];
	[textureCache removeTextureForKey:@"level_competition.png"];
	[textureCache removeTextureForKey:@"level_cross.png"];
	[textureCache removeTextureForKey:@"level_day.png"];
	[textureCache removeTextureForKey:@"level_difficulty.png"];
	[textureCache removeTextureForKey:@"level_font.png"];
	[textureCache removeTextureForKey:@"level_frame.png"];
	[textureCache removeTextureForKey:@"level_frame_back.png"];
	[textureCache removeTextureForKey:@"level_frame_p.png"];
	[textureCache removeTextureForKey:@"level_level.png"];
	[textureCache removeTextureForKey:@"level_lightning.png"];
	[textureCache removeTextureForKey:@"level_lock.png"];
	[textureCache removeTextureForKey:@"level_next.png"];
	[textureCache removeTextureForKey:@"level_next_p.png"];
	[textureCache removeTextureForKey:@"level_night.png"];
	[textureCache removeTextureForKey:@"level_not_available.png"];
	[textureCache removeTextureForKey:@"level_parts.png"];
	[textureCache removeTextureForKey:@"level_previous.png"];
	[textureCache removeTextureForKey:@"level_previous_p.png"];
	[textureCache removeTextureForKey:@"level_size.png"];
	[textureCache removeTextureForKey:@"level_star.png"];
	[textureCache removeTextureForKey:@"level_training.png"];
	[textureCache removeTextureForKey:@"level_your_highscore.png"];
	[textureCache removeTextureForKey:@"highscore_font.png"];
	[textureCache removeTextureForKey:@"play_competition.png"];
	[textureCache removeTextureForKey:@"play_competition_p.png"];
	[textureCache removeTextureForKey:@"play_select_title.png"];
	[textureCache removeTextureForKey:@"play_training.png"];
	[textureCache removeTextureForKey:@"play_training_p.png"];*/
}
- (void)unloadGame {
	/*CCTextureCache *textureCache = [CCTextureCache sharedTextureCache];
	[textureCache removeTextureForKey:@"checked_flag.png"];
	[textureCache removeTextureForKey:@"finger_pos.png"];
	[textureCache removeTextureForKey:@"power_back.png"];
	[textureCache removeTextureForKey:@"power_display.png"];
	[textureCache removeTextureForKey:@"power_front.png"];
	[textureCache removeTextureForKey:@"retro_sun.png"];
	[textureCache removeTextureForKey:@"ring_l.png"];
	[textureCache removeTextureForKey:@"ring_r.png"];
	[textureCache removeTextureForKey:@"spark.png"];
	[textureCache removeTextureForKey:@"time_font.png"];	
	[textureCache removeTextureForKey:@"game_game_over.png"];
	[textureCache removeTextureForKey:@"game_level_done.png"];
	[textureCache removeTextureForKey:@"game_menu.png"];
	[textureCache removeTextureForKey:@"game_menu_p.png"];
	[textureCache removeTextureForKey:@"game_new_achievement.png"];
	[textureCache removeTextureForKey:@"game_new_highscore.png"];
	[textureCache removeTextureForKey:@"game_out_of_power.png"];
	[textureCache removeTextureForKey:@"game_outside_wire.png"];
	[textureCache removeTextureForKey:@"game_pause.png"];
	[textureCache removeTextureForKey:@"game_pause_p.png"];
	[textureCache removeTextureForKey:@"game_pause_title.png"];
	[textureCache removeTextureForKey:@"game_play.png"];
	[textureCache removeTextureForKey:@"game_play_p.png"];
	[textureCache removeTextureForKey:@"game_score_back.png"];
	[textureCache removeTextureForKey:@"game_your_highscore.png"];
	[textureCache removeTextureForKey:@"game_your_score.png"];*/
}

- (void)unloadDayTheme {
	CCTextureCache *textureCache = [CCTextureCache sharedTextureCache];
	[textureCache removeTextureForKey:@"day_clouds_bottom.png"];
	[textureCache removeTextureForKey:@"day_clouds_top.png"];
	[textureCache removeTextureForKey:@"day_mountains.png"];
	[textureCache removeTextureForKey:@"day_rainbow.png"];
	[textureCache removeTextureForKey:@"day_sky.png"];
	[textureCache removeTextureForKey:@"day_sun.png"];
}

- (void)unloadNightTheme {
	CCTextureCache *textureCache = [CCTextureCache sharedTextureCache];
	[textureCache removeTextureForKey:@"night_sky.png"];
	[textureCache removeTextureForKey:@"night_little_stars.png"];
	[textureCache removeTextureForKey:@"night_big_stars.png"];
	[textureCache removeTextureForKey:@"night_earth.png"];
	[textureCache removeTextureForKey:@"night_moon.png"];
}

@end
