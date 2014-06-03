//
//  CRPhotoDetailViewController.m
//  Claim Reporter
//
//  Created by Seema on 20/05/14.
//  Copyright (c) 2014 iDoodle. All rights reserved.
//

#import "CRPhotoDetailViewController.h"
#import "Photo.h"
#import "CRImageFileManager.h"

@interface CRPhotoDetailViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation CRPhotoDetailViewController

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.imageView.image = [CRImageFileManager getImage:self.photo.imageFilePath];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark IBActions

- (IBAction)deleteBarButtonItemPressed:(UIBarButtonItem *)sender
{
    [[self.photo managedObjectContext] deleteObject:self.photo];
//    NSError *error = nil;
//    [[self.photo managedObjectContext] save:&error];
//    if (error) NSLog(@"Error: %@", error);
    
    [self.navigationController popViewControllerAnimated:YES];
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

@end
