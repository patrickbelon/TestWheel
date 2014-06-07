//
//  beBatteryService.h
//  BluetoothTest
//
//  Created by Patrick Belon on 6/6/14.
//  Copyright (c) 2014 BioCom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

/****************************************************************************/
/*						Service Characteristics								*/
/****************************************************************************/


extern NSString *beBatteryServiceUUIDString; //180f
extern NSString *beCurrentBatteryLevelCharacteristicUUIDString; //21a9

/****************************************************************************/
/*								Protocol									*/
/****************************************************************************/
@class beBatteryService;

@protocol beBatteryServiceProtocol<NSObject>
- (void) batteryServiceDidChangeBatteryLevel:(beBatteryService*)service;
- (void) batteryServiceDidChangeStatus:(beBatteryService*)service;
- (void) batteryServiceDidReset;
@end



@interface beBatteryService : NSObject

@property (readonly) float batteryPercentage;

- (id) initWithPeripheral:(CBPeripheral *)peripheral controller:(id<beBatteryServiceProtocol>)controller;
- (void) reset;
- (void) start;


/* Behave properly when heading into and out of the background */
- (void)enteredBackground;
- (void)enteredForeground;

@property (readonly) CBPeripheral *peripheral;

@end
