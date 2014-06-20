
//
//  beFirstViewController.m
//  BluetoothTest
//
//  Created by Patrick Belon on 6/6/14.
//  Copyright (c) 2014 Belon Engineering. All rights reserved.
//

#import "beFirstViewController.h"
#import "beBatteryService.h"
#import "beSystemControlService.h"
#import "beDiscover.h"

@interface beFirstViewController () <beBatteryServiceProtocol,CLLocationManagerDelegate>
@property(strong,nonatomic) beBatteryService *batteryService;
@property MKCoordinateRegion regionToDisplay;
@end

@implementation beFirstViewController
@synthesize batteryService;
@synthesize mapView;
@synthesize locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[beDiscover sharedInstance]setPeripheralDelegate:self];
    //regionToDisplay = [MKCoo]
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    
    CLLocation *location = locationManager.location;
    MKCoordinateRegion r = MKCoordinateRegionMakeWithDistance(location.coordinate, 15.0, 15.0);
    [mapView setRegion:r];
    
    [locationManager startUpdatingLocation];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClicked:(id)sender {
        [[beDiscover sharedInstance]startScanningForUUIDString:beSystemControlServiceUUIDString];
        _textView.text = [_textView.text stringByAppendingString:@"\n"];
        _textView.text = [_textView.text stringByAppendingString:@"Searching"];
}


#pragma mark - 
#pragma mark CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    //Need to improve cached events
    CLLocation *location = locationManager.location;
    MKCoordinateRegion r = MKCoordinateRegionMakeWithDistance(location.coordinate, 15.0, 15.0);
    [mapView setRegion:r];
    
}


#pragma mark - 
#pragma mark MKMapView Methods



#pragma mark -
#pragma mark beBatterySErvice Delegate Methods
/****************************************************************************/
/*				beBatteryServiceProtocol Delegate Methods					*/
/****************************************************************************/

/** Max or Min change request complete */
- (void) batteryServiceDidChangeBatteryLevel:(beBatteryService *)service
{
    UInt16 level = [service batteryPercentage];
    NSString *batteryLevelString = [NSString stringWithFormat:@"%d",level];
    
    _batteryLevelLabel.text = batteryLevelString;
    
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
