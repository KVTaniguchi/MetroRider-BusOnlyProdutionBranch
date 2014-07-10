//
//  KTRouteMapVC.m
//  MetroRider
//
//  Created by Kevin Taniguchi on 4/14/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import "KTRouteMapVC.h"
#import "KTAppDelegate.h"
#import "KTViewController.h"

#define METERS_PER_MILE 1609.344
@interface KTRouteMapVC ()
@end

@implementation KTRouteMapVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    UserLoc *u = [[KTRouteStopStore sharedStore]fetchUserLoc];
    if (self.layMapWithPlacemark == NO) {
        CLLocationCoordinate2D userCoord = CLLocationCoordinate2DMake([u.latitude doubleValue], [u.longitude doubleValue]);
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userCoord, 1.1 * METERS_PER_MILE, 1.1 * METERS_PER_MILE);
        [self.map setRegion:region animated:NO];
        [self.map setDelegate:self];
    }else{
        CLLocationCoordinate2D selectedPlacemarkCoord = CLLocationCoordinate2DMake(self.searchedPlacemark.location.coordinate.latitude, self.searchedPlacemark.location.coordinate.longitude);
        MKCoordinateRegion searchedRegion = MKCoordinateRegionMakeWithDistance(selectedPlacemarkCoord, 1.1 * METERS_PER_MILE, 1.1 * METERS_PER_MILE);
        [self.map setRegion:searchedRegion animated:YES];
        [self.map setDelegate:self];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self resetDistanceFlags];
    [self resetWrongWayAlertFlags];
    if (self.isViewLoaded && !self.view.window) {
        KTAppDelegate *ktAppDelegate = (KTAppDelegate*)[[UIApplication sharedApplication]delegate];
        [[ktAppDelegate window] addSubview:self.view];
    }else{
        [self checkForRestartIfFinalStopReached];
    }
    if (self.tripMonitoringActive == NO && self.favoriteStopActive == NO) { // this is getting  called because these bools are not getting set yet
        [self beginTripSession];
    }
    [self setUpViewForUserChoosingAStopAnnotation];
    [self setUpViewsForUserChoosingDestinationStop];
    [self.favoriteChosenContainer setAlpha:0.f];
    selectedAnnotation = [[KTAnnotationPoint alloc]init];
    self.routeLabel.text = self.route;
    if(self.layMapWithPlacemark == YES){
        [self laySearchedPlacemarkAnnotation];
    }
    if (self.favoriteStopActive == YES) {
        [self trackFavoriteStop:_selectedStop.stopID route:_route];
        [self beginTripSession];
    }
}

-(void)resetDistanceFlags{
    _twoKFired = NO;
    _eightHundredFired = NO;
    _threeHundredFired = NO;
    _oneHundredFired = NO;
}

-(void)resetWrongWayAlertFlags{
    _firstWrongWayAlert = NO;
    _secondWrongWayAlert = NO;
    _thirdWrongWayAlert = NO;
}

-(void)setUpViewForUserChoosingAStopAnnotation{
    [self.containerView setHidden:YES];
    UIColor * lightPurple = [UIColor colorWithRed:113/255.0f green:111/255.0f blue:226/255.0f alpha:.5f];
    [self.containerView.layer setBackgroundColor:lightPurple.CGColor];
    stopInfoCallOutVC = [[self storyboard]instantiateViewControllerWithIdentifier:@"StopInfoCallOutVC"];
    [stopInfoCallOutVC.stopName setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
    [stopInfoCallOutVC.view setAlpha:0.0f];
    [stopInfoCallOutVC.view setHidden:YES];
    [self addChildViewController:stopInfoCallOutVC];
    [self.containerView addSubview:stopInfoCallOutVC.view];
}

-(void)setUpViewsForUserChoosingDestinationStop{
    [self.userChoseStopContainer setHidden:YES];
    UIColor * lightBlue = [UIColor colorWithRed:141/255.0f green:192/255.0f blue:235/255.0f alpha:.5f];
    [self.userChoseStopContainer.layer setBackgroundColor:lightBlue.CGColor];
    chosenStopVC = [[self storyboard]instantiateViewControllerWithIdentifier:@"ChosenStopVC"];
    [self addChildViewController:chosenStopVC];
    [chosenStopVC.view setAlpha:0.0f];
    [self.userChoseStopContainer addSubview:chosenStopVC.view];
    chosenStopVC.chosenStopDelegate = self;
    [chosenStopVC.view setHidden:YES];
}

-(void)viewDidLoad{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkForRestartIfFinalStopReached) name:UIApplicationDidBecomeActiveNotification object:nil];
    [self.navigationController setNavigationBarHidden:YES];
    [self setUpNavigationButtons];
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didDragMap:)];
    [panRecognizer setDelegate:self];
    [self.map addGestureRecognizer:panRecognizer];
}

-(void)setUpNavigationButtons{
    [self.backButton.layer setCornerRadius:8.0f];
    [self.backButton.layer setBorderWidth:.4f];
    UIColor * color = [UIColor colorWithRed:150/255.0f green:182/255.0f blue:78/255.0f alpha:1.0f];
    [self.backButton setBackgroundColor:color];
    [self.userLocButton setBackgroundColor:color];
    [self.userLocButton.layer setCornerRadius:8.0f];
    [self.userLocButton.layer setBorderWidth:.4f];
    [self.searchButton setBackgroundColor:color];
    [self.searchButton.layer setCornerRadius:8.0f];
    [self.searchButton.layer setBorderWidth:.4f];
}

-(void)didDragMap:(UIGestureRecognizer*)panRec{
    [_chooseAStopLabel setHidden:NO];
    if (panRec.state == UIGestureRecognizerStateBegan) {
        [UIView animateWithDuration:.5f animations:^{
            [_chooseAStopLabel setAlpha:0.0];
        }];
    }
    if (panRec.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:.5f animations:^{
            [_chooseAStopLabel setAlpha:1.0f];
        }];
        if (_stopDetailViewsVisible == YES) {
            [UIView animateWithDuration:1.0 animations:^{
                [self.containerView setAlpha:0.0f];
            }];
        }
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(void)beginTripSession{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tripSessionStops = [[NSMutableArray alloc]init];
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
        [self.locationManager allowDeferredLocationUpdatesUntilTraveled:100 timeout:1];
        [self.locationManager setPausesLocationUpdatesAutomatically:YES];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        self.tripMonitor = [[TripMonitor alloc]init];
        _tripMonitor.previousDistance = [NSNumber new];
    });
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.currentLocation = [locations lastObject];
    if (self.tripMonitoringActive == NO) {
        [self.locationManager stopUpdatingLocation];
        [self setUpMapData];
    }
    if (self.tripMonitoringActive == YES) {
    [self calculateDistanceFromCurrentLocation:self.currentLocation toDestinationLoc:self.destinationLocation];
        }
}

-(void)setUpMapData{
    [self.map setDelegate:self];
    [self layStopsForRoute];
}

-(void)layStopsForRoute{
    NSArray *closestStops = [self.tripMonitor getCloseActiveTripStopsForRoute:self.route withLocation:self.currentLocation];
    _tripSessionStops = [NSMutableArray arrayWithArray:[self stopsToPlaceinRelationToClosestStops:closestStops]];
    NSArray *allStopsOnRoute = [[KTRouteStopStore sharedStore]fetchAllStopsForRoute:self.route];
    if ([allStopsOnRoute count] < 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIAlertView *noBusAlert = [[UIAlertView alloc]initWithTitle:@"No Stops" message:@"Route Current Inactive" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [noBusAlert show];
        });
    }
    for (Stop *stop in allStopsOnRoute) {
        KTAnnotationPoint *ann = [[KTAnnotationPoint alloc]init];
        ann.coordinate = CLLocationCoordinate2DMake([stop.latitude doubleValue], [stop.longitude doubleValue]);
        ann.stopName = stop.stopName;
        ann.route = stop.route;
        ann.stopID = stop.stopID;
        ann.direction = stop.direction;
        if (self.favoriteStopActive == YES) {
            if ([ann.stopID isEqualToString:_selectedStop.stopID] && [ann.stopName isEqualToString:_selectedStop.stopName]) {
                ann.isFavorite = YES;
            }
        }
        [self.map addAnnotation:ann];
    }
}

-(void)laySearchedPlacemarkAnnotation{
    MKPointAnnotation *placemarkAnnotation = [[MKPointAnnotation alloc]init];
    placemarkAnnotation.coordinate = self.searchedPlacemark.location.coordinate;
    placemarkAnnotation.title = self.searchedPlacemarktext;
    [self.map addAnnotation:placemarkAnnotation];
}

-(NSArray*)stopsToPlaceinRelationToClosestStops:(NSArray*)closestStops{
    // get all stops that have a higher sequence than the closest 1 or 2
    NSMutableArray *k = [[NSMutableArray alloc]init];
    NSArray *allStopsForRoute = [[KTRouteStopStore sharedStore]fetchAllStopsForRoute:self.route];
    for (KTActiveTripStop *activeStop in closestStops) {
        for (Stop *stop in allStopsForRoute) {
            if ([stop.sequence intValue] >= [activeStop.routeSequence intValue] && [stop.direction isEqualToString:activeStop.direction]) {
                [k addObject:stop];
            }
        }
    }
    return k;
}

-(void)calculateDistanceFromCurrentLocation:(CLLocation*)location toDestinationLoc:(CLLocation*)destLoc{
    NSInteger distanceFromDest =  [location distanceFromLocation:destLoc];
    NSLog(@"distance From Dest: %ld", (long)distanceFromDest);
    NSLog(@"trip mon wrong way score: %@", _tripMonitor.wrongWayScore);
    if (_wrongWayPossibleFlag == YES) {
        NSLog(@"wrong way possible checking distance");
        [_tripMonitor checkIfUserGettingCloserToDestination:[NSNumber numberWithInteger:distanceFromDest]];
        NSLog(@"trip monitors last distnace was: %@", _tripMonitor.previousDistance);
        if ([_tripMonitor.wrongWayScore integerValue] > 40) {
            [KTNotifyStop _sendWrongWayAlert];
        }
    }
    if (distanceFromDest < 2000 && _twoKFired == NO) {
        _tripSessionStops = [NSMutableArray arrayWithArray:[_tripMonitor findNextStopsTillDestinationGivenCurrentLocation:location andFinalStop:_selectedStop]];
        self.twoKFired = YES;
    }
    if (distanceFromDest < 800 && _eightHundredFired == NO) {
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
        [self.tripMonitor checkClosestActiveStopToLocation:location withTripSessionStops:_tripSessionStops];
        _eightHundredFired = YES;
        _wrongWayPossibleFlag = NO;
    }
    if (distanceFromDest < 350 && _threeHundredFired == NO) {
        [[UIApplication sharedApplication]cancelAllLocalNotifications];
        [KTNotifyStop _sendThreeHundredMetersLocalNotification];
        _threeHundredFired = YES;
    }
    if (distanceFromDest < 100 && _oneHundredFired == NO) {
        [[UIApplication sharedApplication]cancelAllLocalNotifications];
        [KTNotifyStop _sendFinalStopLocalNotification];
        _oneHundredFired = YES;
        [self tripOver];
    }
    
    // if the array is greater than 10 objects, remove last element
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    if ([region.identifier isEqualToString:@"destinationStopRegion"]) {
        [KTNotifyStop _sendBusStopDidEnterLastStopRegion];
        [KTNotifyStop _sendBusStopApproachingLocalNotificationNextStop];
        [_locationManager stopMonitoringForRegion:_lastStopRegion];
    }
}

-(void)tripOver{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@YES forKey:@"tripEnded"];
        [defaults synchronize];
        [_locationManager stopUpdatingLocation];
    });
}

-(void)initStopRegions{
    CLLocation *selectedStopLocation = [[CLLocation alloc]initWithLatitude:[_selectedStop.latitude floatValue] longitude:[_selectedStop.longitude floatValue]];
    CLLocation *finalStopFromLocation = [[CLLocation alloc]initWithLatitude:[self.tripMonitor.lastStopFromDest.latitude floatValue] longitude:[self.tripMonitor.lastStopFromDest.longitude floatValue]];
    CLLocationDistance lastStopToFinalStopDistance = [selectedStopLocation distanceFromLocation:finalStopFromLocation];
    self.lastStopRegion = [[CLCircularRegion alloc]initWithCenter:self.destinationLocation.coordinate radius:lastStopToFinalStopDistance identifier:@"destinationStopRegion"];
    
    [_locationManager startMonitoringForRegion:self.lastStopRegion];
}

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(KTAnnotationPoint*)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    static NSString *identifier = @"myAnnotation";
    KTAnnotationView *annoview = (KTAnnotationView*)[self.map dequeueReusableAnnotationViewWithIdentifier:identifier];
    if ([annotation isKindOfClass:[KTAnnotationPoint class]]) {
        if (!annoview) {
            annotation = (KTAnnotationPoint*)annotation;
            annoview = [[KTAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier];
            resetFrame = annoview.frame;
            annoview.annotation = annotation;
            annoview.ktAnnotationViewDelegate = self;
        }else{
            annoview.annotation = annotation;
        }
    }else{
        MKPointAnnotation *searchedAnnotation = (MKPointAnnotation*)annotation;
        MKPinAnnotationView *searchedAnnotationView = [[MKPinAnnotationView alloc]initWithAnnotation:searchedAnnotation reuseIdentifier:@"normalPinAnnotation"];
        searchedAnnotationView.canShowCallout = YES;
        return searchedAnnotationView;
    }
    if ([annotation.direction isEqualToString:@"EAST"]) {
        annoview.image = [UIImage imageNamed:@"Map-Marker-Marker-Inside-Chartreuse"];
    } else
    if ([annotation.direction isEqualToString:@"WEST"]) {
        annoview.image = [UIImage imageNamed:@"MapMarker_Marker_Inside_Azure"];
    } else
    if ([annotation.direction isEqualToString:@"NORTH"]) {
        annoview.image = [UIImage imageNamed:@"MapMarker_Marker_Outside_Chartreuse"];
    } else
    if ([annotation.direction isEqualToString:@"SOUTH"]) {
        annoview.image = [UIImage imageNamed:@"MapMarker_Marker_Outside_Azure"];
    }
    if (annotation.isFavorite) {
        annoview.image = [UIImage imageNamed:@"MapMarker_Marker_Outside_Pink"];
    }
    return  annoview;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(KTAnnotationView*)view{
    selectedAnnotation = (KTAnnotationPoint*)view.annotation;
    selectedAnnotationView = view;
    [self.routeLabel setHidden:YES];
    [_chooseAStopLabel setHidden:YES];
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(KTAnnotationView*)view{
    KTAnnotationPoint *annotation = (KTAnnotationPoint*)view.annotation;
    if ([view isMemberOfClass:[KTAnnotationView class]]) {
        [view setKTAnnotationViewImageForAnnotation:annotation];
    }
    if(self.tripMonitoringActive == YES){
        [_locationManager stopUpdatingLocation];
    }
}

-(void)annotationDestinationStopChosenWithStopName:(NSString *)stopName route:(NSString *)rout stopID:(NSString *)ID direction:(NSString *)dir{
    dispatch_async(dispatch_get_main_queue(), ^{
        _selectedStop.route = rout;
        _selectedStop.direction = dir;
        [self.containerView setHidden:NO];
        stopInfoCallOutVC.route.text = rout;
        stopInfoCallOutVC.stopName.text = stopName;
        stopInfoCallOutVC.direction.text = dir;
        stopInfoCallOutVC.stopID = ID;
        stopInfoCallOutVC.stopInfoCallOutDelegate = self;
        [stopInfoCallOutVC.view setHidden:NO];
        [self.containerView setAlpha:0.0f];
        [stopInfoCallOutVC.view setAlpha:0.0f];
        [UIView animateWithDuration:.5 animations:^{
            [self.containerView setAlpha:1.0f];
            [stopInfoCallOutVC.view setAlpha:1.0f];
        }];
    });
    _stopDetailViewsVisible = YES;
}

-(void)finalDestinationStopChosen:(NSString *)stopID stopName:(NSString *)name direction:(NSString *)dir route:(NSString *)rout sequence:(NSNumber*)seq{
    [self resetDistanceFlags];
    [_locationManager startUpdatingLocation];
    self.tripMonitoringActive = YES;
    _wrongWayPossibleFlag = YES;
//    [self.tripMonitor startMotionTracking];
    if ([stopID isEqualToString:@"0"]) {
        _selectedStop = [[KTRouteStopStore sharedStore]fetchStopForStopName:name andRoute:self.route direction:dir];
    }else{
        _selectedStop = [[KTRouteStopStore sharedStore]fetchStopForStopID:stopID];
    }
    self.destinationLocation = [[CLLocation alloc]initWithLatitude:[_selectedStop.latitude floatValue] longitude:[_selectedStop.longitude floatValue]];
    [self.tripMonitor findLastThreeActiveStopsToDestination:_selectedStop GivenCurrentLocation:self.currentLocation :^(BOOL finished){
        if (finished) {
            [self initStopRegions];
        }
    }];
    [self.userChoseStopContainer setHidden:NO];
    chosenStopVC.stopAddressTextView.text = _selectedStop.stopName;
    chosenStopVC.route.text = self.route;
    [chosenStopVC.view setHidden:NO];
    [self.userChoseStopContainer setAlpha:0.0f];
    [chosenStopVC.view setAlpha:0.0f];
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.userChoseStopContainer setAlpha:1.0f];
        [chosenStopVC.view setAlpha:1.0f];
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [self.searchButton setAlpha:0.0f];
                [self.userLocButton setAlpha:0.0f];
                [self.backButton setAlpha:0.0f];
                [self.map setAlpha:0.1];
                [self.map setUserInteractionEnabled:NO];
                [self.view setBackgroundColor:[UIColor lightGrayColor]];
            } completion:^(BOOL finished) {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:@YES forKey:@"restartUponActiveNotification"];
                [defaults synchronize];
            }];
        }
    }];
}

-(void)chooseAnotherStop{
    [self resetDistanceFlags];
    [self resetWrongWayAlertFlags];
    if (self.tripMonitoringActive == YES) {
        [_locationManager stopUpdatingLocation];
    }
    [UIView animateWithDuration:.5 animations:^{
        [self.containerView setAlpha:0.0f];
        [self.userChoseStopContainer setAlpha:0.0f];
        [self.searchButton setAlpha:1.0f];
        [self.userLocButton setAlpha:1.0f];
        [self.backButton setAlpha:1.0f];
        [self.map setAlpha:1.0f];
        [self.map setUserInteractionEnabled:YES];
        [self.view setBackgroundColor:[UIColor clearColor]];
    } completion:^(BOOL finished) {
        [stopInfoCallOutVC.chooseStopButton setBackgroundColor:[UIColor greenColor]];
        [stopInfoCallOutVC.favoriteButton setBackgroundColor:[UIColor orangeColor]];
        [selectedAnnotationView setKTAnnotationViewImageForAnnotation:selectedAnnotation];
    }];
    self.favoriteStopActive = NO;
    self.tripMonitoringActive = NO;
    [self.routeLabel setHidden:NO];
    [_chooseAStopLabel setHidden:NO];
    _stopDetailViewsVisible = NO;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (IBAction)userLocButtonPressed:(id)sender {
    [self.map setCenterCoordinate:self.map.userLocation.coordinate animated:YES];
}

- (IBAction)searchForLocationButtonPressed:(id)sender {
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self performSegueWithIdentifier:@"leftToRight" sender:self];
    }
}

-(void)favoriteStopChosen{
    [self.favoriteChosenContainer setAlpha:0];
    [self.favoriteChosenContainer setHidden:NO];
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.favoriteChosenContainer setAlpha:1.0f];
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:2.0 delay:.5f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.favoriteChosenContainer setAlpha:0.f];
            } completion:^(BOOL finished) {
                if (finished) {
                }
                [UIView animateWithDuration:1.0 animations:^{
                    [stopInfoCallOutVC.favoriteButton setBackgroundColor:[UIColor orangeColor]];
                }];
            }];
        }
    }];
}

-(void)trackFavoriteStop:(NSString*)stopID route:(NSString*)route{
    CLLocationCoordinate2D favoriteStopCoord = CLLocationCoordinate2DMake([_selectedStop.latitude floatValue], [_selectedStop.longitude floatValue]);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(favoriteStopCoord, 1.1*METERS_PER_MILE, 1.1*METERS_PER_MILE);
    [self.map setRegion:region animated:YES];
    [self.map setDelegate:self];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self finalDestinationStopChosen:_selectedStop.stopID stopName:_selectedStop.stopName direction:_selectedStop.direction route:_selectedStop.route sequence:_selectedStop.sequence];
        [self layStopsForRoute];
    });
}

-(void)applyCoverView{
    UIView *coverView = [[UIView alloc]initWithFrame:self.view.bounds];
    [coverView setAlpha:0.0f];
    [coverView setHidden:YES];
    coverView.backgroundColor = [UIColor colorWithRed:119.0f/255.0f green:114.0f/255.0f blue:128.0f/255.0f alpha:1.0];
    [self.view addSubview:coverView];
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [coverView setAlpha:.5f];
    } completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [_tripMonitor resetTripMonitor];
    if ([segue.identifier isEqualToString:@"leftToRight"]) {
        [_locationManager stopMonitoringForRegion:_lastStopRegion];
        [_locationManager stopUpdatingLocation];
        [_locationManager stopMonitoringSignificantLocationChanges];
        _locationManager = nil;
        [self.map removeFromSuperview];
        [self.view removeFromSuperview];
    }
    if ([segue.identifier isEqualToString:@"searchSegue"]) {
        KTMapSearchVC *mapSearchVC = [segue destinationViewController];
        CLCircularRegion *mapRegion = [[CLCircularRegion alloc]initWithCenter:self.map.region.center radius:60000 identifier:@"DCREGION"];
        mapSearchVC.region = mapRegion;
        mapSearchVC.route = self.route;
    }
}

-(void)checkForRestartIfFinalStopReached{
    NSUserDefaults *fetchDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *tripFinished = [fetchDefaults objectForKey:@"restartUponActiveNotification"];
    if ([tripFinished boolValue] == YES) {
        [self restart];
    }
}

-(void)restart{
    [self resetDistanceFlags];
    [self resetWrongWayAlertFlags];
    _wrongWayPossibleFlag = YES;
    [_locationManager stopUpdatingLocation];
    UINavigationController *nav = [[self storyboard]instantiateViewControllerWithIdentifier:@"navController"];
    [self presentViewController:nav animated:YES completion:nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@NO forKey:@"tripEnded"];
    [defaults synchronize];
}


- (IBAction)backButtonPressed:(id)sender {
    if (self.startOver == NO) {
        [self performSegueWithIdentifier:@"leftToRight" sender:self];
    }
    else{
        [self restart];
    }
}
@end
