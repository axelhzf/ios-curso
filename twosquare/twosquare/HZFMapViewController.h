//
//  HZFMapViewController.h
//  twosquare
//
//  Created by Axel Hernández Ferrera on 19/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class HZFCheckin;

@interface HZFMapViewController : UIViewController <MKMapViewDelegate, UIActionSheetDelegate, UISplitViewControllerDelegate> 

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) HZFCheckin *checkin;

- (IBAction)showMapTypeSelector:(id)sender;
- (IBAction)showPopover:(id)sender;

@end
