//
//  ChosenStopVC.m
//  MetroRider
//
//  Created by Kevin Taniguchi on 4/27/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import "ChosenStopVC.h"

@interface ChosenStopVC ()

@end

@implementation ChosenStopVC
@synthesize route, stopAddressTextView, choseStopVCDetailTextView, headLineLabel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIColor * lightBlueColor = [UIColor colorWithRed:119/255.0f green:176/255.0f blue:245/255.0f alpha:0.5f];
    [self.route.layer setBackgroundColor:lightBlueColor.CGColor];
    
    UIColor * skyBlueColor = [UIColor colorWithRed:119/255.0f green:184/255.0f blue:213/255.0f alpha:0.5f];
    [self.stopAddressTextView.layer setBackgroundColor:skyBlueColor.CGColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)chooseAnotherStopButtonPressed:(UIButton*)sender {
    [[self chosenStopDelegate] chooseAnotherStop];
}
@end
