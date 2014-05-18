//
//  CRLocationViewController.h
//  Claim Reporter
//
//  Created by Seema on 26/04/14.
//  Copyright (c) 2014 iDoodle. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CRLocationViewControllerDelegate <NSObject>
- (void)returnAddress:(NSString *)street suburb:(NSString *)suburb city:(NSString *)city;
@end

@interface CRLocationViewController : UIViewController

@property (strong, nonatomic) UIViewController *addressViewController;
@property (weak, nonatomic) id <CRLocationViewControllerDelegate> delegate;

@end
