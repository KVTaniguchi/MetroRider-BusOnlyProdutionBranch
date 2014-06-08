//
//  StopInfoCallOutVC.m
//  MetroRider
//
//  Created by Kevin Taniguchi on 4/26/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import "StopInfoCallOutVC.h"

@interface StopInfoCallOutVC ()

@end

@implementation StopInfoCallOutVC
@synthesize stopInfoCallOutDelegate, stopID, stopName, route, direction;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)favoriteButtonPressed:(id)sender {
    // save this stop as a favorite in core data
    Stop *favStop = [[KTRouteStopStore sharedStore]fetchStopForStopID:self.stopID andRoute:self.route.text];
    favStop.favorite = @YES;
    [[KTRouteStopStore sharedStore]saveChanges];
    [[self stopInfoCallOutDelegate] favoriteStopChosen];
    UIColor * color = [UIColor colorWithRed:229/255.0f green:124/255.0f blue:154/255.0f alpha:1.0f];
    [sender setBackgroundColor:color];
}

- (IBAction)chooseStopButtonPressed:(KTChooseStopButton*)sender {
    sender.backgroundColor = [UIColor redColor];
    [[self stopInfoCallOutDelegate] finalDestinationStopChosen:self.stopID stopName:self.stopName.text direction:self.direction.text route:self.route.text sequence:nil];
}


@end
