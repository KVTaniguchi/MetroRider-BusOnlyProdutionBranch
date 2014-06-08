//
//  KTFavoritesVC.m
//  MetroRider
//
//  Created by Kevin Taniguchi on 5/5/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import "KTFavoritesVC.h"

@interface KTFavoritesVC ()
{
    FavoriteTBC *favoritesTBC;
}
@end

@implementation KTFavoritesVC
@synthesize favoriteStops, favoriteRoutes;

-(id)init{
    self = [super init];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    favoritesTBC = [[FavoriteTBC alloc]initWithStyle:UITableViewStylePlain];
    favoritesTBC.favoriteStops = self.favoriteStops;
    [self addChildViewController:favoritesTBC];
    favoritesTBC.tableView.delegate = self;
    [favoritesTBC.tableView setFrame:CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height)];
    [self.containerView addSubview:favoritesTBC.view];
    favoritesTBC.favoriteStops = [NSMutableArray arrayWithArray:[[KTRouteStopStore sharedStore]fetchFavoriteStops]];
    [favoritesTBC.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"favoriteChosenSegue"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            KTRouteMapVC *ktFavoriteRouteMapVC = [segue destinationViewController];
            ktFavoriteRouteMapVC.favoriteStopActive = YES;
            ktFavoriteRouteMapVC.tripMonitoringActive = NO;
            ktFavoriteRouteMapVC.selectedStop = [[KTRouteStopStore sharedStore]fetchStopForStopID:self.favoriteStopChosen.stopID andRoute:self.favoriteStopChosen.route];
            ktFavoriteRouteMapVC.chosenStopID = [NSString stringWithFormat:@"%@",self.favoriteStopChosen.stopID];
            ktFavoriteRouteMapVC.route = [NSString stringWithFormat:@"%@",self.favoriteStopChosen.route];
//            NSLog(@"the favorite stop selected is: stopID %@ stopName %@ sequence %@ lat %@ lon %@ dir %@", ktFavoriteRouteMapVC.selectedStop.stopID, ktFavoriteRouteMapVC.selectedStop.stopName, ktFavoriteRouteMapVC.selectedStop.sequence, ktFavoriteRouteMapVC.selectedStop.latitude, ktFavoriteRouteMapVC.selectedStop.longitude, ktFavoriteRouteMapVC.selectedStop.direction);
        });
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
    return view;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}

#pragma mark - Navigation

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.favoriteStopChosen = (self.favoriteStops)[indexPath.row];
    [self performSegueWithIdentifier:@"favoriteChosenSegue" sender:self];
}

- (IBAction)backButtonPressed:(id)sender {
}
@end
