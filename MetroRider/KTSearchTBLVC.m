//
//  KTSearchTBLVC.m
//  MetroRider
//
//  Created by Kevin Taniguchi on 5/9/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import "KTSearchTBLVC.h"
#import "KTSearchTBCell.h"
@interface KTSearchTBLVC ()
{
    UINib *cellNib;
}
@end

@implementation KTSearchTBLVC

@synthesize placeMarks, placeMarkToDisplay;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.dataSource = self;
    cellNib = [UINib nibWithNibName:@"KTSearchTBCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"placeMarkCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.placeMarks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"placeMarkCell";
    KTSearchTBCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[KTSearchTBCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    CLPlacemark *mark = (self.placeMarks)[indexPath.row];
    cell.latitude = @(mark.location.coordinate.latitude);
    cell.longitude = @(mark.location.coordinate.longitude);
    NSString *text = [self processedPlaceMark:mark];
    cell.placeMarkAddress.text = [NSString stringWithFormat:@"%@", text];
    return cell;
}

-(NSMutableString*)processedPlaceMark:(CLPlacemark*)mark{
    NSString *subThoroughFare = [NSString stringWithFormat:@"%@ ", mark.subThoroughfare];
    NSString *thoroughFare = [NSString stringWithFormat:@"%@ ", mark.thoroughfare];
    NSString *areaOfInterest = [NSString stringWithFormat:@"%@ ", [mark.areasOfInterest lastObject]];
    NSString *locality = [NSString stringWithFormat:@"%@ ", mark.locality];
    NSString *zipCode = [NSString stringWithFormat:@"%@ ", mark.postalCode];
    NSString *sublocality = [NSString stringWithFormat:@"%@ ", mark.subLocality];
    NSMutableString *cellText = [[NSMutableString alloc]initWithString:@" "];
    NSString *noText = @"(null) ";
    if (![subThoroughFare isEqualToString:noText]) {
        [cellText appendString:subThoroughFare];
    }
    if (![thoroughFare isEqualToString:noText]) {
        [cellText appendString:thoroughFare];
    }
    if (![areaOfInterest isEqualToString:noText]) {
        [cellText appendString:areaOfInterest];
    }
    if (![sublocality isEqualToString:noText]) {
        [cellText appendString:sublocality];
    }
    if (![locality isEqualToString:noText]) {
        [cellText appendString:locality];
    }
    if (![zipCode isEqualToString:noText]) {
        [cellText appendString:zipCode];
    }
    return cellText;
}

@end
