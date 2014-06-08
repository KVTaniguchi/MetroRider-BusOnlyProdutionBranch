//
//  KTViewController.h
//  MetroRider
//
//  Created by Kevin Taniguchi on 4/7/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "KTDataLoader.h"
#import "RideSelectCell.h"
#import "RideSelectCVC.h"
#import "KTRouteStopStore.h"
#import "KTRouteMapVC.h"
#import "MRCircularProgressView.h"
#import "TripMonitor.h"
#import "KTNotifyStop.h"
#import "KTAppDelegate.h"
#import "FavoriteTBC.h"
#import "KTFavoritesVC.h"
#import "UserLoc.h"

typedef void(^myCompletion)(BOOL);

@interface KTViewController : UIViewController <CLLocationManagerDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UITextFieldDelegate, KTDataLoaderDelegate, UIApplicationDelegate, UITableViewDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *reloadRoutesButton;
@property (strong, nonatomic) UIView *initialProgressIndicatorView;
- (IBAction)favoritesButtonTouchDown:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *favoritesButton;
@property (strong,nonatomic) NSString *tripDirection;
@property (strong,nonatomic) NSString *userBusRouteID;
@property (strong,nonatomic) IBOutlet UITextField *rideIDTextField;
@property (strong,nonatomic) NSArray *dataArray;
@property (strong, nonatomic) IBOutlet UIView *containerViewForCVC;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (nonatomic,strong) NSMutableArray *routes;
@property (nonatomic) BOOL collectionViewHasBeenUpdated;
@property (nonatomic) BOOL dataHasBeenFetched;
@property (nonatomic) BOOL reloadRoutesButtonPressed;
- (IBAction)getRouteCoordsButtonPress:(id)sender;
- (IBAction)reloadButtonPressed:(id)sender;
-(void)reloadRouteData;
-(void)scrollSlowly;

-(BOOL)doesStoreHaveRoutesForLocation:(CLLocation*)usersLoc;

@end
