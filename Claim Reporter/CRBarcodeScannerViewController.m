//
//  CRBarcodeScannerViewController.m
//  Claim Reporter
//
//  Created by Seema on 25/04/14.
//  Copyright (c) 2014 iDoodle. All rights reserved.
//

#import "CRBarcodeScannerViewController.h"
@import AVFoundation;

@interface CRBarcodeScannerViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) AVCaptureSession *session;

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
    // Do any additional setup after loading the view.
    [self scan];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scan
{
    self.session = [[AVCaptureSession alloc] init];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if (input) {
        [self.session addInput:input];
    } else {
        NSLog(@"Error: %@", error);
    }
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [self.session addOutput:output];
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    previewLayer.frame = self.view.layer.bounds;
    [self.view.layer addSublayer:previewLayer];
    
    
    [self.session startRunning];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *QRCode = nil;
    for (AVMetadataObject *metadata in metadataObjects) {
        if ([metadata.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            QRCode = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
            break;
        }
    }

    [self.session stopRunning];

    if (!QRCode) {
        NSLog(@"Unable to scan QR code");
    }
    else
    {
        NSLog(@"QR Code: %@", QRCode);
        [self parseQRCode:QRCode];
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
