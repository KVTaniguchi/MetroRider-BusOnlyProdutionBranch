//
//  StopInfoCallOutVC.h
//  MetroRider
//
//  Created by Kevin Taniguchi on 4/26/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTAnnotationView.h"
#import "KTChooseStopButton.h"
#import "ChosenStopVC.h"
#import "Stop.h"
#import "KTRouteStopStore.h"

@class StopInfoCallOutVC;
@protocol StopInfoCallOutDelegate <NSObject>
-(void)finalDestinationStopChosen:(NSString*)stopID stopName:(NSString*)name direction:(NSString*)dir route:(NSString*)rout sequence:(NSNumber*)seq;
-(void)favoriteStopChosen;
@end

@interface StopInfoCallOutVC : UIViewController
- (IBAction)favoriteButtonPressed:(id)sender;

- (IBAction)chooseStopButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *favoriteButton;

@property (nonatomic,weak) id <StopInfoCallOutDelegate> stopInfoCallOutDelegate;
@property (strong, nonatomic) IBOutlet KTChooseStopButton *chooseStopButton;
@property (strong, nonatomic) IBOutlet UITextView *stopName;
@property (strong, nonatomic) IBOutlet UILabel *route;
@property (strong, nonatomic) IBOutlet UILabel *direction;
@property (strong, nonatomic) NSString *stopID;
@end
