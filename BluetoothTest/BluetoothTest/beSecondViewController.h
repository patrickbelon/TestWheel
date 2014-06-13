//
//  beSecondViewController.h
//  BluetoothTest
//
//  Created by Patrick Belon on 6/6/14.
//  Copyright (c) 2014 Belon Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface beSecondViewController : UIViewController

/******************DELEGATES********************/
@property (strong, nonatomic) IBOutlet UIButton *connectButton;
@property (strong, nonatomic) IBOutlet UIButton *calibrateButton;

/******************ACTIONS**********************/

- (IBAction)connectButtonPressed:(id)sender;
- (IBAction)calibrateButtonPressed:(id)sender;

@end
