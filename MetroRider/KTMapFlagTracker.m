//
//  KTMapFlagTracker.m
//  MetroRider
//
//  Created by Kevin Taniguchi on 6/22/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import "KTMapFlagTracker.h"

@implementation KTMapFlagTracker

-(void)resetDistanceFlags{
    _twoKFired = NO;
    _eightHundredFired = NO;
    _threeHundredFired = NO;
    _oneHundredFired = NO;
}

-(void)resetWrongWayAlergFlags{
    _firstWrongWayAlert = NO;
    _secondWrongWayAlert = NO;
    _thirdWrongWayAlert = NO;
}

@end
