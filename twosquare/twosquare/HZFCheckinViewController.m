//
//  HZFCheckinViewController.m
//  twosquare
//
//  Created by Axel Hernández Ferrera on 22/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HZFCheckinViewController.h"
#import "HZFCheckin.h"
#import <Twitter/Twitter.h>


@interface HZFCheckinViewController ()

@end

@implementation HZFCheckinViewController

@synthesize checkin;

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.checkin = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"toMapView"]){
        id destination = segue.destinationViewController;
        SEL setCheckin = @selector(setCheckin:);
        if([destination respondsToSelector:setCheckin]){
            [destination performSelector:setCheckin withObject:self.checkin];
        }
    }
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int shareSection;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        shareSection = 1;
    }else{
        shareSection = 0;
    }
    
    if(indexPath.section == shareSection){
        if(indexPath.row == 0){
            [self twitterShare];
        }else if(indexPath.row == 1){
            [self emailShare];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)twitterShare {
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
    NSString *initialText = [NSString stringWithFormat:@"Descubriendo %@ gracias a @iostwosquare", self.checkin.nombre];
    [twitter setInitialText:initialText];
    [self presentModalViewController:twitter animated:YES];
}

- (void)emailShare  {
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:@"TwoSquare"];
    NSString *initialText = [NSString stringWithFormat:@"Descubriendo %@ gracias a @iostwosquare", self.checkin.nombre];
    [controller setMessageBody:initialText isHTML:NO]; 

    [self presentModalViewController:controller animated:YES];
}
             
- (void)mailComposeController:(MFMailComposeViewController*)controller  
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError*)error; {
    [self dismissModalViewControllerAnimated:YES];
}

@end
