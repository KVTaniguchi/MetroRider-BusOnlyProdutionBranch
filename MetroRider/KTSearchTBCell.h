//
//  KTSearchTBCell.h
//  MetroRider
//
//  Created by Kevin Taniguchi on 5/10/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTSearchTBCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextView *placeMarkAddress;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@end
