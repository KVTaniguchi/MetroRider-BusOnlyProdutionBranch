//
//  KTRouteStopStore.m
//  MetroRider
//
//  Created by Kevin Taniguchi on 4/14/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.

#import "KTRouteStopStore.h"

@implementation KTRouteStopStore
@synthesize context;

+(KTRouteStopStore*)sharedStore{
    static KTRouteStopStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil]init];
    }
    return sharedStore;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedStore];
}

-(instancetype)init{
    self = [super init];
    if (self) {
        model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSURL *documentsDirectory = [[[NSFileManager defaultManager]URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject];
        NSURL *storeURL = [documentsDirectory URLByAppendingPathComponent:@"CoreData.sqlite"];
        NSError *error = nil;
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
        NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES, @"MetroRiderCloudStore": NSPersistentStoreUbiquitousContentNameKey};
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
            [NSException raise:@"Open failed" format:@"Reason: %@", [error localizedDescription]];
        }
        context = [[NSManagedObjectContext alloc]init];
        [context setPersistentStoreCoordinator:psc];
        [context setUndoManager:nil];
        allStops =[[NSMutableArray alloc]init];
        allStopsOnRouteEast = [[NSMutableArray alloc]init];
        allStopsOnRouteWest = [[NSMutableArray alloc]init];
        allStopsOnRouteNorth = [[NSMutableArray alloc]init];
        allStopsOnRouteSouth = [[NSMutableArray alloc]init];
    }
    return self;
}

-(NSArray*)allStops{
    return allStops;
}


-(Route*)addNewRouteShape{
    Route *r = [NSEntityDescription insertNewObjectForEntityForName:@"Route" inManagedObjectContext:context];
    return r;
}

-(Stop*)addNewStop{
    Stop *s = [NSEntityDescription insertNewObjectForEntityForName:@"Stop" inManagedObjectContext:context];
    [allStops addObject:s];
    return s;
}

-(UserLoc*)updateUserLoc{
    UserLoc *userLocation = [NSEntityDescription insertNewObjectForEntityForName:@"UserLoc" inManagedObjectContext:context];
    return userLocation;
}

-(void)clearAllStopsForRoute:(NSString*)routeID{
    
}

-(BOOL)saveChanges{
    NSError *error = nil;
    BOOL success = [[KTRouteStopStore sharedStore].context save:&error];
    if (!success) {
        NSLog(@"error saving: %@", [error localizedDescription]);
    }
    return success;
}

-(NSString*)itemArchivePath{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = documentDirectories[0];
    return [documentDirectory stringByAppendingString:@"storeRoute.data"];
}

-(NSArray*)fetchAllStopsForRoute:(NSString*)route{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Stop" inManagedObjectContext:[KTRouteStopStore sharedStore].context];
    NSPredicate *predicateRoute = [NSPredicate predicateWithFormat:@"route = %@", route];
    [request setPredicate:predicateRoute];
    [request setEntity:entity];
    NSError *error;
    NSArray *fetchedRoute = [[KTRouteStopStore sharedStore].context executeFetchRequest:request error:&error];
    return fetchedRoute;
}

-(NSArray*)fetchStopsForRoute:(NSString *)route andDirection:(NSString *)direction{
    NSSortDescriptor *upSequenceRoute = [NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES];
    NSArray *sortDescriptors = @[upSequenceRoute];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Stop" inManagedObjectContext:[KTRouteStopStore sharedStore].context];
    NSPredicate *predicateRoute = [NSPredicate predicateWithFormat:@"route = %@", route];
    NSPredicate *predicateDirection = [NSPredicate predicateWithFormat:@"direction = %@", direction];
    NSArray *predicateArray = @[predicateRoute,predicateDirection];
    NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicateArray];
    [request setPredicate:compoundPredicate];
    [request setSortDescriptors:sortDescriptors];
    [request setEntity:entity];
    NSError *error;
    NSArray *fetchedRoute = [[KTRouteStopStore sharedStore].context executeFetchRequest:request error:&error];
    return fetchedRoute;
}

-(BOOL)storeHasStopForRoute:(NSString *)route andStopID:(NSString *)stopID{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Stop" inManagedObjectContext:[KTRouteStopStore sharedStore].context];
    NSPredicate *predicateRoute = [NSPredicate predicateWithFormat:@"route = %@", route];
    NSPredicate *predicateStopID = [NSPredicate predicateWithFormat:@"stopID = %@", stopID];
    NSArray *predicateArray = @[predicateRoute,predicateStopID];
    NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicateArray];
    [request setPredicate:compoundPredicate];
    [request setEntity:entity];
    NSError *error;
    NSArray *fetchedStops = [[KTRouteStopStore sharedStore].context executeFetchRequest:request error:&error];
    if ([fetchedStops count] > 0) {
        return YES;
    }
    else return NO;
}

-(NSArray*)fetchShapeForRoute:(NSString *)route andDirection:(NSString *)direction{
    NSSortDescriptor *upSequenceRoute = [NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES];
    NSArray *sortDescriptors = @[upSequenceRoute];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Route" inManagedObjectContext:[KTRouteStopStore sharedStore].context];
    NSPredicate *predicateRoute = [NSPredicate predicateWithFormat:@"routeLabel = %@", route];
    NSPredicate *predicateDirection = [NSPredicate predicateWithFormat:@"direction = %@", direction];
    NSArray *predicateArray = @[predicateRoute,predicateDirection];
    NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicateArray];
    [request setPredicate:compoundPredicate];
    [request setSortDescriptors:sortDescriptors];
    [request setEntity:entity];
    NSError *error;
    NSArray *fetchedRoute = [[KTRouteStopStore sharedStore].context executeFetchRequest:request error:&error];
    return fetchedRoute;
}

-(Stop*)fetchStopForStopID:(NSString*)stopID{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Stop" inManagedObjectContext:[KTRouteStopStore sharedStore].context];
    NSPredicate *predicateStopID = [NSPredicate predicateWithFormat:@"stopID = %@", stopID];
    [request setPredicate:predicateStopID];
    [request setEntity:entity];
    NSError *error;
    NSArray *fetchedRoute = [[KTRouteStopStore sharedStore].context executeFetchRequest:request error:&error];
    return [fetchedRoute lastObject];
}

-(NSArray*)fetchAllStopsForStopID:(NSString*)stopID{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Stop" inManagedObjectContext:[KTRouteStopStore sharedStore].context];
    NSPredicate *predicateStopID = [NSPredicate predicateWithFormat:@"stopID = %@", stopID];
    [request setPredicate:predicateStopID];
    [request setEntity:entity];
    NSError *error;
    NSArray *fetchedRoute = [[KTRouteStopStore sharedStore].context executeFetchRequest:request error:&error];
    return fetchedRoute;
}

-(BOOL)storeContainsRouteDataForRoute:(NSString *)route{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Stop" inManagedObjectContext:[KTRouteStopStore sharedStore].context];
    NSPredicate *predicateRoute = [NSPredicate predicateWithFormat:@"route == %@", route];
    [request setPredicate:predicateRoute];
    [request setEntity:entity];
    NSError *error;
    NSArray *fetchedRoute = [[KTRouteStopStore sharedStore].context executeFetchRequest:request error:&error];
    if ([fetchedRoute count] > 0) {
        return YES;
    }
    else return NO;
}

-(Stop*)fetchStopForStopID:(NSString *)stopID andRoute:(NSString*)route{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Stop" inManagedObjectContext:[KTRouteStopStore sharedStore].context];
    NSPredicate *predicateStopID = [NSPredicate predicateWithFormat:@"stopID = %@", stopID];
    NSPredicate *predicateRoute = [NSPredicate predicateWithFormat:@"route = %@", route];
    NSArray *predicateArray = @[predicateStopID, predicateRoute];
    NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicateArray];
    [request setPredicate:compoundPredicate];
    [request setEntity:entity];
    NSError *error;
    NSArray *fetchedRoute = [[KTRouteStopStore sharedStore].context executeFetchRequest:request error:&error];
    return [fetchedRoute lastObject];
}

-(Stop*)fetchStopForStopName:(NSString *)name andRoute:(NSString*)route direction:(NSString*)dir sequence:(NSNumber*)seq{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Stop" inManagedObjectContext:[KTRouteStopStore sharedStore].context];
    NSPredicate *predicateName = [NSPredicate predicateWithFormat:@"stopName = %@", name];
    NSPredicate *predicateRoute = [NSPredicate predicateWithFormat:@"route = %@", route];
    NSPredicate *predicateDirection = [NSPredicate predicateWithFormat:@"direction = %@", dir];
    NSPredicate *predicateSequence = [NSPredicate predicateWithFormat:@"sequence = %@", seq];
    NSArray *predicateArray = @[predicateName, predicateRoute, predicateDirection, predicateSequence];
    NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicateArray];
    [request setPredicate:compoundPredicate];
    [request setEntity:entity];
    NSError *error;
    NSArray *fetchedRoute = [[KTRouteStopStore sharedStore].context executeFetchRequest:request error:&error];
    return [fetchedRoute lastObject];
}

-(Stop*)fetchStopForStopName:(NSString *)name andRoute:(NSString*)route direction:(NSString*)dir{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Stop" inManagedObjectContext:[KTRouteStopStore sharedStore].context];
    NSPredicate *predicateName = [NSPredicate predicateWithFormat:@"stopName = %@", name];
    NSPredicate *predicateRoute = [NSPredicate predicateWithFormat:@"route = %@", route];
    NSPredicate *predicateDirection = [NSPredicate predicateWithFormat:@"direction = %@", dir];
    NSArray *predicateArray = @[predicateName, predicateRoute, predicateDirection];
    NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicateArray];
    [request setPredicate:compoundPredicate];
    [request setEntity:entity];
    NSError *error;
    NSArray *fetchedRoute = [[KTRouteStopStore sharedStore].context executeFetchRequest:request error:&error];
    return [fetchedRoute lastObject];
}

-(NSArray*)fetchFavoriteStops{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Stop" inManagedObjectContext:[KTRouteStopStore sharedStore].context];
    NSPredicate *predicateFavorite = [NSPredicate predicateWithFormat:@"favorite = %d", 1];
    [request setPredicate:predicateFavorite];
    [request setEntity:entity];
    NSError *error;
    NSArray *fetchedRoute = [[KTRouteStopStore sharedStore].context executeFetchRequest:request error:&error];
    return fetchedRoute;
}

-(NSMutableArray*)fetchRoutesWithStopsCloseToUserLoc:(CLLocation*)userLoc{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Stop" inManagedObjectContext:[KTRouteStopStore sharedStore].context];
    [request setEntity:entity];
    NSError *error;
    NSArray *fetchedStops = [[KTRouteStopStore sharedStore].context executeFetchRequest:request error:&error];
    NSMutableArray *closestRoutes = [[NSMutableArray alloc]init];
    for (Stop *stop in fetchedStops) {
        CLLocation *stopLoc = [[CLLocation alloc]initWithLatitude:[stop.latitude floatValue] longitude:[stop.longitude floatValue]];
        if([userLoc distanceFromLocation:stopLoc] < 500){
            [closestRoutes addObject:stop.route];
        }
    }
    return closestRoutes;
}

-(UserLoc*)fetchUserLoc{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserLoc" inManagedObjectContext:[KTRouteStopStore sharedStore].context];
    [request setEntity:entity];
    NSError *error;
    NSArray *fetchedUserLocs = [[KTRouteStopStore sharedStore].context executeFetchRequest:request error:&error];
    UserLoc *fetchedUserLoc = [fetchedUserLocs lastObject];
    return fetchedUserLoc;
}

@end
