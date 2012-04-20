//
//  HZFNewCheckinViewController.m
//  twosquare
//
//  Created by Axel Hernández Ferrera on 06/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HZFNewCheckinViewController.h"
#import "HZFCheckins.h"
#import "HZFCheckin.h"

@interface HZFNewCheckinViewController ()

@property (strong, nonatomic) UITapGestureRecognizer *gestureRecognizer;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *lastLocation;

@end

@implementation HZFNewCheckinViewController

@synthesize categoryCell;
@synthesize latitudeCell;
@synthesize longitudeCell;
@synthesize fieldNombre, gestureRecognizer, category, locationManager, lastLocation;


- (void)initLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 100.0f;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    self.gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
    [self initLocationManager];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.locationManager startUpdatingLocation];
}

- (void)viewDidUnload{
    [self.tableView removeGestureRecognizer:self.gestureRecognizer];
    
    self.fieldNombre = nil;
    self.gestureRecognizer = nil;
    self.locationManager = nil;
    
    [self setCategoryCell:nil];
    [self setLatitudeCell:nil];
    [self setLongitudeCell:nil];
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)hideKeyboard {
    [self.fieldNombre resignFirstResponder];
}

- (IBAction)save:(UIBarButtonItem *)sender {    
    HZFCheckin *checkin = [[HZFCheckin alloc] init];
    checkin.nombre = self.fieldNombre.text;
    checkin.fechaCreacion = [NSDate date];
    checkin.categoria = self.category;
    checkin.latitud = self.lastLocation.coordinate.latitude;
    checkin.longitud = self.lastLocation.coordinate.longitude;
    
    HZFCheckins *checkins = [HZFCheckins sharedInstance];
    [checkins.data addObject:checkin];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *destination = segue.destinationViewController;
    if ([[segue identifier] isEqualToString:@"selectCategory"]){
        
        if ([destination respondsToSelector:@selector(setDelegate:)]) {
            [destination setValue:self forKey:@"delegate"];
            
        }
        
        if([destination respondsToSelector:@selector(setSelectedCategory:)]){
            [destination performSelector:@selector(setSelectedCategory:) withObject:self.category];
        }
    }
}

- (void)setCategory:(NSString *)_category {
    category = _category;
    self.categoryCell.detailTextLabel.text = _category;
}

- (void)setLastLocation:(CLLocation *)_lastLocation {
    lastLocation = _lastLocation;
    
    self.latitudeCell.detailTextLabel.text = [NSString stringWithFormat:@"%f", lastLocation.coordinate.latitude];
    [self.latitudeCell setNeedsLayout];

    self.longitudeCell.detailTextLabel.text = [NSString stringWithFormat:@"%f", lastLocation.coordinate.longitude];
    [self.longitudeCell setNeedsLayout];
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.lastLocation = newLocation;
}


@end
