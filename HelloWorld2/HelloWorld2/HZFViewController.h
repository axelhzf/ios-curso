//
//  HZFViewController.h
//  HelloWorld2
//
//  Created by Axel Hernández Ferrera on 17/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZFViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIButton *boton1;
@property (strong, nonatomic) IBOutlet UIButton *boton2;

- (IBAction)cambiarTexto:(id)sender;

@end
