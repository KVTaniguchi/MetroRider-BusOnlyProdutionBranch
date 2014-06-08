//
//  KTAnnotationPoint.h
//  MetroRider
//
//  Created by Kevin Taniguchi on 4/19/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface KTAnnotationPoint : MKPointAnnotation
@property (nonatomic,strong) NSString *stopID;
@property (nonatomic,strong) NSString *direction;
@property (nonatomic,strong) NSString *stopName;
@property (nonatomic,strong) NSString *route;
@property (nonatomic) BOOL isFavorite;
@end
