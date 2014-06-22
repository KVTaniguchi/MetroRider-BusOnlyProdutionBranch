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

-(void)testTripMonitorLoadsAllActiveStopsForARoute{
    TripMonitor *testTripMonitor = [TripMonitor new];
    NSString *testRoute = @"D2";
    NSArray *testArray = [NSArray arrayWithArray:[testTripMonitor loadAllActiveTripStopsForRoute:testRoute]];
    XCTAssertNotNil(testArray, @"a test Array should not be nil");
}

@end