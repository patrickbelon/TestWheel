//
//  beFirstViewController.m
//  BluetoothTest
//
//  Created by Patrick Belon on 6/6/14.
//  Copyright (c) 2014 Belon Engineering. All rights reserved.
//

#import "beFirstViewController.h"
#import "beBatteryService.h"
#import "beDiscover.h"

@interface beFirstViewController () <beBatteryServiceProtocol>
@property(strong,nonatomic) beBatteryService *batteryService;
@end

@implementation beFirstViewController
@synthesize batteryService;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[beDiscover sharedInstance]setPeripheralDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClicked:(id)sender {
        [[beDiscover sharedInstance]startScanningForUUIDString:beBatteryServiceUUIDString];
        _textView.text = [_textView.text stringByAppendingString:@"\n"];
        _textView.text = [_textView.text stringByAppendingString:@"Searching"];
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
 if([service.peripheral state] == CBPeripheralStateConnected)
 {
     _textView.text = [_textView.text stringByAppendingString:@"\n"];
     _textView.text = [_textView.text stringByAppendingString:@"Connected battery peripheral"];
 }
}

-(void)batteryServiceDidReset{
    
}



-(void)discoveryDidRefresh
{
    
}

-(void)discoveryStatePoweredOff{
    
}

@end
