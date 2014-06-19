//
//  RideSelectCVC.m
//  MetroRider
//
//  Created by Kevin Taniguchi on 4/14/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import "RideSelectCVC.h"

@interface RideSelectCVC ()

@end

@implementation RideSelectCVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RideSelectCell *rideSelectCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RideSelectCell" forIndexPath:indexPath];
    rideSelectCell.routeLabel.text = [self routesToDisplay][indexPath.row];
    return rideSelectCell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.routesToDisplay count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
