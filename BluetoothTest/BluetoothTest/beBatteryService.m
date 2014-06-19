//
//  beBatteryService.m
//  BluetoothTest
//
//  Created by Patrick Belon on 6/6/14.
//  Copyright (c) 2014 Electron Wheel. All rights reserved.
//

#import "beBatteryService.h"

NSString *beBatteryServiceUUIDString = @"180f";
NSString *beSystemControlServiceUUIDString = @"22cd3f90-f271-4888-83af-ba344c66e124";

NSString *beCurrentBatteryLevelCharacteristicUUIDString = @"2a19";
NSString *beUserCompensationCharacteristicUUIDString = @"e3dcec81-af24-4961-9f94-b865702dfbae";
NSString *beBikeEnableCharacteristicUUIDString = @"fb54f9c3-0d8a-43df-8bca-7170c1753dad";

NSString *beBatteryServiceEnteredBackgroundNotification =
@"beBatteryServiceEnteredBackgroundNotification";
NSString *beBatteryServiceEnteredForegroundNotification =
@"beBatteryServiceEnteredForegroundNotification";

@interface beBatteryService() <CBPeripheralDelegate> {
@private
    CBPeripheral        *servicePeripheral;
    
    CBService           *batteryService;
    CBService           *systemControlService;              //May not need
    
    CBCharacteristic    *batteryCharacteristic;
    CBCharacteristic    *userCompensationCharacteristic;    //May not need
    CBCharacteristic    *bikeEnableCharacteristic;          //May not need
    
    //What is the retain on these?
    CBUUID              *currentBatteryLevelUUID;
    CBUUID              *batteryLevelUUID;
    CBUUID              *userCompensationUUID;
    CBUUID              *bikeEnableUUID;
    
    id<beBatteryServiceProtocol> peripheralDelegate;
}
@end

@implementation beBatteryService

@synthesize peripheral = servicePeripheral; //Why does this happen?
@synthesize batteryPercentage;
@synthesize systemControlDelegate;


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
        userCompensationUUID    = [CBUUID UUIDWithString:beUserCompensationCharacteristicUUIDString];
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
    CBUUID  *systemControlUUID   = [CBUUID UUIDWithString:beSystemControlServiceUUIDString];
	NSArray	*serviceArray	= [NSArray arrayWithObjects:serviceUUID, nil];
    
    [servicePeripheral discoverServices:nil];
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
        NSLog(@"Discovered service: %@",service.UUID.description);
		if ([[service UUID] isEqual:[CBUUID UUIDWithString:beBatteryServiceUUIDString]]) {
			batteryService = service;
		}
        else if([[service UUID]isEqual:[CBUUID UUIDWithString:beSystemControlServiceUUIDString]])
        {
            systemControlService = service;
        }
	}
    
	if (batteryService) {
		[peripheral discoverCharacteristics:nil forService:batteryService];
	}
    if(systemControlService){
        [peripheral discoverCharacteristics:nil forService:systemControlService];
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
	
	if (!(service == batteryService || service ==systemControlService)) {
		NSLog(@"Wrong Service.\n");
		return ;
	}
    
    if (error != nil) {
		NSLog(@"Error %@\n", error);
		return ;
	}
    
	for (characteristic in characteristics) {
        NSLog(@"discovered characteristic %@", [characteristic UUID]);
        
		if ([[characteristic UUID] isEqual:currentBatteryLevelUUID]) {
            NSLog(@"Discovered battery level Characteristic");
			batteryCharacteristic = characteristic;
            [peripheral setNotifyValue:YES forCharacteristic:batteryCharacteristic];
		}
        else if ([[characteristic UUID] isEqual:userCompensationUUID]) {
            NSLog(@"Discovered user compensation Characteristic");
			userCompensationCharacteristic = characteristic;
            [peripheral readValueForCharacteristic:userCompensationCharacteristic];
		}
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if([characteristic.UUID isEqual:currentBatteryLevelUUID]){
        [peripheralDelegate batteryServiceDidChangeBatteryLevel:self];
        NSData *data = characteristic.value;
        
        uint16_t battery = CFSwapInt32BigToHost(*(UInt16*)([data bytes]));
        
        batteryPercentage = battery;
    }
    else if([characteristic.UUID isEqual:userCompensationUUID])
    {
        [systemControlDelegate userCompensationServiceDidChangeValue:self];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    if(error != nil)
    {
        NSLog(@"error: %@",error.description);
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Calibration Error" message:@"There was an error calibrating your wheel." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alert show];
    }
    else
    {
        NSLog(@"Write succeeded");
    }
}

-(void) compensateWheel{
    
    NSData *data = nil;
    uint8_t value = 0x1;
    
    data = [NSData dataWithBytes:&value length:sizeof(value)];
    
    [servicePeripheral writeValue:data forCharacteristic:userCompensationCharacteristic type:CBCharacteristicWriteWithResponse];
}

-(void)enteredBackground{
    
}

-(void)enteredForeground{
    
}


@end
