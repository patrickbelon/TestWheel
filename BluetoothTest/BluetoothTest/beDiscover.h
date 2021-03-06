//
//  beDiscover.h
//  BluetoothTest
//
//  Created by Patrick Belon on 6/6/14.
//  Copyright (c) 2014 Electron Wheel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "beBatteryService.h"
#import "beSystemControlService.h"


/****************************************************************************/
/*                             State                                        */
/***************************************************************************/
typedef enum
{
    beDiscoveryStateDisconnected,
    beDiscoveryStateSearching,
    beDiscoveryStateConnecting,
    beDiscoveryStateConnected
}beDiscoveryState;

/****************************************************************************/
/*							UI protocols									*/
/****************************************************************************/
@protocol beDiscoverDelegate <NSObject>
- (void) discoveryDidRefresh;
- (void) discoveryStatePoweredOff;
- (void) peripheralChangedState:(CBPeripheralState) state;
- (void) discoveryDidUpdateState: (beDiscoveryState)state;
- (void) searchingTimedout;
@end

/****************************************************************************/
/*							Discovery class									*/
/****************************************************************************/
@interface beDiscover : NSObject{
    
}
+(id) sharedInstance;

/****************************************************************************/
/*								UI controls									*/
/****************************************************************************/
@property (nonatomic, assign) id<beDiscoverDelegate>           discoveryDelegate;
@property (nonatomic, assign) id<beBatteryServiceProtocol>     peripheralDelegate;
@property (nonatomic, assign) id<beSystemControlServiceProtocol> systemControlDelegate;

/****************************************************************************/
/*								Actions										*/
/****************************************************************************/
- (void) startScanningForUUIDString:(NSString *)uuidString;
- (void) stopScanning;
- (void) connectPeripheral:(CBPeripheral*)peripheral;
- (void) disconnectPeripheral;
- (void) connectionTimeoutOccured:(NSTimer*)timer;

/****************************************************************************/
/*							Access to the devices							*/
/****************************************************************************/
@property (retain, nonatomic) NSMutableArray    *foundPeripherals;
@property (retain, nonatomic) NSMutableArray	*connectedServices;	// Array of batteryService
@property (strong, nonatomic) CBPeripheral      *connectedWheel;
@property (strong, nonatomic) CBService         *systemControlService;

/****************************************************************************/
/*                              Access to state                             */
/****************************************************************************/
@property (readonly) beDiscoveryState state;

/****************************************************************************/
/*                             Timer                                        */
/***************************************************************************/
@property (weak, nonatomic) NSTimer *timer;

@end

