//
//  beFirstViewController.h
//  BluetoothTest
//
//  Created by Patrick Belon on 6/6/14.
//  Copyright (c) 2014 BioCom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface beFirstViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *connectButton;
@property (strong, nonatomic) IBOutlet UITextView *textView;
- (IBAction)buttonClicked:(id)sender;

@end
