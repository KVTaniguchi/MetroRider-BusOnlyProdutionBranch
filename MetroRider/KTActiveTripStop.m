//
//  KTActiveTripStop.m
//  MetroRider
//
//  Created by Kevin Taniguchi on 4/16/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import "KTActiveTripStop.h"

@implementation KTActiveTripStop
@synthesize latitude, longitude, route, routeSequence, distance, stopName, direction, stopID;

-(instancetype)init{
    self = [super init];
    return self;
}

@end
