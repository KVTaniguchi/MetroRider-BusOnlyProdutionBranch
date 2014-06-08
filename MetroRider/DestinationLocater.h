//
//  DestinationLocater.h
//  MetroRider
//
//  Created by Kevin Taniguchi on 4/10/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface DestinationLocater : NSObject
+(NSArray*)findNearestBusStopToDestination:(NSString*)destinationLocation inRegion:(CLRegion*)region;
@end
