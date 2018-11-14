//
//  main.m
//  HotWire
//
//  Created by Oliver Klemenz on 12.11.10.
//  Copyright 2011 Oliver Klemenz. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	int retVal = UIApplicationMain(argc, argv, nil, @"HotWireAppDelegate");
	[pool release];
	return retVal;
}
