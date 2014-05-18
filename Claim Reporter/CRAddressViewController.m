//
//  CRAddressViewController.m
//  Claim Reporter
//
//  Created by Seema on 7/05/14.
//  Copyright (c) 2014 iDoodle. All rights reserved.
//

#import "CRAddressViewController.h"

@interface CRAddressViewController ()

@property (strong, nonatomic) IBOutlet UITextField *streetTextField;
@property (strong, nonatomic) IBOutlet UITextField *suburbTextField;
@property (strong, nonatomic) IBOutlet UITextField *cityTextField;

@end

@implementation CRAddressViewController

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
    self.streetTextField.text = self.street;
    self.suburbTextField.text = self.suburb;
    self.cityTextField.text = self.city;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)okButtonPressed:(UIButton *)sender {
    
    [self willMoveToParentViewController:nil];
    self.view.superview.hidden = true;
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.delegate returnAddress:self.streetTextField.text suburb:self.suburbTextField.text city:self.cityTextField.text];
    

}

@end
