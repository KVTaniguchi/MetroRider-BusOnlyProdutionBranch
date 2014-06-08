//
//  KTMapSearchVC.m
//  MetroRider
//
//  Created by Kevin Taniguchi on 5/9/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import "KTMapSearchVC.h"
#import "KTSearchTBCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RACEXTScope.h"
@interface KTMapSearchVC ()
{
    KTSearchTBLVC *ktSearchTBLVC;
    KTRouteMapVC *mapWithSearchedPlacemark;
    CLGeocoder *geocoder;
    CLPlacemark *selectedPlacemark;
    NSString *selectedPlacemarkText;
}
@end

@implementation KTMapSearchVC

@synthesize searchTextField, containerView, region, route;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[[self navigationController] navigationBar] setHidden:YES];
    ktSearchTBLVC = [[KTSearchTBLVC alloc]initWithStyle:UITableViewStylePlain];
    [self addChildViewController:ktSearchTBLVC];
    ktSearchTBLVC.tableView.delegate = self;
    ktSearchTBLVC.placeMarks = [[NSMutableArray alloc]init];
    [ktSearchTBLVC.tableView setFrame:CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height)];
    [self.containerView addSubview:ktSearchTBLVC.view];
    
    [[self.searchTextField.rac_textSignal filter:^BOOL(id value) {
        NSString *text = value;
        return text.length > 3;
    }]
     subscribeNext:^(id x) {
         self.searchTextField.backgroundColor = [UIColor yellowColor];
         [self hitGeocoder:x];
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.searchTextField resignFirstResponder];
    selectedPlacemark = (ktSearchTBLVC.placeMarks)[indexPath.row];
    KTSearchTBCell *selectedCell = (KTSearchTBCell*)[ktSearchTBLVC.tableView cellForRowAtIndexPath:indexPath];
    selectedPlacemarkText = [NSString stringWithFormat:@"%@", selectedCell.placeMarkAddress.text];
    [self performSegueWithIdentifier:@"placemarkSelectedSegue" sender:self];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([self.searchTextField isFirstResponder]) {
        [self.searchTextField resignFirstResponder];
    }
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([self.searchTextField isFirstResponder]) {
        [self.searchTextField resignFirstResponder];
    }
}

-(void)hitGeocoder:(NSString*)searchText{
    if (!geocoder) {
        geocoder = [[CLGeocoder alloc]init];
    }
    [geocoder geocodeAddressString:self.searchTextField.text inRegion:self.region completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"error: %@", [error localizedDescription]);
        }
        [ktSearchTBLVC.placeMarks removeAllObjects];
        // process placemarks
        NSMutableArray *processedPlacemarks = [NSMutableArray arrayWithArray:placemarks];
        ktSearchTBLVC.placeMarks = [NSMutableArray arrayWithArray:[self parseRegion:processedPlacemarks]];
        [ktSearchTBLVC.tableView reloadData];
    }];
}

-(NSMutableArray*)parseRegion:(NSMutableArray*)placeMarks{
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:placeMarks];
    for (CLPlacemark *placeMark in placeMarks) {
        if (![self.region containsCoordinate:placeMark.location.coordinate]) {
            [tempArray removeObject:placeMark];
        }
    }
    return tempArray;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [searchTextField resignFirstResponder];
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    [self hitGeocoder:self.searchTextField.text];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"returnToMapSegue"]) {
        KTRouteMapVC *map = [segue destinationViewController];
        map.startOver = YES;
        map.route = self.route;
    }
    if ([segue.identifier isEqualToString:@"placemarkSelectedSegue"]) {
        KTRouteMapVC *map = [segue destinationViewController];
        map.searchedPlacemark = selectedPlacemark;
        map.searchedPlacemarktext = selectedPlacemarkText;
        map.route = self.route;
        map.startOver = YES;
        map.layMapWithPlacemark = YES;
    }
}

-(BOOL)isValidSearchText:(NSString*)text{
    return text.length > 2;
}

@end
