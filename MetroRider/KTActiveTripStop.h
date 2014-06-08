//
//  KTActiveTripStop.h
//  MetroRider
//
//  Created by Kevin Taniguchi on 4/16/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTActiveTripStop : NSObject
@property (nonatomic,strong) NSString *route;
@property (nonatomic) NSNumber *latitude;
@property (nonatomic) NSNumber *longitude;
@property (nonatomic) NSNumber *distance;
@property (nonatomic) NSNumber *routeSequence;
@property (nonatomic,strong) NSString *stopName;
@property (nonatomic,strong) NSString *direction;
@property (nonatomic,strong) NSString *stopID;
@end
