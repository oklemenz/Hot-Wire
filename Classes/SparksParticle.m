//
//  SparksParticle.m
//  HotWire
//
//  Created by Oliver Klemenz on 23.11.10.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#import "SparksParticle.h"

@implementation SparksParticle

- (id)initParticleAtPos:(CGPoint)pos {
	if ((self = [super initWithTotalParticles:100])) {
		self.duration = 0.2;
		self.life = 0.2;
		self.lifeVar = 0.15;
		self.startSize = 16;
		self.startSizeVar = 4;
		self.endSize = 0;
		self.endSizeVar = 0;
		self.angle = 0;
		self.angleVar = 360;
		self.speed = 572;
		self.speedVar = 230.2;
		self.gravity = ccp(-10, -3);
		self.radialAccel = 0;
		self.radialAccelVar = 0;
		self.tangentialAccel = 0;
		self.tangentialAccelVar = 0;
		self.emissionRate = self.totalParticles / self.life;
		self.startColor = (ccColor4F) { 1.0f, 1.0f, 0.6f, 1.0f }; 
		self.startColorVar = (ccColor4F) { 0.0f, 0.0f, 0.0f, 1.0f };
		self.endColor = (ccColor4F) { 0.9f, 0.5f, 0.0f, 1.0f }; 
		self.endColorVar = (ccColor4F) { 0.0f, 0.0f, 0.0f, 0.0f };
		self.blendFunc = (ccBlendFunc)  { GL_ONE, GL_ONE };
		self.blendAdditive = YES;
		self.texture = [[CCTextureCache sharedTextureCache] addImage:@"spark.png"];
		self.posVar = CGPointZero;
		self.position = pos;
	}
	return self;
}

@end
