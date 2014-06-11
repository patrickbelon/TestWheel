//
//  beFirstViewController.m
//  BluetoothTest
//
//  Created by Patrick Belon on 6/6/14.
//  Copyright (c) 2014 BioCom. All rights reserved.
//

#import "beFirstViewController.h"
#import "beBatteryService.h"
#import "beDiscover.h"

@interface beFirstViewController () <beBatteryServiceProtocol,beDiscoverDelegate >
@property(strong,nonatomic) beBatteryService *batteryService;
@end

@implementation beFirstViewController
@synthesize batteryService;

- (void)viewDidLoad
{
    [super viewDidLoad];
	[[beDiscover sharedInstance]setDiscoveryDelegate:self];
    [[beDiscover sharedInstance]setPeripheralDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClicked:(id)sender {
        [[beDiscover sharedInstance]startScanningForUUIDString:beBatteryServiceUUIDString];
}

#pragma mark -
#pragma mark beBatterySErvice Delegate Methods
/****************************************************************************/
/*				LeTemperatureAlarmProtocol Delegate Methods					*/
/****************************************************************************/

/** Max or Min change request complete */
- (void) batteryServiceDidChangeBatteryLevel:(beBatteryService *)service
{
    CGFloat level = [service batteryPercentage];
    NSString *batteryPercentageString = [NSString stringWithFormat:@" Changed battery percentage: %f",level];
    _textView.text = [_textView.text stringByAppendingString:@"\n"];
    _textView.text = [_textView.text stringByAppendingString:batteryPercentageString];
    
}

-(void) batteryServiceDidChangeStatus:(beBatteryService *)service
{
    
}

-(void)batteryServiceDidReset{
    
}



-(void)discoveryDidRefresh
{
    
}

-(void)discoveryStatePoweredOff{
    
}

@end
