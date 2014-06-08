//
//  KTSearchTBLVC.h
//  MetroRider
//
//  Created by Kevin Taniguchi on 5/9/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface KTSearchTBLVC : UITableViewController
@property (nonatomic,strong) NSMutableArray *placeMarks;
@property (nonatomic,strong) CLPlacemark *placeMarkToDisplay;
@end
