//
//  KTRouteStopStore.h
//  MetroRider
//
//  Created by Kevin Taniguchi on 4/14/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@import CoreLocation;
#import "Route.h"
#import "Stop.h"
#import "UserLoc.h"

@interface KTRouteStopStore : NSObject{
    NSManagedObjectModel *model;
    NSMutableArray *allStopsOnRouteEast;
    NSMutableArray *allStopsOnRouteWest;
    NSMutableArray *allStopsOnRouteNorth;
    NSMutableArray *allStopsOnRouteSouth;
    NSMutableArray *allStops;
    NSMutableArray *allRouteSeqNums;
}

@property (nonatomic,strong) NSManagedObjectContext *context;
+(KTRouteStopStore*)sharedStore;
-(Stop*)addNewStop;
-(Route*)addNewRouteShape;
-(UserLoc*)updateUserLoc;
-(void)clearAllStopsForRoute:(NSString*)routeID;
-(BOOL)saveChanges;
-(NSString*)itemArchivePath;
-(NSArray*)fetchAllStopsForRoute:(NSString*)route;
-(NSArray*)fetchStopsForRoute:(NSString*)routeID andDirection:(NSString*)direction;
-(NSArray*)fetchShapeForRoute:(NSString*)route andDirection:(NSString*)direction;
-(NSArray*)allStops;
-(NSArray*)fetchFavoriteStops;
-(NSMutableArray*)fetchRoutesWithStopsCloseToUserLoc:(CLLocation*)userLoc;
-(UserLoc*)fetchUserLoc;

-(NSArray*)fetchAllStopsForStopID:(NSString*)stopID;
-(BOOL)storeHasStopForRoute:(NSString *)route andStopID:(NSString *)stopID;

-(BOOL)storeContainsRouteDataForRoute:(NSString*)route;
-(Stop*)fetchStopForStopID:(NSString*)stopID;
-(Stop*)fetchStopForStopID:(NSString *)stopID andRoute:(NSString*)route;
-(Stop*)fetchStopForStopName:(NSString *)name andRoute:(NSString*)route direction:(NSString*)dir;
-(Stop*)fetchStopForStopName:(NSString *)name andRoute:(NSString*)route direction:(NSString*)dir sequence:(NSNumber*)seq;
@end