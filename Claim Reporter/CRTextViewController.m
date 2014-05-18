//
//  CRTextViewController.m
//  Claim Reporter
//
//  Created by Seema on 18/04/14.
//  Copyright (c) 2014 iDoodle. All rights reserved.
//

#import "CRTextViewController.h"
#import "CRBarcodeScannerViewController.h"
#define CORNER_RADIUS 4
@interface CRTextViewController () <CRBarcodeScannerViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *customerNameTextField;

@property (strong, nonatomic) IBOutlet UITextField *customerIDTextField;

@property (strong, nonatomic) IBOutlet UITextField *dateOfBirthTextField;


@end

@implementation CRTextViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helpers

- (void)clearFields
{
    self.customerIDTextField.text = @"";
    self.customerNameTextField.text = @"";
    self.dateOfBirthTextField.text = @"";
}


#pragma mark - CRBarcodeScannerViewControllerDelegate

-(void)processScannedLogin:(NSString *)customerName customerID:(NSString *)customerID dateOfBirth:(NSDate *)dateOfBirth
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    NSString *stringFromDate = [formatter stringFromDate:dateOfBirth];
    
    self.dateOfBirthTextField.text = stringFromDate;
    self.customerNameTextField.text = customerName;
    self.customerIDTextField.text = customerID;    
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[CRBarcodeScannerViewController class]]) {
        CRBarcodeScannerViewController *barcodeScannerViewController = (CRBarcodeScannerViewController *)segue.destinationViewController;
     
        barcodeScannerViewController.delegate = self;
        [self clearFields];
    }
}



@end
