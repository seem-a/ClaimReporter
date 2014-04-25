//
//  CRBarcodeScannerViewController.h
//  Claim Reporter
//
//  Created by Seema on 25/04/14.
//  Copyright (c) 2014 iDoodle. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CRBarcodeScannerViewControllerDelegate <NSObject>

- (void)processScannedLogin:(NSString *)customerName customerID:(NSString *)customerID dateOfBirth:(NSDate *)dateOfBirth;

@end

@interface CRBarcodeScannerViewController : UIViewController

@property (weak, nonatomic) id <CRBarcodeScannerViewControllerDelegate> delegate;

@end
