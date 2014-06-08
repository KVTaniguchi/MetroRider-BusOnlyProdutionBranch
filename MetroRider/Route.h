//
//  Route.h
//  MetroRider
//
//  Created by Kevin Taniguchi on 5/9/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Route : NSManagedObject

@property (nonatomic, retain) NSString * direction;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lon;
@property (nonatomic, retain) NSString * routeLabel;
@property (nonatomic, retain) NSNumber * sequence;

@end
