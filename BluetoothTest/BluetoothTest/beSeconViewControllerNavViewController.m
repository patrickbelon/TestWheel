//
//  beSeconViewControllerNavViewController.m
//  BluetoothTest
//
//  Created by Patrick Belon on 6/19/14.
//  Copyright (c) 2014 BioCom. All rights reserved.
//

#import "beSeconViewControllerNavViewController.h"

@interface beSeconViewControllerNavViewController ()

@end

@implementation beSeconViewControllerNavViewController
@synthesize tabBar;

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
    
    UIImage *selectedTab = [UIImage imageNamed: @"infoSelected"];
    selectedTab = [selectedTab imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *regularTab = [UIImage imageNamed:@"infoRegular"];
    regularTab = [regularTab imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    tabBar.selectedImage = selectedTab;
    tabBar.image = regularTab;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
