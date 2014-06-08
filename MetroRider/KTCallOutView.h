//
//  KTCallOutView.h
//  MetroRider
//
//  Created by Kevin Taniguchi on 4/26/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTChooseStopButton.h"



@interface KTCallOutView : UIView
@property (strong, nonatomic) IBOutlet UILabel *routeName;
@property (strong, nonatomic) IBOutlet UILabel *routeLabel;
@property (strong, nonatomic) IBOutlet UILabel *routeDirection;
@property (strong, nonatomic) IBOutlet KTChooseStopButton *chooseStopButton;

@end
