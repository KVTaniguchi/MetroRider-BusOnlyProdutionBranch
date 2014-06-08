//
//  FavoriteTBC.h
//  MetroRider
//
//  Created by Kevin Taniguchi on 4/30/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavoriteTBCell.h"
#import "Stop.h"
#import "KTRouteMapVC.h"
#import "KTViewController.h"
#import "LeftToRightSegue.h"

@interface FavoriteTBC : UITableViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *favoriteStops;
@property (nonatomic,strong) Stop *favoriteStopChosen;
@property (nonatomic,strong) NSMutableArray *favoriteRoutes;
@property (nonatomic,strong) Stop *chosenStop;
@end
