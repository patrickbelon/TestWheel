//
//  beDiscover.m
//  BluetoothTest
//
//  Created by Patrick Belon on 6/6/14.
//  Copyright (c) 2014 Belon Engineering. All rights reserved.
//

#import "beDiscover.h"

@interface beDiscover () <CBCentralManagerDelegate, CBPeripheralDelegate> {
	CBCentralManager    *centralManager;
	BOOL				pendingInit;
}
    @property beDiscoveryState state;
@end

@implementation beDiscover

@synthesize foundPeripherals;
@synthesize connectedServices;
@synthesize discoveryDelegate;
@synthesize peripheralDelegate;
@synthesize connectedWheel;
@synthesize state;

#pragma mark -
#pragma mark Init
/****************************************************************************/
/*									Init									*/
/****************************************************************************/
+ (id) sharedInstance
{
	static beDiscover	*this	= nil;
    
	if (!this)
		this = [[beDiscover alloc] init];
    
	return this;
}

- (id) init
{
    self = [super init];
    if (self) {
		pendingInit = YES;
		centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
        
		foundPeripherals = [[NSMutableArray alloc] init];
		connectedServices = [[NSMutableArray alloc] init];
	}
    return self;
}

#pragma mark -
#pragma mark Discovery
/****************************************************************************/
/*								Discovery                                   */
/****************************************************************************/
//TODO This scanning method won't work.
//Cannot scan for eWheels using battery level uuid... maybe another one though
//May be a way to actually find the best ewheel to connect to
- (void) startScanningForUUIDString:(NSString *)uuidString
{
	NSArray			*uuidArray	= [NSArray arrayWithObjects:[CBUUID UUIDWithString:uuidString], nil];
	NSDictionary	*options	= [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    [self updateState:beDiscoveryStateSearching];
	[centralManager scanForPeripheralsWithServices:uuidArray options:options];
}


- (void) stopScanning
{
	[centralManager stopScan];
}


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
	if (![foundPeripherals containsObject:peripheral]) {
		[foundPeripherals addObject:peripheral];
		[discoveryDelegate discoveryDidRefresh];
        NSString *string = [NSString stringWithFormat:@"Found periph: %@",peripheral.name];
        NSLog(string);
        [self connectPeripheral:peripheral];
	}
}

#pragma mark -
#pragma mark Connection/Disconnection
/****************************************************************************/
/*						Connection/Disconnection                            */
/****************************************************************************/
- (void) connectPeripheral:(CBPeripheral*)peripheral
{
	if (peripheral.state == CBPeripheralStateDisconnected) {
		[centralManager connectPeripheral:peripheral options:nil];
        [self updateState:beDiscoveryStateConnecting];
	}
}


- (void) disconnectPeripheral
{
	[centralManager cancelPeripheralConnection:connectedWheel];
    connectedWheel = nil;
}


- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
	beBatteryService	*service	= nil;
    connectedWheel = peripheral;
	
	/* Create a service instance. */
	service = [[beBatteryService alloc] initWithPeripheral:peripheral controller:peripheralDelegate];
	[service start];
    
	if (![connectedServices containsObject:service])
		[connectedServices addObject:service];
    
	if ([foundPeripherals containsObject:peripheral])
		[foundPeripherals removeObject:peripheral];
    
    [peripheralDelegate batteryServiceDidChangeStatus:service];
	[discoveryDelegate discoveryDidRefresh];
    [self updateState:beDiscoveryStateConnected];
}


- (void) centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Attempted connection to peripheral %@ failed: %@", [peripheral name], [error localizedDescription]);
}


- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
	beBatteryService	*service	= nil;
    
    [self updateState:beDiscoveryStateDisconnected];
    
	for (service in connectedServices) {
		if ([service peripheral] == peripheral) {
			[connectedServices removeObject:service];
            [peripheralDelegate batteryServiceDidChangeStatus:service];
			break;
		}
	}
    
	[discoveryDelegate discoveryDidRefresh];
}

-(void) updateState: (beDiscoveryState) newState
{
    self.state = newState;
    [discoveryDelegate discoveryDidUpdateState:newState];
}

- (void) clearDevices
{
    beBatteryService	*service;
    [foundPeripherals removeAllObjects];
    
    for (service in connectedServices) {
        [service reset];
    }
    [connectedServices removeAllObjects];
}


- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    static CBCentralManagerState previousState = -1;
    
	switch ([centralManager state]) {
		case CBCentralManagerStatePoweredOff:
		{
            [self clearDevices];
            [discoveryDelegate discoveryDidRefresh];
            
			/* Tell user to power ON BT for functionality, but not on first run - the Framework will alert in that instance. */
            if (previousState != -1) {
                [discoveryDelegate discoveryStatePoweredOff];
            }
			break;
		}
            
		case CBCentralManagerStateUnauthorized:
		{
			/* Tell user the app is not allowed. */
			break;
		}
            
		case CBCentralManagerStateUnknown:
		{
			/* Bad news, let's wait for another event. */
			break;
		}
            
		case CBCentralManagerStatePoweredOn:
		{
			pendingInit = NO;
			//[self loadSavedDevices];
            //TODO INVESTIGATE FURTHER
			//[centralManager retrieveConnectedPeripherals];
			[discoveryDelegate discoveryDidRefresh];
			break;
		}
            
		case CBCentralManagerStateResetting:
		{
			[self clearDevices];
            [discoveryDelegate discoveryDidRefresh];
            [peripheralDelegate batteryServiceDidReset];
            
			pendingInit = YES;
			break;
		}
	}
    
    previousState = [centralManager state];
}
@end
