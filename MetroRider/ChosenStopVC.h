//
//  ChosenStopVC.h
//  MetroRider
//
//  Created by Kevin Taniguchi on 4/27/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StopInfoCallOutVC.h"
@class ChosenStopVC;
@protocol ChosenStopVCDelegate <NSObject>

-(void)chooseAnotherStop;

@end

@interface ChosenStopVC : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *chooseAnotherStopButton;
@property (strong, nonatomic) IBOutlet UITextView *choseStopVCDetailTextView;
@property (strong, nonatomic) IBOutlet UILabel *route;
@property (weak, nonatomic) id <ChosenStopVCDelegate> chosenStopDelegate;
@property (strong, nonatomic) IBOutlet UITextView *stopAddressTextView;
@property (strong, nonatomic) IBOutlet UILabel *headLineLabel;
- (IBAction)chooseAnotherStopButtonPressed:(UIButton*)sender;
@end
