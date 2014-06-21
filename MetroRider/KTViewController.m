//  KTViewController.m
//  MetroRider
//  Created by Kevin Taniguchi on 4/7/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.

#import "KTViewController.h"

@interface KTViewController ()

@end

@implementation KTViewController{
    CLLocationManager *locationManager;
    Stop *testStop;
    NSSet *uniqueRoutesForUserToSelect;
    NSMutableArray *tripSessionStops;
    RideSelectCVC *collectionViewController;
    RideSelectCell *selectedRideCell;
    NSString *selectedRouteNameFromRideCell;
    KTDataLoader *dataLoader;
    CGPoint end;
    CGPoint start;
    NSTimer *timer;
}

@synthesize rideIDTextField, containerViewForCVC, initialProgressIndicatorView;

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self setUpTheProgressView];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@NO forKey:@"restartUponActiveNotification"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRouteData) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanCollectionView) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    });
    dataLoader = [KTDataLoader new];
    dataLoader.ktDataLoaderDelegate = self;
    dataLoader.uniqueRoutesCloseToUser = [[NSMutableSet alloc]init];
    dataLoader.numOfUniqueRoutesCloseToUser = @0;
    [dataLoader addObserver:self forKeyPath:@"numOfUniqueRoutesCloseToUser" options:0 context:nil];
    [self.navigationController setNavigationBarHidden:YES];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.containerViewForCVC setBackgroundColor:[UIColor clearColor]];
    [self setUpGradient];
    [self setUpFavoriteButton];
    [self createCollectionView];
    [self checkUserLocation];
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [dataLoader getAllBusRoutes];
//    });
}

-(void)reloadRouteData{
    [self cleanCollectionView];
    [self checkUserLocation];
}

-(void)checkUserLocation{
    if (locationManager) {
        [locationManager startUpdatingLocation];
    }else{
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager startUpdatingLocation];
    }
}

-(void)createCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = .5;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    collectionViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"RideSelectCVC"];
    [collectionViewController.collectionView setCollectionViewLayout:flowLayout];
    [collectionViewController.collectionView setDelegate:self];
    [collectionViewController.collectionView setPagingEnabled:NO];
    [collectionViewController.collectionView setUserInteractionEnabled:YES];
    [collectionViewController.collectionView setDataSource:collectionViewController];
    [collectionViewController.collectionView setBackgroundColor:[UIColor clearColor]];
    [collectionViewController.view setBackgroundColor:[UIColor clearColor]];
    [collectionViewController.view setFrame:CGRectMake(0, 0, self.containerViewForCVC.frame.size.width, self.containerViewForCVC.frame.size.height)];
    [collectionViewController.collectionView setFrame:CGRectMake(0, 0, self.containerViewForCVC.frame.size.width, self.containerViewForCVC.frame.size.height)];
    [self addChildViewController:collectionViewController];
    collectionViewController.routesToDisplay = [NSMutableArray new];
    [self.containerViewForCVC addSubview:collectionViewController.view];
    [collectionViewController.collectionView reloadData];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(160, self.containerViewForCVC.frame.size.height);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *animateCell = [collectionView cellForItemAtIndexPath:indexPath];
    [collectionView setUserInteractionEnabled:NO];
    MRCircularProgressView *progressView = [[MRCircularProgressView alloc]initWithFrame:CGRectMake(0, 0, animateCell.frame.size.width, animateCell.frame.size.height)];
    [progressView setBackgroundColor:[UIColor clearColor]];
    [progressView setProgress:1.5f animated:YES];
    [animateCell setBackgroundView:progressView];
    selectedRouteNameFromRideCell = (collectionViewController.routesToDisplay)[indexPath.row];
    if ([[KTRouteStopStore sharedStore]storeContainsRouteDataForRoute:selectedRouteNameFromRideCell]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"MapRouteSegue" sender:self];
        });
    }else{
    [dataLoader loadRouteCoordsForBusRouteID:selectedRouteNameFromRideCell :^(BOOL finished){
        if (finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"MapRouteSegue" sender:self];
            });
        }
    }];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"MapRouteSegue"]) {
        KTRouteMapVC *routeMapVC = [segue destinationViewController];
        if (selectedRouteNameFromRideCell) {
            routeMapVC.route = selectedRouteNameFromRideCell;
        }
    }
    if ([segue.identifier isEqualToString:@"favoriteSegue"]) {
        KTFavoritesVC *favoritesVC = [segue destinationViewController];
        favoritesVC.favoriteStops = [NSMutableArray arrayWithArray:[[KTRouteStopStore sharedStore]fetchFavoriteStops]];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.currentLocation = [locations lastObject];
    [self storeUserLoc];
    [self searchForRoutesCloseToUser];
    [locationManager stopUpdatingLocation];
}

-(void)storeUserLoc{
    UserLoc *updatedUserLoc = [[KTRouteStopStore sharedStore]updateUserLoc];
    updatedUserLoc.latitude = @(self.currentLocation.coordinate.latitude);
    updatedUserLoc.longitude = @(self.currentLocation.coordinate.longitude);
    [[KTRouteStopStore sharedStore]saveChanges];
}


-(void)searchForRoutesCloseToUser{
    if (_collectionViewHasBeenUpdated == NO && _reloadRoutesButtonPressed == NO) {
        if ([self doesStoreHaveRoutesForLocation:self.currentLocation] == YES) {
            [self setUpCollectionView];
        }
        else if(_dataHasBeenFetched == NO){
            [self fetchWMATAAPIData]; 
        }
    }
    if (_reloadRoutesButtonPressed == YES && _dataHasBeenFetched == NO) {
        [self fetchWMATAAPIData];
        return;
    }
}

-(BOOL)doesStoreHaveRoutesForLocation:(CLLocation *)usersLoc;{
    NSArray *temp = [NSArray arrayWithArray:[[KTRouteStopStore sharedStore]fetchRoutesWithStopsCloseToUserLoc:self.currentLocation]];
    if ([temp count]> 1) {
        uniqueRoutesForUserToSelect = [NSMutableSet setWithArray:temp];
        return YES;
    }else{
        return NO;
    }
}

-(void)fetchWMATAAPIData{
    [dataLoader findBusRouteGivenLatLon:self.currentLocation.coordinate.latitude andLong:self.currentLocation.coordinate.longitude];
    if (dataLoader.hasConnection == YES) {
        if ([uniqueRoutesForUserToSelect count] < 1) {
            UIAlertView *notCloseToBusRouteAlertView = [[UIAlertView alloc]initWithTitle:@"Are you On A Bus?" message:@"You are not within 300 m of a bus stop or you are not on a bus.  Use this app when you are riding." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [notCloseToBusRouteAlertView show];
            }
    }
    _dataHasBeenFetched = YES;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"numOfUniqueRoutesCloseToUser"]) {
        uniqueRoutesForUserToSelect = [NSSet setWithArray:[dataLoader.uniqueRoutesCloseToUser allObjects]];
        if (_collectionViewHasBeenUpdated == NO) {
            [self setUpCollectionView];
        }else if (_reloadRoutesButtonPressed == YES){
            [self setUpCollectionView];
            _reloadRoutesButtonPressed = NO;
        }
    }
}

-(void)checkInternetConnectionWarning{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Warning!" message:@"Check your internet connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [alertView show];
    });
    
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
}

-(void)setUpCollectionView{
    NSMutableArray *temp = [NSMutableArray arrayWithArray:[uniqueRoutesForUserToSelect allObjects]];
    for (NSString *s in temp) {
        NSRange vRange = [s rangeOfString:@"v"];
        NSRange cRange = [s rangeOfString:@"c"];
        if (vRange.location == NSNotFound && cRange.location == NSNotFound) {
            if ([collectionViewController.routesToDisplay containsObject:s] == NO) {
                [collectionViewController.routesToDisplay addObject:s];
            }
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [collectionViewController.collectionView reloadData];
    });
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([uniqueRoutesForUserToSelect count] > 3) {
            float endX = 60*[uniqueRoutesForUserToSelect count];
            end = CGPointMake(endX, 0);
            start = CGPointMake(0, 0);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                timer = [NSTimer scheduledTimerWithTimeInterval:0.015 target:self selector:@selector(scrollSlowly) userInfo:nil repeats:YES];
            });
        }
    });
    _collectionViewHasBeenUpdated = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [collectionViewController.collectionView flashScrollIndicators];
    });

}

-(void)scrollSlowly{
    collectionViewController.collectionView.contentOffset = start;
    if (CGPointEqualToPoint(start, end)) {
        [timer invalidate];
        timer = nil;
        return;
    }
    start = CGPointMake(start.x+1, start.y);
}

-(IBAction)getRouteCoordsButtonPress:(id)sender {
    if (self.rideIDTextField.text) {
        [self.rideIDTextField resignFirstResponder];
        [dataLoader loadRouteCoordsForBusRouteID:self.rideIDTextField.text :^(BOOL finished){
            if (finished) {
            }
        }];
    }
}

- (IBAction)reloadButtonPressed:(id)sender {
    [self cleanCollectionView];
    _dataHasBeenFetched = NO;
    _reloadRoutesButtonPressed = YES;
    [self checkUserLocation];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [dataLoader removeObserver:self forKeyPath:@"numOfUniqueRoutesCloseToUser"];
    uniqueRoutesForUserToSelect = nil;
    locationManager = nil;
}

-(void)cleanCollectionView{
    [collectionViewController.routesToDisplay removeAllObjects];
    [collectionViewController.collectionView reloadData];
    _collectionViewHasBeenUpdated = NO;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [timer invalidate];
    timer = nil;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [timer invalidate];
    timer = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)favoritesButtonTouchDown:(id)sender {
    UIButton *favButton = (UIButton*)sender;
    favButton.backgroundColor = [UIColor blueColor];
    [self performSegueWithIdentifier:@"favoriteSegue" sender:self];
}

-(void)setUpTheProgressView{
    self.initialProgressIndicatorView = [[UIView alloc]initWithFrame:CGRectMake(60, 190, 200, 200)];
    MRCircularProgressView *initialProgressMRCirc = [[MRCircularProgressView alloc]initWithFrame:CGRectMake(0, 0, self.initialProgressIndicatorView.frame.size.width, self.initialProgressIndicatorView.frame.size.height)];
    [initialProgressMRCirc setBackgroundColor:[UIColor clearColor]];
    [initialProgressMRCirc setProgress:1.5f animated:YES];
    [initialProgressMRCirc setProgressArcWidth:40];
    [initialProgressMRCirc setProgressColor:[UIColor orangeColor]];
    [initialProgressIndicatorView addSubview:initialProgressMRCirc];
    [self.view addSubview:initialProgressIndicatorView];
    [UIView animateWithDuration:1.5 animations:^{
        [self.initialProgressIndicatorView setAlpha:0.0];
    } completion:^(BOOL finished) {
        if (finished) {
            [self.initialProgressIndicatorView setHidden:YES];
            [self.initialProgressIndicatorView removeFromSuperview];
        }
    }];
}

-(void)setUpGradient{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    UIColor *startColor = [UIColor colorWithRed:0.37 green:0.52 blue:0.04 alpha:1.0];
    UIColor *endColor = [UIColor colorWithRed:0.94 green:0.93 blue:0.46 alpha:1.0];
    gradient.colors = @[(id)[startColor CGColor], (id)[endColor CGColor]];
    [self.view.layer insertSublayer:gradient atIndex:0];
}

-(void)setUpFavoriteButton{
    self.favoritesButton.layer.masksToBounds = YES;
    [self.favoritesButton.layer setBorderWidth:.4f];
    [self.favoritesButton.layer setCornerRadius:70.0f];
}
@end
