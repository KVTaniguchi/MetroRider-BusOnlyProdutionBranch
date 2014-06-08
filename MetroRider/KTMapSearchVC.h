//
//  KTMapSearchVC.h
//  MetroRider
//
//  Created by Kevin Taniguchi on 5/9/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//
// as the search bar is filled with each character a call is made to the geocoder returning a new object string
// 

#import <UIKit/UIKit.h>
#import "KTSearchTBLVC.h"
#import <CoreLocation/CoreLocation.h>
#import "KTRouteMapVC.h"

@interface KTMapSearchVC : UIViewController <UITableViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) CLCircularRegion *region;
@property (strong, nonatomic) NSString *route;
@end
