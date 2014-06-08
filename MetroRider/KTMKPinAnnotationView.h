//
//  KTMKPinAnnotationView.h
//  MetroRider
//
//  Created by Kevin Taniguchi on 4/19/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "KTAnnotationPoint.h"

@interface KTMKPinAnnotationView : MKPinAnnotationView
@property (nonatomic,strong) NSString *stopID;
@end
