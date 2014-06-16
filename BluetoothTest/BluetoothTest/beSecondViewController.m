//
//  beSecondViewController.m
//  BluetoothTest
//
//  Created by Patrick Belon on 6/6/14.
//  Copyright (c) 2014 BioCom. All rights reserved.
//

#import "beDiscover.h"
#import "beSecondViewController.h"
#import "beSystemControlService.h"

@interface beSecondViewController ()<beDiscoverDelegate,beSystemControlServiceProtocol>{
@private
    
    bool isWheelConnected;
}
@end

@implementation beSecondViewController

@synthesize connectButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	[[beDiscover sharedInstance]setDiscoveryDelegate:self];
    [[beDiscover sharedInstance]setSystemControlDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --
#pragma mark beDiscoveryDelegate methods

-(void)discoveryStatePoweredOff{
    
}

-(void)discoveryDidRefresh{
    
}

-(void)peripheralChangedState:(CBPeripheralState)state
{
    if(state == CBPeripheralStateConnected)
    {

    }
    else if(state == CBPeripheralStateDisconnected)
    {

    }
}

-(void)discoveryDidUpdateState:(beDiscoveryState)state
{
    
    switch (state) {
        case beDiscoveryStateDisconnected:
            NSLog(@"discoveryUpdatedState: Disconnected");
            isWheelConnected = false;
            [connectButton setTitle:@"Connect" forState:UIControlStateNormal];
            break;
            
        case beDiscoveryStateSearching:
            NSLog(@"discoveryUpdatedState: Searching");
            connectButton.enabled=NO;
            [connectButton setTitle:@"Connecting..." forState:UIControlStateNormal];
            break;
            
        case beDiscoveryStateConnecting:
            NSLog(@"discoveryUpdatedState: Connecting");
            break;
        
        case beDiscoveryStateConnected:
            [connectButton setTitle:@"Disconnect" forState:UIControlStateNormal];
            connectButton.enabled = YES;
            NSLog(@"discoveryUpdatedState: Connected");
            isWheelConnected = true;
            break;
            
        default:
            NSLog(@"wrong state");
            break;
    }
}

#pragma mark -
#pragma mark beSystemControlService Delegate Methods
/****************************************************************************/
/*				beSystemControlServiceProtocol Delegate Methods					*/
/****************************************************************************/

-(void)userCompensationServiceDidChangeValue:(beBatteryService *)service{
    NSLog(@"User compensated wheel: SecondViewController");
}


#pragma mark --
#pragma mark APP I/O

- (IBAction)connectButtonPressed:(id)sender {
    if(!isWheelConnected)
    {
        [[beDiscover sharedInstance]startScanningForUUIDString:beBatteryServiceUUIDString];
    }
    else
    {
        [[beDiscover sharedInstance]disconnectPeripheral];
    }
}

- (IBAction)calibrateButtonPressed:(id)sender {
    NSMutableArray *arr = [[beDiscover sharedInstance]connectedServices];
    beBatteryService *ser = [arr objectAtIndex:0];
    
    [ser compensateWheel];
}
@end
