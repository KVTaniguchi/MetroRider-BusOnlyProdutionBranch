//
//  KTAnnotationView.h
//  MetroRider
//
//  Created by Kevin Taniguchi on 4/26/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//
#import <MapKit/MapKit.h>
#import "KTAnnotationPoint.h"


@class KTAnnotationView;
@protocol KTAnnotationViewDelegate <NSObject>
@required
-(void)annotationDestinationStopChosenWithStopName:(NSString*)stopName route:(NSString*)rout stopID:(NSString*)ID direction:(NSString*)dir;
@end

@interface KTAnnotationView : MKAnnotationView
@property (nonatomic,strong) id <KTAnnotationViewDelegate> ktAnnotationViewDelegate;
@property (nonatomic,strong) NSString *stopName;
@property (nonatomic,strong) NSString *route;
@property (nonatomic,strong) NSString *stopID;
@property (nonatomic,strong) NSString *direction;
-(void)setKTAnnotationViewImageForAnnotation:(KTAnnotationPoint*)ann;
@end
