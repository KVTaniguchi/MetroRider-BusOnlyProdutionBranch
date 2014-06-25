//
//  FavoriteTBCell.h
//  MetroRider
//
//  Created by Kevin Taniguchi on 4/30/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteTBCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextView *routeAddress;
@property (strong, nonatomic) IBOutlet UILabel *routeLabel;
@property (strong, nonatomic) IBOutlet UITextView *userTitle;
@property (strong, nonatomic) NSString *stopID;
@end
