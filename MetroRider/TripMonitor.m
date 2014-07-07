//
//  TripMonitor.m
//  MetroRider
//
//  Created by Kevin Taniguchi on 4/14/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import "TripMonitor.h"

@implementation TripMonitor

-(NSMutableArray*)loadAllActiveTripStopsForRoute:(NSString*)route{
    NSArray *allStopsOnDestRoute = [[KTRouteStopStore sharedStore]fetchAllStopsForRoute:route];
    NSMutableArray *activeStops = [[NSMutableArray alloc]init];
    for (Stop *stop in allStopsOnDestRoute) {
        KTActiveTripStop *activeStop = [[KTActiveTripStop alloc]init];
        activeStop.route = stop.route;
        activeStop.latitude = stop.latitude;
        activeStop.longitude = stop.longitude;
        activeStop.routeSequence = stop.sequence;
        activeStop.stopName = stop.stopName;
        activeStop.direction = stop.direction;
        activeStop.stopID = stop.stopID;
        [activeStops addObject:activeStop];
    }
    return activeStops;
}

-(NSArray*)getCloseActiveTripStopsForRoute:(NSString*)route withLocation:(CLLocation*)userLoc{
    NSMutableArray *northBoundStops = [[NSMutableArray alloc]init];
    NSMutableArray *southBoundStops = [[NSMutableArray alloc]init];
    NSMutableArray *eastBoundStops = [[NSMutableArray alloc]init];
    NSMutableArray *westBoundStops = [[NSMutableArray alloc]init];
    NSMutableArray *closestStops = [[NSMutableArray alloc]init];
    NSArray *tempAllKTActiveStopsOnRoute = [self loadAllActiveTripStopsForRoute:route];
  
    for (KTActiveTripStop *stop in tempAllKTActiveStopsOnRoute) {
        if ([stop.direction isEqualToString:@"NORTH"]) {
            [northBoundStops addObject:stop];
        }
        if ([stop.direction isEqualToString:@"SOUTH"]) {
            [southBoundStops addObject:stop];
        }
        if ([stop.direction isEqualToString:@"EAST"]) {
            [eastBoundStops addObject:stop];
        }
        if ([stop.direction isEqualToString:@"WEST"]) {
            [westBoundStops addObject:stop];
        }
    }

    if ([northBoundStops count] > 0) {
        [closestStops addObject:[self getClosestStopToUserLoc:userLoc WithStops:northBoundStops]];
    }
    if ([southBoundStops count] > 0) {
        [closestStops addObject:[self getClosestStopToUserLoc:userLoc WithStops:southBoundStops]];
    }
    if ([eastBoundStops count] > 0) {
        [closestStops addObject:[self getClosestStopToUserLoc:userLoc WithStops:eastBoundStops]];
    }
    if ([westBoundStops count] > 0) {
        [closestStops addObject:[self getClosestStopToUserLoc:userLoc WithStops:westBoundStops]];
    }
    return closestStops;
}

-(KTActiveTripStop*)getClosestStopToUserLoc:(CLLocation*)userLoc WithStops:(NSMutableArray*)stops{
    for (KTActiveTripStop *stop in stops) {
        CLLocation *activeStopLocation = [[CLLocation alloc]initWithLatitude:[stop.latitude floatValue] longitude:[stop.longitude floatValue]];
        CLLocationDistance distance = [userLoc distanceFromLocation:activeStopLocation];
        stop.distance = @(distance);
    }
    NSSortDescriptor *sortByDistance = [NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES];
    [stops sortUsingDescriptors:@[sortByDistance]];
    return [stops firstObject];
}

-(KTActiveTripStop*)getClosestActiveTripStop:(NSMutableArray*)activeTripStops currentLocation:(CLLocation*)location inDistance:(double)minDistance{
    double min = minDistance;
    KTActiveTripStop *closestActiveStop = [[KTActiveTripStop alloc]init];
    for (KTActiveTripStop *activeStop in activeTripStops) {
        CLLocation *activeStopLocation = [[CLLocation alloc]initWithLatitude:[activeStop.latitude floatValue] longitude:[activeStop.longitude floatValue]];
        CLLocationDistance distance = [location distanceFromLocation:activeStopLocation];
        activeStop.distance = @(distance);
        int x = [activeStop.distance intValue];
        if (x < min) {
            min = x;
        }
    }
    for (KTActiveTripStop *activeStop in activeTripStops) {
        if ((int)min == [activeStop.distance intValue]) {
            closestActiveStop = activeStop;
        }
    }
    return closestActiveStop;
}

-(void)checkClosestActiveStopToLocation:(CLLocation*)currentLocation withTripSessionStops:(NSMutableArray*)activeTripStops{
    self.closestActiveStop = [self getClosestActiveTripStop:self.closestActiveStops currentLocation:currentLocation inDistance:1000];
}

-(void)findLastThreeActiveStopsToDestination:(Stop*)finalStop GivenCurrentLocation:(CLLocation*)currentLocation :(myCompletion) compBlock{
    NSArray *allStopsOnDestRoute = [[KTRouteStopStore sharedStore]fetchStopsForRoute:finalStop.route andDirection:finalStop.direction];
    NSMutableArray *activeStops = [NSMutableArray new];
    NSNumber *index;
    for (Stop *stop in allStopsOnDestRoute) {
        KTActiveTripStop *activeStop = [KTActiveTripStop new];
        activeStop.route = stop.route;
        activeStop.latitude = stop.latitude;
        activeStop.longitude = stop.longitude;
        activeStop.routeSequence = stop.sequence;
        activeStop.stopName = stop.stopName;
        activeStop.direction = stop.direction;
        activeStop.stopID = stop.stopID;
        [activeStops addObject:activeStop];
        if ([finalStop.stopName isEqualToString:stop.stopName] && [finalStop.stopID isEqualToString:stop.stopID]) {
            index = stop.sequence;
        }
    }
    int thirdStopSeq = [index intValue] - 3;
    int secondStopSeq = [index intValue] - 2;
    int lastStopSeq = [index intValue] - 1;
    for (KTActiveTripStop *activeStop in activeStops) {
        if ([activeStop.routeSequence intValue] == thirdStopSeq) {
            self.thirdStopFromDest = activeStop;
        }
        else if ([activeStop.routeSequence intValue] == secondStopSeq){
            self.secondStopFromDest = activeStop;
        }
        else if ([activeStop.routeSequence intValue] == lastStopSeq){
            self.lastStopFromDest = activeStop;
        }
    }
    compBlock(YES);
}



-(NSArray*)findNextStopsTillDestinationGivenCurrentLocation:(CLLocation *)currentLocation andFinalStop:(Stop *)finalStop{
    NSArray *allStopsOnDestRoute = [[KTRouteStopStore sharedStore]fetchStopsForRoute:finalStop.route andDirection:finalStop.direction];
    NSMutableArray *activeStops = [[NSMutableArray alloc]init];
    for (Stop *stop in allStopsOnDestRoute) {
        KTActiveTripStop *activeStop = [[KTActiveTripStop alloc]init];
        activeStop.route = stop.route;
        activeStop.latitude = stop.latitude;
        activeStop.longitude = stop.longitude;
        activeStop.routeSequence = stop.sequence;
        activeStop.stopName = stop.stopName;
        activeStop.direction = stop.direction;
        activeStop.stopID = stop.stopID;
        [activeStops addObject:activeStop];
    }
    int thirdStopSeq = [finalStop.sequence intValue] - 3;
    int secondStopSeq = [finalStop.sequence intValue] - 2;
    int lastStopSeq = [finalStop.sequence intValue] - 1;
    for (KTActiveTripStop *activeStop in activeStops) {
        if ([activeStop.routeSequence intValue] == thirdStopSeq) {
            self.thirdStopFromDest = activeStop;
        }
        else if ([activeStop.routeSequence intValue] == secondStopSeq){
            self.secondStopFromDest = activeStop;
        }
        else if ([activeStop.routeSequence intValue] == lastStopSeq){
            self.lastStopFromDest = activeStop;
        }
    }
    int min = 2000;
    self.closestActiveStop = [[KTActiveTripStop alloc]init];
    for (KTActiveTripStop *activeStop in activeStops) {
        CLLocation *activeStopLocation = [[CLLocation alloc]initWithLatitude:[activeStop.latitude floatValue] longitude:[activeStop.longitude floatValue]];
        CLLocationDistance distance = [currentLocation distanceFromLocation:activeStopLocation];
        activeStop.distance = @(distance);
        int x = [activeStop.distance intValue];
        if (x < min) {
            min = x;
        }
    }
    for (KTActiveTripStop *activeStop in activeStops) {
        if ((int)min == [activeStop.distance intValue]) {
            self.closestActiveStop = activeStop;
        }
    }
    self.closestActiveStops = [[NSMutableArray alloc]init];
    int closestActiveStopSeqNum = [self.closestActiveStop.routeSequence intValue];
    int finalStopSeqNum = [finalStop.sequence intValue];
    for (KTActiveTripStop *actStop in activeStops) {
        int actStopSeqNum = [actStop.routeSequence intValue];
        if (actStopSeqNum > closestActiveStopSeqNum && actStopSeqNum < finalStopSeqNum) {
            [self.closestActiveStops addObject:actStop];
        }
    }
    return self.closestActiveStops;
}

@end
