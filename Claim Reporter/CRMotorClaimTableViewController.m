//
//  CRMotorClaimTableViewController.m
//  Claim Reporter
//
//  Created by Seema on 26/04/14.
//  Copyright (c) 2014 iDoodle. All rights reserved.
//

#import "CRMotorClaimTableViewController.h"
#import "CRLocationViewController.h"
#define MOTOR_NEW_CLAIM_LOCATION @"Motor New Claim Location"
#define LOCATION @"Location"



@interface CRMotorClaimTableViewController () <CRLocationViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableViewCell *locationTableViewCell;


@end

@implementation CRMotorClaimTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.locationTableViewCell.detailTextLabel.text = [self getLocation];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}
*/
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



#pragma mark - CRLocationViewControllerDelegate

- (void)returnAddress:(NSString *)street suburb:(NSString *)suburb city:(NSString *)city
{
    NSString *location = [NSString stringWithFormat:@"%@, %@, %@", street, suburb, city];
    [self saveLocation:location];
    
    self.locationTableViewCell.detailTextLabel.text = location;
}

- (void)saveLocation:(NSString *)location
{
    [[NSUserDefaults standardUserDefaults] setObject:@{LOCATION:location} forKey:MOTOR_NEW_CLAIM_LOCATION];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getLocation
{
    NSMutableDictionary *locationArray = [[[NSUserDefaults standardUserDefaults] objectForKey:MOTOR_NEW_CLAIM_LOCATION] mutableCopy];
    NSString *location = locationArray[LOCATION];
    
    return location;
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"locationSegue"]) {
        CRLocationViewController *locationVC = (CRLocationViewController *)segue.destinationViewController;
        locationVC.delegate = self;
    }
}


@end
