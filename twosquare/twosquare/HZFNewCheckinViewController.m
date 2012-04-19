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
@end

@implementation HZFNewCheckinViewController
@synthesize categoryCell;

@synthesize fieldNombre, gestureRecognizer, category;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    self.gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
}

- (void)viewDidUnload{
    [self.tableView removeGestureRecognizer:self.gestureRecognizer];
    
    self.fieldNombre = nil;
    self.gestureRecognizer = nil;
    
    [self setCategoryCell:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
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

@end
