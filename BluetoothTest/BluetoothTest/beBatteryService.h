//
//  beBatteryService.h
//  BluetoothTest
//
//  Created by Patrick Belon on 6/6/14.
//  Copyright (c) 2014 Belon Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

/****************************************************************************/
/*						Services                                            */
/****************************************************************************/
extern NSString *beBatteryServiceUUIDString; //180f
extern NSString *beSystemControlServiceUUIDString;//22cd3f90-f271-4888-83af-ba344c66e124


/****************************************************************************/
/*						Characteristics                                     */
/****************************************************************************/
extern NSString *beCurrentBatteryLevelCharacteristicUUIDString; //21a9
extern NSString *beUserCompensationCharacteristicUUIDString;//e3dcec81-af24-4961-9f94-b865702dfbae
extern NSString *beBikeEnableCharacteristicUUIDString;//fb54f9c3-0d8a-43df-8bca-7170c1753dad

/****************************************************************************/
/*								Protocol									*/
/****************************************************************************/
@class beBatteryService;

@protocol beBatteryServiceProtocol<NSObject>
- (void) batteryServiceDidChangeBatteryLevel:(beBatteryService*)service;
- (void) batteryServiceDidChangeStatus:(beBatteryService*)service;
- (void) batteryServiceDidReset;
@end

@protocol beSystemControlServiceProtocol<NSObject>
- (void) userCompensationServiceDidChangeValue:(beBatteryService*)service;
@end



@interface beBatteryService : NSObject

@property (readonly) float batteryPercentage;
@property (readonly) bool  wheelCalibrated; 

- (id) initWithPeripheral:(CBPeripheral *)peripheral controller:(id<beBatteryServiceProtocol>)controller;
- (void) reset;
- (void) start;
- (void) compensateWheel;


/* Behave properly when heading into and out of the background */
- (void)enteredBackground;
- (void)enteredForeground;

@property (readonly) CBPeripheral *peripheral;
@property id<beSystemControlServiceProtocol> systemControlDelegate;

@end
