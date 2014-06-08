//
//  KTFavoritesVC.h
//  MetroRider
//
//  Created by Kevin Taniguchi on 5/5/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavoriteTBC.h"
#import "KTRouteMapVC.h"
#import "LeftToRightSegue.h"

@interface KTFavoritesVC : UIViewController <UITableViewDelegate>
- (IBAction)backButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *backButton;

@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic,strong) NSMutableArray *favoriteStops;
@property (nonatomic,strong) Stop *favoriteStopChosen;
@property (nonatomic,strong) NSMutableArray *favoriteRoutes;
@property (nonatomic,strong) Stop *chosenStop;
@end