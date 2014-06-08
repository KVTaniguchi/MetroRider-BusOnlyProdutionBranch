//
//  DestinationLocater.m
//  MetroRider
//
//  Created by Kevin Taniguchi on 4/10/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import "DestinationLocater.h"

@implementation DestinationLocater

+(NSArray*)findNearestBusStopToDestination:(NSString*)destinationLocation inRegion:(CLRegion *)region{
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    NSMutableArray *m = [[NSMutableArray alloc]init];
    [geocoder geocodeAddressString:destinationLocation inRegion:region completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"# of places in placemark: %lu", (unsigned long)[placemarks count]);
        [m addObjectsFromArray:placemarks];
    }];
    return m;
}

@end
