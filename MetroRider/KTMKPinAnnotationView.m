//
//  KTMKPinAnnotationView.m
//  MetroRider
//
//  Created by Kevin Taniguchi on 4/19/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import "KTMKPinAnnotationView.h"

@implementation KTMKPinAnnotationView
@synthesize stopID;

-(id)initWithAnnotation:(KTAnnotationPoint*)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super init];
    if (self) {
    }
    return self;
}

@end
