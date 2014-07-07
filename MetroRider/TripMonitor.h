//
//  TripMonitor.h
//  MetroRider
//
//  Created by Kevin Taniguchi on 4/14/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//
/*
    get route from user
    lay map coordintes
    user selects final stop
    calculate last three stops from the final stop
    make CLRegions based on the final stop
    send notifications on entering those regions
 
 
    
*/
@class TripMonitor;

#import <Foundation/Foundation.h>
@import CoreMotion;
@import CoreLocation;
#import "KTNotifyStop.h"
#import "KTRouteStopStore.h"
#import "Stop.h"
#import "Route.h"
#import "KTActiveTripStop.h"

// call a delegate
typedef void(^myCompletion)(BOOL);


@interface TripMonitor : NSObject
@property (nonatomic,strong) CMDeviceMotion *motion;
@property (nonatomic,strong) NSString *motionType;
@property (nonatomic,strong) NSMutableArray *closestActiveStops;
@property (nonatomic,strong) KTActiveTripStop *closestActiveStop;
@property (nonatomic,strong) KTActiveTripStop *thirdStopFromDest;
@property (nonatomic,strong) KTActiveTripStop *secondStopFromDest;
@property (nonatomic,strong) KTActiveTripStop *lastStopFromDest;
-(NSArray*)findNextStopsTillDestinationGivenCurrentLocation:(CLLocation*)currentLocation andFinalStop:(Stop*)finalStop;
-(void)checkClosestActiveStopToLocation:(CLLocation*)currentLocation withTripSessionStops:(NSMutableArray*)activeTripStops;
-(NSArray*)getCloseActiveTripStopsForRoute:(NSString*)route withLocation:(CLLocation*)userLoc;
//-(NSArray*)findLastThreeActiveStopsToDestination:(Stop*)finalStop GivenCurrentLocation:(CLLocation*)currentLocation;
-(void)findLastThreeActiveStopsToDestination:(Stop*)finalStop GivenCurrentLocation:(CLLocation*)currentLocation :(myCompletion)compBlock;
@end
