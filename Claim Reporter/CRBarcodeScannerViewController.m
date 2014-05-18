//
//  CRBarcodeScannerViewController.m
//  Claim Reporter
//
//  Created by Seema on 25/04/14.
//  Copyright (c) 2014 iDoodle. All rights reserved.
//

#import "CRBarcodeScannerViewController.h"
@import AVFoundation;

@interface CRBarcodeScannerViewController () <AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) NSString *QRCode;

@end

@implementation CRBarcodeScannerViewController

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
    [self scan];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scan
{
    self.captureSession = [[AVCaptureSession alloc] init];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if (input) {
        [self.captureSession addInput:input];
    } else {
        NSLog(@"Error: %@", error);
    }
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [self.captureSession addOutput:output];
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    previewLayer.frame = self.view.layer.bounds;
    [self.view.layer addSublayer:previewLayer];
    
    [self.captureSession startRunning];
    
    [self performSelector:@selector(QRCodeNotFound) withObject:nil afterDelay:3.0];
}

- (void) QRCodeNotFound
{
    [self.captureSession stopRunning];
    
    if (!self.QRCode) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"QR Code Not Found" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}


#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
   
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    self.QRCode = nil;
    for (AVMetadataObject *metadata in metadataObjects) {
        if ([metadata.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            self.QRCode = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
            break;
        }
    }

    [self.captureSession stopRunning];

    if (!self.QRCode) {
        NSLog(@"Unable to scan QR code");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"QR Code could not be scanned" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        NSLog(@"QR Code: %@", self.QRCode);
        [self parseQRCode:self.QRCode];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) parseQRCode:(NSString *)QRCode
{
    NSString *customerName, *customerID, *dateString;
    NSArray *substrings = [QRCode componentsSeparatedByString:@"|"];
    customerName = substrings[0];
    customerID = substrings[1];
    dateString = substrings[2];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"ddMMyyyy"];
    NSDate *dateOfBirth = [dateFormat dateFromString:dateString];
    
    [self.delegate processScannedLogin:customerName customerID:customerID dateOfBirth:dateOfBirth];
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
