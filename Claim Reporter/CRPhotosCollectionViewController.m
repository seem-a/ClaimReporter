//
//  CRPhotosCollectionViewController.m
//  Claim Reporter
//
//  Created by Seema on 15/05/14.
//  Copyright (c) 2014 iDoodle. All rights reserved.
//

#import "CRPhotosCollectionViewController.h"
#import "CRPhotoCollectionViewCell.h"
#import "Photo.h"
#import "CRCoreDataHelper.h"
#import "CRPhotoDetailViewController.h"
#import "CRImageFileManager.h"

@interface CRPhotosCollectionViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSMutableArray *photos;

@end

@implementation CRPhotosCollectionViewController

- (NSMutableArray *)photos
{
    if (!_photos) {
        _photos = [[NSMutableArray alloc] init];
    }
    return _photos;
}


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
    self.collectionView.allowsMultipleSelection = YES;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"claimID = %@", self.claimID]];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    
    NSError *error = nil;
    NSArray *photos = [[CRCoreDataHelper managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    self.photos = [photos mutableCopy];
    [self.collectionView reloadData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.collectionView reloadData];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    NSError *error = nil;
    if (![[CRCoreDataHelper managedObjectContext] save:&error])
    {
        NSLog(@"Error while saving photo: %@", error);
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark IBActions

- (IBAction)cameraBarButtonItemPressed:(UIBarButtonItem *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    
    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toPhotoDetail"])
    {
        if ([segue.destinationViewController isKindOfClass:[CRPhotoDetailViewController class]]) {
            CRPhotoDetailViewController *photoDetailVC = (CRPhotoDetailViewController *)segue.destinationViewController;
            
            NSIndexPath *path = [[self.collectionView indexPathsForSelectedItems] lastObject];
            Photo *selectedPhoto = self.photos[path.row];
            photoDetailVC.photo = selectedPhoto;
        }
    }
}


#pragma mark - Helper Methods

- (Photo *)photoFromImage:(UIImage *)image
{
    NSString *imageFileName = [NSString stringWithFormat:@"%@-%lu.png", self.claimID, (unsigned long)[self.photos count]+1];
    NSString *imageFilePath = [CRImageFileManager saveImage:image withFileName:imageFileName];
    
    NSManagedObjectContext *context = [CRCoreDataHelper managedObjectContext];
    Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
    photo.imageFilePath = imageFilePath;
    photo.date = [NSDate date];
    photo.claimID = self.claimID;
    
//    NSError *error = nil;
//    
//    if (![[photo managedObjectContext] save:&error]) {
//        NSLog(@"Error while saving photo: %@", error);
//    }
    return photo;
}

#pragma mark - UICollectionViewDelegate

//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"ROW: %ld, SECTION: %ld", (long)indexPath.row, (long)indexPath.section);
//}

#pragma mark - UICollectionViewDataSource

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Photo Cell";
    
    CRPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    Photo *photo = self.photos[indexPath.row];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.imageView.image = [CRImageFileManager getImage:photo.imageFilePath];
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photos count];
}


#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image) image = info[UIImagePickerControllerOriginalImage];

    [self.photos addObject:[self photoFromImage:image]];
    
    [self.collectionView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
