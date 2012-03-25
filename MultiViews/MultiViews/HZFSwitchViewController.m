//
//  HZFSwitchViewController.m
//  MultiViews
//
//  Created by Axel Hernández Ferrera on 25/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HZFSwitchViewController.h"

@interface HZFSwitchViewController ()

@end

@implementation HZFSwitchViewController

@synthesize blueViewController, yellowViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [self insertarVistaAmarilla]; 
    [super viewDidLoad];
}

- (void)viewDidUnload {    
    [super viewDidUnload];
    self.blueViewController = nil;
    self.yellowViewController = nil;
}

-(void)insertarVistaAzul {
    if (self.blueViewController == nil){
        NSLog(@"Init blue");
        self.blueViewController =
        [[HZFBlueViewController alloc] initWithNibName:@"HZFBlueViewController" bundle:nil];
    }
    [self.view insertSubview:self.blueViewController.view atIndex:0];
}

- (void)insertarVistaAmarilla {
    if (self.yellowViewController == nil){
        NSLog(@"Init yellow");
        self.yellowViewController =
        [[HZFYellowViewController alloc] initWithNibName:@"HZFYellowViewController" bundle:nil];
    }
    [self.view insertSubview:self.yellowViewController.view atIndex:0];
}

- (IBAction)switchViews:(id)sender {     
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:1.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

    if ([self isViewVisible:self.blueViewController.view]){
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight
                               forView:self.view cache:YES];
        
        [blueViewController.view removeFromSuperview];
        [self insertarVistaAmarilla];
    }else{
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft
                               forView:self.view cache:YES];
        
        [yellowViewController.view removeFromSuperview];
        [self insertarVistaAzul];
    }

    [UIView commitAnimations];
}

- (BOOL)isViewVisible:(UIView *)view {
    return view.superview != nil;
}  


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if([self isViewVisible:self.blueViewController.view]){
        self.yellowViewController = nil;
    }else{
        self.blueViewController = nil;
    }
}

@end
