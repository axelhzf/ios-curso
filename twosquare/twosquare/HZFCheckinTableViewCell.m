//
//  HZFCheckinTableViewCell.m
//  twosquare
//
//  Created by Axel Hernández Ferrera on 06/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HZFCheckinTableViewCell.h"
#import "HZFCheckin.h"

@implementation HZFCheckinTableViewCell

@synthesize labelName, labelUser, labelDate, imgCategory, checkin = _checkin;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCheckin:(HZFCheckin *)checkin {
    _checkin = checkin;
    
    labelName.text = checkin.nombre;
    labelUser.text = checkin.usuario;
    
    static NSDateFormatter* dateFormatter = nil;
    if(dateFormatter == nil){
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";     
    }
    
    labelDate.text = [dateFormatter stringFromDate:checkin.fechaCreacion];
    
    if([checkin.categoria isEqualToString:@"restaurante"]){
        imgCategory.image = [UIImage imageNamed:@"restaurante.png"];
    }else if([checkin.categoria isEqualToString:@"tienda"]){
        imgCategory.image = [UIImage imageNamed:@"tienda.png"];        
    }else{
        imgCategory.image = [UIImage imageNamed:@"bar.png"];        
    }
}

@end
