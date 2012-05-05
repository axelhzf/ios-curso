//
//  NSString+Utilities.m
//  objintro
//
//  Created by Axel Hernández Ferrera on 05/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+Utilities.h"

@implementation NSString (Utilities)

- (BOOL)isEmail {
    NSRange range = [self rangeOfString:@"@"];
    return range.location != NSNotFound;
}

@end
