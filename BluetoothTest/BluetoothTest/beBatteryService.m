//
//  beBatteryService.m
//  BluetoothTest
//
//  Created by Patrick Belon on 6/6/14.
//  Copyright (c) 2014 Electron Wheel. All rights reserved.
//

#import "beBatteryService.h"

NSString *beBatteryServiceUUIDString = @"180f";
NSString *beCurrentBatteryLevelCharacteristicUUIDString = @"2a19";

NSString *beBatteryServiceEnteredBackgroundNotification =
@"beBatteryServiceEnteredBackgroundNotification";
NSString *beBatteryServiceEnteredForegroundNotification =
@"beBatteryServiceEnteredForegroundNotification";

@interface beBatteryService() <CBPeripheralDelegate> {
@private
    CBPeripheral        *servicePeripheral;
    
    CBService           *batteryService;
    
    CBCharacteristic    *batteryCharacteristic;
    
    CBUUID              *currentBatteryLevelUUID;
    CBUUID              *batteryLevelUUID;
    
    id<beBatteryServiceProtocol> peripheralDelegate;
}
@end

@implementation beBatteryService

@synthesize peripheral = servicePeripheral; //Why does this happen?
@synthesize batteryPercentage;


#pragma mark - 
#pragma mark Init 
/****************************************************************************/
/*								Init										*/
/****************************************************************************/
- (id) initWithPeripheral:(CBPeripheral *)peripheral controller:(id<beBatteryServiceProtocol>)controller
{
    self = [super init];
    if (self) {
        servicePeripheral = peripheral;
        [servicePeripheral setDelegate:self];
		peripheralDelegate = controller;
        
        currentBatteryLevelUUID	= [CBUUID UUIDWithString:beCurrentBatteryLevelCharacteristicUUIDString];
        batteryLevelUUID        = [CBUUID UUIDWithString:beBatteryServiceUUIDString];
	}
    return self;
}

- (void) reset
{
	if (servicePeripheral) {
		servicePeripheral = nil;
	}
}

#pragma mark -
#pragma mark Service interaction
/****************************************************************************/
/*							Service Interactions							*/
/****************************************************************************/
- (void) start
{
	CBUUID	*serviceUUID	= [CBUUID UUIDWithString:beBatteryServiceUUIDString];
	NSArray	*serviceArray	= [NSArray arrayWithObjects:serviceUUID, nil];
    
    [servicePeripheral discoverServices:serviceArray];
}

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
	NSArray		*services	= nil;
	NSArray		*uuids	= [NSArray arrayWithObjects:currentBatteryLevelUUID,
                           nil];
    
	if (peripheral != servicePeripheral) {
		NSLog(@"Wrong Peripheral.\n");
		return ;
	}
    
    if (error != nil) {
        NSLog(@"Error %@\n", error);
		return ;
	}
    
	services = [peripheral services];
	if (!services || ![services count]) {
		return ;
	}
    
	batteryService = nil;
    
	for (CBService *service in services) {
		if ([[service UUID] isEqual:[CBUUID UUIDWithString:beBatteryServiceUUIDString]]) {
			batteryService = service;
			break;
		}
	}
    
	if (batteryService) {
		[peripheral discoverCharacteristics:uuids forService:batteryService];
	}
}


- (void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error;
{
	NSArray		*characteristics	= [service characteristics];
	CBCharacteristic *characteristic;
    
	if (peripheral != servicePeripheral) {
		NSLog(@"Wrong Peripheral.\n");
		return ;
	}
	
	if (service != batteryService) {
		NSLog(@"Wrong Service.\n");
		return ;
	}
    
    if (error != nil) {
		NSLog(@"Error %@\n", error);
		return ;
	}
    
	for (characteristic in characteristics) {
        NSLog(@"discovered characteristic %@", [characteristic UUID]);
        
		if ([[characteristic UUID] isEqual:currentBatteryLevelUUID]) { // Min Temperature.
            NSLog(@"Discovered battery level Characteristic");
			batteryCharacteristic = characteristic;
			[peripheral readValueForCharacteristic:characteristic];
		}
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"Updated value");
    [peripheralDelegate batteryServiceDidChangeBatteryLevel:self];
}

-(void)enteredBackground{
    
}

-(void)enteredForeground    {
    
}


@end
