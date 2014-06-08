//
//  KTDataLoader.h
//  MetroRider
//
//  Created by Kevin Taniguchi on 4/8/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

/*
    get wmata data to where - to core data and do fetches against it?
*/
@class KTDataLoader;
@protocol KTDataLoaderDelegate <NSObject>
@required
-(void)checkInternetConnectionWarning;
@end

#import <Foundation/Foundation.h>
@import CoreLocation;
@import CoreData;
#import "Stop.h"
#import "Route.h"
#import "KTRouteStopStore.h"

typedef void(^myCompletion)(BOOL);

@interface KTDataLoader : NSObject <NSURLSessionDataDelegate>
@property (nonatomic,weak) id <KTDataLoaderDelegate> ktDataLoaderDelegate;
@property (nonatomic,strong) CLLocation *location;
@property (nonatomic,strong) NSString *nearestBus;
@property (nonatomic,strong) NSString *nearestMetro;
@property (nonatomic,strong) NSMutableSet *uniqueRoutesCloseToUser;
@property (nonatomic,strong) NSMutableArray *allMetroBusRoutes;
@property (nonatomic,strong) NSNumber *numOfUniqueRoutesCloseToUser;
@property (nonatomic) BOOL hasConnection;
-(void)findBusRouteGivenLatLon:(float)lat andLong:(float)lon;
-(void)loadRouteCoordsForBusRouteID:(NSString*)busRouteID :(myCompletion)compBlock;
-(void)getAllBusRoutes;
@end
