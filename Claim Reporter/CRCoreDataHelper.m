//
//  CRCoreDataHelper.m
//  Claim Reporter
//
//  Created by Seema on 16/05/14.
//  Copyright (c) 2014 iDoodle. All rights reserved.
//

#import "CRCoreDataHelper.h"

@implementation CRCoreDataHelper

+(NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context;
    
    id delegate = [[UIApplication sharedApplication] delegate];
    
    if ([delegate performSelector:@selector(managedObjectContext)])
    {
        context = [delegate managedObjectContext];
    }
    
    return context;
}

@end
