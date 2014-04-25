//
//  CRDisplayContentSegue.m
//  Claim Reporter
//
//  Created by Seema on 18/04/14.
//  Copyright (c) 2014 iDoodle. All rights reserved.
//

#import "CRDisplayContentSegue.h"
#import "CRMenuDrawerViewController.h"
#import "CRMenuViewController.h"
//#import <QuartzCore/QuartzCore.h>

@implementation CRDisplayContentSegue

-(void)perform
{
    CRMenuDrawerViewController* menuDrawerViewController =
    ((CRMenuViewController*)self.sourceViewController).menuDrawerViewController;
    
    menuDrawerViewController.content = self.destinationViewController;
    
    [self showView:menuDrawerViewController.content withShadow:YES withOffset:-1];
}

- (void)showView:(UIViewController *)viewController withShadow:(BOOL)value withOffset:(double)offset
{
    if (value)
    {
        [viewController.view.layer setCornerRadius:4];
        [viewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [viewController.view.layer setShadowOpacity:0.8];
        [viewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
    else
    {
        [viewController.view.layer setCornerRadius:0.0f];
        [viewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
}
@end
