//
//  CRLocationViewController.m
//  Claim Reporter
//
//  Created by Seema on 26/04/14.
//  Copyright (c) 2014 iDoodle. All rights reserved.
//

#import "CRLocationViewController.h"
#import "CRAddressViewController.h"
@import CoreLocation;
@import MapKit;
@import AddressBookUI;


@interface CRLocationViewController () <CLLocationManagerDelegate, MKMapViewDelegate, CRAddressViewControllerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) IBOutlet UIView *addressContainerView;

@property (strong, nonatomic) NSString *address;
@end

@implementation CRLocationViewController
{
    CLLocationManager *locationManager;
    CLGeocoder *geoCoder;
    CLLocation *location;
    NSArray *addressLines;
//    CGFloat keyboardHeight;
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
    self.address = nil;
    self.addressContainerView.hidden = true;
    
//    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//    [center addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardDidShowNotification object:nil];
    
    locationManager = [[CLLocationManager alloc] init];
    geoCoder = [[CLGeocoder alloc] init];

    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    self.map.delegate = self;
    
    [locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (void)keyboardOnScreen:(NSNotification *)notification
//{
//    NSDictionary *info  = notification.userInfo;
//    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
//    
//    CGRect rawFrame      = [value CGRectValue];
//    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
//    
//    NSLog(@"keyboardFrame: %@", NSStringFromCGRect(keyboardFrame));
//}

#pragma mark CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alertView show];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    location = [locations lastObject];
    
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks lastObject]; // TODO seems to return a previous, rather than current, location
        
//        self.address = [NSString stringWithFormat:@"%@", ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO)];
        
        addressLines = placemark.addressDictionary[ @"FormattedAddressLines"];
        
        NSString *street = [[placemark addressDictionary] objectForKey:(NSString *)kABPersonAddressStreetKey];
        NSString *city = [[placemark addressDictionary] objectForKey:(NSString *)kABPersonAddressCityKey];
        NSString *state = [[placemark addressDictionary] objectForKey:(NSString *)kABPersonAddressStateKey];
        NSString *country = [[placemark addressDictionary] objectForKey:(NSString *)kABPersonAddressCountryKey];
        NSString *zip = [[placemark addressDictionary] objectForKey:(NSString *)kABPersonAddressZIPKey];
        self.address = [NSString stringWithFormat:@"%@\n%@\n%@ %@\n%@", street, city, zip, state, country];
    }];
    
    if (self.address) {
        [locationManager  stopUpdatingLocation];
        
        
        MKPointAnnotation* ann = [MKPointAnnotation new];
        ann.coordinate = location.coordinate;
        ann.title = addressLines[0];
        ann.subtitle = [NSString stringWithFormat:@"%@, %@", addressLines[1], addressLines[2]];
        [self.map addAnnotation:ann];
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 1200, 1200);
        self.map.region = region;
        
        [self presentAddressViewController];

    }
    
    NSLog(@"%@", self.address);
}

#pragma mark Helpers to present child view controller

- (void) presentAddressViewController
{
    static NSString *viewControllerIdentifier = @"AddressViewController";
    CRAddressViewController *addressVC = (CRAddressViewController *)[self.storyboard instantiateViewControllerWithIdentifier:viewControllerIdentifier];
    addressVC.delegate = self;
    addressVC.street = addressLines[0];
    addressVC.suburb = addressLines[1];
    addressVC.city = addressLines[2];
    
    [self addChildViewController:addressVC];
    [self.addressContainerView addSubview:addressVC.view];
    [addressVC didMoveToParentViewController:self];
    
    self.addressContainerView.hidden = false;
}

#pragma mark MKMapViewDelegate

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *annotationView = nil;
    if ([annotation.title isEqualToString:@"You are here!"]) {
        static NSString *ident = @"greenPin";
        annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:ident];
        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ident];
            ((MKPinAnnotationView *)annotationView).pinColor = MKPinAnnotationColorPurple;
            ((MKPinAnnotationView *)annotationView).animatesDrop = YES;
            annotationView.canShowCallout = YES;
        }
        annotationView.annotation = annotation;
    }
    return annotationView;
}

#pragma mark CRAddressViewControllerDelegate

-(void)returnAddress:(NSString *)street suburb:(NSString *)suburb city:(NSString *)city
{
    [self.delegate returnAddress:street suburb:suburb city:city];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"embedAddressView"]) {
        return NO;
    }
    return YES;
}



# pragma mark keyboards animations

#define kOFFSET_FOR_KEYBOARD 216.0

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.addressContainerView.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    //move the main view, so that the keyboard does not hide it.
    if  (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;    
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}






@end
