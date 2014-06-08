//
//  RideSelectCVC.h
//  MetroRider
//
//  Created by Kevin Taniguchi on 4/14/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RideSelectCell.h"

@interface RideSelectCVC : UICollectionViewController <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (nonatomic,strong) NSString *route;
@property (nonatomic,strong) NSMutableArray *routesToDisplay;
@end
