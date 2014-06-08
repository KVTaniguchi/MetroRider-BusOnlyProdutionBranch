//
//  LeftToRightSegue.m
//  MetroRider
//
//  Created by Kevin Taniguchi on 5/4/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import "LeftToRightSegue.h"
#import "KTViewController.h"
#import "FavoriteTBC.h"

@implementation LeftToRightSegue

-(void)perform{
    KTViewController *ktVC = (KTViewController*)self.destinationViewController;
    FavoriteTBC *favoriteTBC = (FavoriteTBC*)self.sourceViewController;
    CATransition *transition = [CATransition animation];
    transition.duration = .1;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromLeft;
    [favoriteTBC.view.window.layer addAnimation:transition forKey:nil];
    [favoriteTBC presentViewController:ktVC animated:YES completion:nil];
}

@end
