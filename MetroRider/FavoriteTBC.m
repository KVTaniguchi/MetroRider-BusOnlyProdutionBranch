//
//  FavoriteTBC.m
//  MetroRider
//
//  Created by Kevin Taniguchi on 4/30/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import "FavoriteTBC.h"
#import "Stop.h"
@interface FavoriteTBC ()
{
    KTRouteMapVC *favoriteStopMapVC;
    UIButton *backButton;
    UIButton *footerButton;
    UINib *cellNib;
}
@end

@implementation FavoriteTBC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    cellNib = [UINib nibWithNibName:@"FavoriteTBCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"favoriteTBCellID"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.favoriteStops count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"favoriteTBCellID";
    FavoriteTBCell *favoriteCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!favoriteCell) {
        favoriteCell = [[FavoriteTBCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    Stop *favoriteStop = (self.favoriteStops)[indexPath.row];
    favoriteCell.routeAddress.text = favoriteStop.stopName;
    favoriteCell.routeLabel.text = favoriteStop.route;
    favoriteCell.stopID = favoriteStop.stopID;
    [self.favoriteRoutes addObject:favoriteStop.route];
    return favoriteCell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Stop *stopToChange = (self.favoriteStops)[indexPath.row];
        Stop *tempStop = [[KTRouteStopStore sharedStore]fetchStopForStopName:stopToChange.stopName andRoute:stopToChange.route direction:stopToChange.direction sequence:stopToChange.sequence];
        tempStop.favorite = @NO;
        [[KTRouteStopStore sharedStore]saveChanges];
        [self.favoriteStops removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
@end
