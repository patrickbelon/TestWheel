//
//  beFirstViewController.h
//  BluetoothTest
//
//  Created by Patrick Belon on 6/6/14.
//  Copyright (c) 2014 BioCom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface beFirstViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *connectButton;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet CLLocationManager *locationManager;
- (IBAction)buttonClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *batteryLevelLabel;
@property (strong, nonatomic) IBOutlet UILabel *speedLabel;

@end
