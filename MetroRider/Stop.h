//
//  Stop.h
//  MetroRider
//
//  Created by Kevin Taniguchi on 5/9/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Stop : NSManagedObject

@property (nonatomic, retain) NSString * direction;
@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * route;
@property (nonatomic, retain) NSNumber * sequence;
@property (nonatomic, retain) NSString * stopID;
@property (nonatomic, retain) NSString * stopName;

@end
