//
//  KTRouteMapVC.h
//  MetroRider
//
//  Created by Kevin Taniguchi on 4/14/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

/*

*/

#import <UIKit/UIKit.h>

@import CoreLocation;

#import <MapKit/MapKit.h>
#import "KTNotifyStop.h"
#import "TripMonitor.h"
#import "KTRouteStopStore.h"
#import "KTAnnotationPoint.h"
#import "KTChooseStopButton.h"
#import "KTAnnotationView.h"
#import "StopInfoCallOutVC.h"
#import "ChosenStopVC.h"
#import "FavoriteCallOutVC.h"
#import "KTMapSearchVC.h"

@interface KTRouteMapVC : UIViewController <TripMonitorDelegate, CLLocationManagerDelegate, MKMapViewDelegate, KTAnnotationViewDelegate, UIAlertViewDelegate, StopInfoCallOutDelegate, ChosenStopVCDelegate, UIGestureRecognizerDelegate>
{
    CLGeocoder *geoCoder;
    int routeForUserToSelectCount;
    MKPolygon *routeShapePolygon;
    MKOverlayRenderer *overLayRenderer;
    NSMutableArray *stopAnnotations;
    CGRect resetFrame;
    StopInfoCallOutVC *stopInfoCallOutVC;
    ChosenStopVC *chosenStopVC;
    ChosenStopVC *favoriteStopVC;
    KTAnnotationPoint *selectedAnnotation;
    KTAnnotationView *selectedAnnotationView;
    FavoriteCallOutVC *favoritedStopVC;
}

@property (nonatomic) BOOL tripMonitoringActive;
@property (nonatomic) BOOL favoriteStopActive;
@property (nonatomic) BOOL startOver;
@property (nonatomic) BOOL layMapWithPlacemark;
@property (nonatomic) BOOL stopDetailViewsVisible;
@property (nonatomic) BOOL twoKFired;
@property (nonatomic) BOOL eightHundredFired;
@property (nonatomic) BOOL threeHundredFired;
@property (nonatomic) BOOL oneHundredFired;
@property (nonatomic) BOOL wrongWayPossibleFlag;
@property (nonatomic) BOOL firstWrongWayAlert;
@property (nonatomic) BOOL secondWrongWayAlert;
@property (nonatomic) BOOL thirdWrongWayAlert;
@property (nonatomic,strong) TripMonitor *tripMonitor;
@property (strong, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) IBOutlet UILabel *routeLabel;
- (IBAction)backButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *chooseAStopLabel;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) CLPlacemark *destinationPlacemark;
@property (nonatomic,strong) CLPlacemark *searchedPlacemark;
@property (nonatomic,strong) CLLocation *destinationLocation;
@property (nonatomic,strong) CLLocation *currentLocation;
@property (nonatomic,strong) NSString *route;
@property (nonatomic,strong) NSString *searchedPlacemarktext;
@property (nonatomic,strong) Stop *selectedStop;
@property (nonatomic,strong) NSString *chosenStopID;
@property (nonatomic,strong) NSMutableArray *tripSessionStops;
@property (nonatomic,strong) NSArray *stopsInWrongDirection;
@property (nonatomic,strong) CLCircularRegion *lastStopRegion;
@property (nonatomic,strong) CLCircularRegion *destinationStopRegion;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *userLocButton;
- (IBAction)userLocButtonPressed:(id)sender;
- (IBAction)searchForLocationButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIView *userChoseStopContainer;
@property (strong, nonatomic) IBOutlet UIView *favoriteChosenContainer;

@end
