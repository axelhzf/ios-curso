//
//  HZFViewController.m
//  HelloWorld2
//
//  Created by Axel Hernández Ferrera on 17/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HZFViewController.h"

@interface HZFViewController ()

@end

@implementation HZFViewController
@synthesize label;
@synthesize boton1;
@synthesize boton2;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setLabel:nil];
    [self setBoton1:nil];
    [self setBoton2:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   
    
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)cambiarTexto:(id)sender {
    if(sender == boton1){
        label.text = @"Se pulsó el botón 1";
    }else if(sender == boton2){
        label.text = @"Se pulsó el botón 2";        
    }
}

@end
