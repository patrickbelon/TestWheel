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

@interface beSecondViewController ()<beDiscoverDelegate,beSystemControlServiceProtocol,UIAlertViewDelegate>{
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

-(void)searchingTimedout{
    
}

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
            connectButton.enabled = true;
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
#pragma mark UIActionSheet Delegate Methods

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        NSMutableArray *arr = [[beDiscover sharedInstance]connectedServices];
        
        beBatteryService *ser = [arr objectAtIndex:0];
        [ser compensateWheel];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        NSMutableArray *arr = [[beDiscover sharedInstance]connectedServices];
        
        beBatteryService *ser = [arr objectAtIndex:0];
        [ser compensateWheel];
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
    if(arr.count >0){
//        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"Are you sure you want to calibrate your ewheel? Make sure that it is mounted on a bike, and that the bike is level on a level surface." delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
//        
//        [sheet showInView:self.view];
        
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Calibration" message:@"Are you sure that you want to calibrate your Electron Wheel?\n Make sure that it is properly mounted and that your bike is on a flat and level surface." delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
        
        [alert show];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Your electron wheel needs to be connected before you calibrate." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alert show];
    }
    
    }
@end
