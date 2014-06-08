//
//  KTCallOutView.m
//  MetroRider
//
//  Created by Kevin Taniguchi on 4/26/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import "KTCallOutView.h"

@implementation KTCallOutView

@synthesize routeDirection, routeLabel, routeName;

-(id)init{
    self = [super init];
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGRect bounds = self.bounds;
    UIBezierPath *backgroundPath = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:4.0f];
    [backgroundPath addClip];
    [[UIColor colorWithWhite:0.5 alpha:1.0f]setStroke];
    [[UIColor colorWithWhite:1.0 alpha:0.95f]setFill];
    [backgroundPath fill];
    [backgroundPath stroke];
}

@end
