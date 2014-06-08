//
//  KTDataLoader.m
//  MetroRider
//
//  Created by Kevin Taniguchi on 4/8/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//
#import "KTDataLoader.h"

static NSString *railLinesDataURL = @"http://api.wmata.com/Rail.svc/json/jLines?api_key=kfgpmgvfgacx98de9q3xazww";
static NSString *stationsForLineURL = @"http://api.wmata.com/Rail.svc/json/jStations?LineCode=RD&api_key=nhs8f5mgyvbcstvyest37h55";
// @"http://api.wmata.com/Bus.svc/json/jStops?lat=%f&lon=%f&radius=1000&api_key=nhs8f5mgyvbcstvyest37h55"

@implementation KTDataLoader
@synthesize ktDataLoaderDelegate, uniqueRoutesCloseToUser, numOfUniqueRoutesCloseToUser, allMetroBusRoutes, hasConnection;

-(void)findBusRouteGivenLatLon:(float)lat andLong:(float)lon{
    static NSURLSession *findSession = nil;
    NSString *urlString = [NSString stringWithFormat:@"http://api.wmata.com/Bus.svc/json/jStops?lat=%f&lon=%f&radius=500&api_key=nhs8f5mgyvbcstvyest37h55", lat, lon];
    NSURL *urlForBusStops = [NSURL URLWithString:urlString];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        findSession = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    });
    NSURLSessionDataTask *dataTask = [findSession dataTaskWithURL:urlForBusStops completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"error: %@", [error localizedDescription]);
            [[self ktDataLoaderDelegate] checkInternetConnectionWarning];
            self.hasConnection = NO;
        }
        else{
            self.hasConnection = YES;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSDictionary *stops = json[@"Stops"];
            if ([stops count] > 0) {
                for (NSDictionary *d in stops) {
                [self.uniqueRoutesCloseToUser addObjectsFromArray:d[@"Routes"]];
                }
            }
            self.numOfUniqueRoutesCloseToUser = [NSNumber numberWithInteger:[self.uniqueRoutesCloseToUser count]];
        }
    }];
        
    [dataTask resume];
}

-(void)getAllBusRoutes{
    static NSURLSession *busSession = nil;
    NSString *busAddress = [NSString stringWithFormat:@"http://api.wmata.com/Bus.svc/json/jRoutes?api_key=nhs8f5mgyvbcstvyest37h55"];
    NSURL *busURL = [NSURL URLWithString:busAddress];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *busSessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        busSession = [NSURLSession sessionWithConfiguration:busSessionConfig];
    });
    NSURLSessionDataTask *busDataTask = [busSession dataTaskWithURL:busURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *busJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSDictionary *routes = busJSON[@"Routes"];
        NSMutableArray *routeIDs = [[NSMutableArray alloc]init];
        for (NSDictionary *routeData in routes) {
            NSString *route = routeData[@"RouteID"];
            NSRange vRange = [route rangeOfString:@"v"];
            NSRange cRange = [route rangeOfString:@"c"];
            if (vRange.location == NSNotFound && cRange.location == NSNotFound) {
                [routeIDs addObject:route];
            }
        }
        NSSet *uniqueRoutes = [NSSet setWithArray:routeIDs];
        self.allMetroBusRoutes = [[NSMutableArray alloc]initWithArray:[uniqueRoutes allObjects]];
        [self loadAllRouteCoordsFromAllMetroBusRoutes:self.allMetroBusRoutes];
    }];
    [busDataTask resume];
}

-(void)loadAllRouteCoordsFromAllMetroBusRoutes:(NSMutableArray*)allRoutes{
    if ([allRoutes count] == 0) {
        return;
    }else{
        if ([[KTRouteStopStore sharedStore]storeContainsRouteDataForRoute:[allRoutes firstObject]]==NO) {
            [self loadRouteCoordsForBusRouteID:[allRoutes firstObject] :^(BOOL finished) {
                if (finished) {
                    [allRoutes removeObject:[allRoutes firstObject]];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        return [self loadAllRouteCoordsFromAllMetroBusRoutes:allRoutes];
                    });
                }
            }];
        }
    }
}

-(void)loadRouteCoordsForBusRouteID:(NSString*)busRouteID :(myCompletion)compBlock{
    if ([[KTRouteStopStore sharedStore]storeContainsRouteDataForRoute:busRouteID] == YES) {
        compBlock(YES);
        return;
    }
    static NSURLSession *loadSession = nil;
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *currentDate = [NSDate date];
    NSString *currentDateString = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:currentDate]];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        loadSession = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    });
    NSString *busAPIURL = [NSString stringWithFormat:@"http://api.wmata.com/Bus.svc/json/jRouteDetails?routeId=%@&date=%@&api_key=nhs8f5mgyvbcstvyest37h55", busRouteID, currentDateString];
    NSURLSessionDataTask *datatask = [loadSession dataTaskWithURL:[NSURL URLWithString:busAPIURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (!error) {
        NSLog(@"no error");
    }else{
        NSLog(@"%@", [error localizedDescription]);
    }
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSString *direction0 = [NSString stringWithFormat:@"%@", json[@"Direction0"]];
    if ([direction0 isEqualToString:@"<null>"]) {
    }else{
        NSDictionary *directionZero = json[@"Direction0"];
        NSString *directionZeroDir = directionZero[@"DirectionText"];
        NSArray *directionZeroStops = directionZero[@"Stops"];
        int j = 0;
        for (NSDictionary *busStop in directionZeroStops){
            NSString *stopID = busStop[@"StopID"];
            if (![[KTRouteStopStore sharedStore]storeHasStopForRoute:busRouteID andStopID:stopID]) {
                Stop *newStop = [[KTRouteStopStore sharedStore]addNewStop];
                newStop.stopID = busStop[@"StopID"];
                newStop.direction = directionZeroDir;
                newStop.route = busRouteID;
                newStop.latitude = busStop[@"Lat"];
                newStop.longitude = busStop[@"Lon"];
                newStop.stopName = busStop[@"Name"];
                newStop.sequence = @(j);
                j++;
                [[KTRouteStopStore sharedStore]saveChanges];
                }
            }
        }
    NSString *direction1 = [NSString stringWithFormat:@"%@", json[@"Direction1"]];
    if (![direction1 isEqualToString:@"<null>"]) {
        NSDictionary *directionOne = json[@"Direction1"];
        NSString *directionOneDir = directionOne[@"DirectionText"];
        NSArray *directionOneStops = directionOne[@"Stops"];
        int k = 0;
        for (NSDictionary *busStop in directionOneStops){
            NSString *stopID = busStop[@"StopID"];
            if (![[KTRouteStopStore sharedStore]storeHasStopForRoute:busRouteID andStopID:stopID]) {
                Stop *newStop = [[KTRouteStopStore sharedStore]addNewStop];
                newStop.stopID = busStop[@"StopID"];
                newStop.direction = directionOneDir;
                newStop.route = busRouteID;
                newStop.latitude = busStop[@"Lat"];
                newStop.longitude = busStop[@"Lon"];
                newStop.stopName = busStop[@"Name"];
                newStop.sequence = @(k);
                k++;
                [[KTRouteStopStore sharedStore]saveChanges];
                }
            }
        }
        compBlock(YES);
    }];
    [datatask resume];
}




@end
