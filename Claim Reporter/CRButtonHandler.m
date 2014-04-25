//
//  CRButtonHandler.m
//  Claim Reporter
//
//  Created by Seema on 19/04/14.
//  Copyright (c) 2014 iDoodle. All rights reserved.
//

#import "CRButtonHandler.h"

@implementation CRButtonHandler

-(IBAction)handleButton:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notifyButtonPressed" object:self];
}

@end
