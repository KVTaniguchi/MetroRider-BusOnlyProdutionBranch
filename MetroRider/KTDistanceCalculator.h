//
//  KTDistanceCalculator.h
//  MetroRider
//
//  Created by Kevin Taniguchi on 6/18/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TripMonitor.h"
#import "KTNotifyStop.h"

@import CoreLocation;

@interface KTDistanceCalculator : NSObject
@property (nonatomic, strong) TripMonitor *tripMonitor;
@property (nonatomic,strong) CLLocation *currentLocation;
@property (nonatomic,strong) CLLocation *destinationLocation;
@property (nonatomic) BOOL wrongWayPossibleFlag;
@property (nonatomic) BOOL firstWrongWayAlert;
@property (nonatomic) BOOL secondWrongWayAlert;
@property (nonatomic) BOOL thirdWrongWayAlert;
@property (nonatomic) BOOL twoKFired;
@property (nonatomic) BOOL eightHundredFired;
@property (nonatomic) BOOL threeHundredFired;
@property (nonatomic) BOOL oneHundredFired;
// _stopsInWrongDirection
// delegates to make calls to change the locationManager
// delegate to signal trip is over

@end