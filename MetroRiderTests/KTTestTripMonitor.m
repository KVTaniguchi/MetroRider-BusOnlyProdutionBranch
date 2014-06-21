//
//  KTTestTripMonitor.m
//  MetroRider
//
//  Created by Kevin Taniguchi on 6/21/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TripMonitor.h"

@interface KTTestTripMonitor : XCTestCase

@end

@implementation KTTestTripMonitor

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testGetClosestActiveTripStopsForRoute{
    
}

@end

//-(NSArray*)getCloseActiveTripStopsForRoute:(NSString*)route withLocation:(CLLocation*)userLoc{
//    NSMutableArray *northBoundStops = [[NSMutableArray alloc]init];
//    NSMutableArray *southBoundStops = [[NSMutableArray alloc]init];
//    NSMutableArray *eastBoundStops = [[NSMutableArray alloc]init];
//    NSMutableArray *westBoundStops = [[NSMutableArray alloc]init];
//    NSMutableArray *closestStops = [[NSMutableArray alloc]init];
//    NSArray *tempAllKTActiveStopsOnRoute = [self loadAllActiveTripStopsForRoute:route];
//    
//    // check tempAllKTActiveStopsOnRoute for each direction
//    
//    for (KTActiveTripStop *stop in tempAllKTActiveStopsOnRoute) {
//        if ([stop.direction isEqualToString:@"NORTH"]) {
//            [northBoundStops addObject:stop];
//        }
//        if ([stop.direction isEqualToString:@"SOUTH"]) {
//            [southBoundStops addObject:stop];
//        }
//        if ([stop.direction isEqualToString:@"EAST"]) {
//            [eastBoundStops addObject:stop];
//        }
//        if ([stop.direction isEqualToString:@"WEST"]) {
//            [westBoundStops addObject:stop];
//        }
//    }
//    
//    
//    if ([northBoundStops count] > 0) {
//        [closestStops addObject:[self getClosestStopToUserLoc:userLoc WithStops:northBoundStops]];
//    }
//    if ([southBoundStops count] > 0) {
//        [closestStops addObject:[self getClosestStopToUserLoc:userLoc WithStops:southBoundStops]];
//    }
//    if ([eastBoundStops count] > 0) {
//        [closestStops addObject:[self getClosestStopToUserLoc:userLoc WithStops:eastBoundStops]];
//    }
//    if ([westBoundStops count] > 0) {
//        [closestStops addObject:[self getClosestStopToUserLoc:userLoc WithStops:westBoundStops]];
//    }
//    return closestStops;
//}
