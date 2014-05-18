//
//  CRAddressViewController.h
//  Claim Reporter
//
//  Created by Seema on 7/05/14.
//  Copyright (c) 2014 iDoodle. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CRAddressViewControllerDelegate <NSObject>
- (void)returnAddress:(NSString *)street suburb:(NSString *)suburb city:(NSString *)city;
@end

@interface CRAddressViewController : UIViewController

@property (strong, nonatomic) NSString *street;
@property (strong, nonatomic) NSString *suburb;
@property (strong, nonatomic) NSString *city;
@property (weak, nonatomic) id <CRAddressViewControllerDelegate> delegate;


@end
