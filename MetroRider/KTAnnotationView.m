//
//  KTAnnotationView.m
//  MetroRider
//
//  Created by Kevin Taniguchi on 4/26/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import "KTAnnotationView.h"

@implementation KTAnnotationView
@synthesize ktAnnotationViewDelegate, route, stopID, direction, stopName;
-(instancetype)initWithAnnotation:(KTAnnotationPoint*)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if ([annotation isKindOfClass:[KTAnnotationPoint class]]) {
        if (!self) {
            self.annotation = (KTAnnotationPoint*)annotation;
            self.canShowCallout = NO;
            self.annotation = annotation;
        }else{
            self.annotation = annotation;
        }
    }
    [self setKTAnnotationViewImageForAnnotation:annotation];
    return self;
}

-(void)setKTAnnotationViewImageForAnnotation:(KTAnnotationPoint *)ann{
    if (ann.isFavorite) {
        self.image = [UIImage imageNamed:@"MapMarker_Marker_Outside_Pink"];
    }
    if ([ann.direction isEqualToString:@"EAST"]) {
        self.image = [UIImage imageNamed:@"Map-Marker-Marker-Inside-Chartreuse"];
    }
    if ([ann.direction isEqualToString:@"WEST"]) {
        self.image = [UIImage imageNamed:@"MapMarker_Marker_Inside_Azure"];
    }
    if ([ann.direction isEqualToString:@"NORTH"]) {
        self.image = [UIImage imageNamed:@"MapMarker_Marker_Outside_Chartreuse"];
    }
    if ([ann.direction isEqualToString:@"SOUTH"]) {
        self.image = [UIImage imageNamed:@"MapMarker_Marker_Outside_Azure"];
    }
}

-(void)setSelected:(BOOL)selected{
    
    [super setSelected:selected];

    if (![self.annotation isKindOfClass:[MKUserLocation class]]) {
        if (selected) {
            self.image = [UIImage imageNamed:@"MapMarker_Marker_Outside_Pink"];
            // instead of a a callout generation, send a delegate call to mapview to instantiate the stopinfovc with the data of the annotation
            self.stopName = [(KTAnnotationPoint*)[self annotation] stopName];
            self.route = [(KTAnnotationPoint*)[self annotation] route];
            self.direction = [(KTAnnotationPoint*)[self annotation] direction];
            self.stopID = [(KTAnnotationPoint*)[self annotation] stopID];
            [[self ktAnnotationViewDelegate] annotationDestinationStopChosenWithStopName:self.stopName route:self.route stopID:self.stopID direction:self.direction];
        }
    }
}

@end
