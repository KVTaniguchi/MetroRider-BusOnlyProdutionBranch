//
//  KTMapFlagTracker.h
//  MetroRider
//
//  Created by Kevin Taniguchi on 6/22/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTMapFlagTracker : NSObject
@property (nonatomic) BOOL tripMonitoringActive;
@property (nonatomic) BOOL favoriteStopActive;
@property (nonatomic) BOOL startOver;
@property (nonatomic) BOOL layMapWithPlacemark;
@property (nonatomic) BOOL stopDetailViewsVisible;
@property (nonatomic) BOOL twoKFired;
@property (nonatomic) BOOL eightHundredFired;
@property (nonatomic) BOOL threeHundredFired;
@property (nonatomic) BOOL oneHundredFired;
@property (nonatomic) BOOL wrongWayPossibleFlag;
@property (nonatomic) BOOL firstWrongWayAlert;
@property (nonatomic) BOOL secondWrongWayAlert;
@property (nonatomic) BOOL thirdWrongWayAlert;

-(void)resetDistanceFlags;
-(void)resetWrongWayAlergFlags;
@end


