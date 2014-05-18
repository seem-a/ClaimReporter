//
//  CRDocumentGenerator.m
//  Claim Reporter
//
//  Created by Seema on 26/04/14.
//  Copyright (c) 2014 iDoodle. All rights reserved.
//

#import "CRDocumentGenerator.h"

@implementation CRDocumentGenerator

-(void)initContent{
    self.imageArray = [[NSMutableArray alloc]init];
    self.imageRectArray = [[NSMutableArray alloc]init];
    
    self.textArray = [[NSMutableArray alloc]init];
    self.textRectArray = [[NSMutableArray alloc]init];
    
    self.header = [[NSMutableArray alloc]init];
    self.headerRect = [[NSMutableArray alloc]init];
    
    self.data = [NSMutableData data];
    
}
- (void) drawHeader
{
    for (int i = 0; i < [self.header count]; i++) {
        
        
        CGContextRef    currentContext = UIGraphicsGetCurrentContext();
        CGContextSetRGBFillColor(currentContext, 0.0, 0.0, 0.0, 1.0);
        
        NSString *textToDraw = [self.header objectAtIndex:i];
        
        
        NSLog(@"Text to draw: %@", textToDraw);
        CGRect renderingRect = [[self.headerRect objectAtIndex:i]CGRectValue];
        NSLog(@"x of rect is %f",  renderingRect.origin.x);
        
        
        UIFont*font = [UIFont fontWithName:@"HelveticaNeue-Light" size:30.0];
        
        UIColor*color = [UIColor colorWithRed:255/255.0 green:79/255.0 blue:79/255.0 alpha:1.0];
        NSDictionary*att = @{NSFontAttributeName: font, NSForegroundColorAttributeName:color};
        NSStringDrawingContext *context = [NSStringDrawingContext new];
        context.minimumScaleFactor = 0.1;
        //        [textToDraw drawInRect:renderingRect withAttributes:att];
        [textToDraw drawWithRect:renderingRect options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:context];
    }
    
}
-(void)drawImage{
    for (int i = 0; i < [self.imageArray count]; i++) {
        [[self.imageArray objectAtIndex:i] drawInRect:[[self.imageRectArray objectAtIndex:i]CGRectValue]];
        
    }
}
- (void) drawText
{
    for (int i = 0; i < [self.textArray count]; i++) {
        
        
        CGContextRef    currentContext = UIGraphicsGetCurrentContext();
        CGContextSetRGBFillColor(currentContext, 0.0, 0.0, 0.0, 1.0);
        
        NSString *textToDraw = [self.textArray objectAtIndex:i];
        
        
        NSLog(@"Text to draw: %@", textToDraw);
        CGRect renderingRect = [[self.textRectArray objectAtIndex:i]CGRectValue];
        NSLog(@"x of rect is %f",  renderingRect.origin.x);
        
        
        UIFont*font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0];
        
        UIColor*color = [UIColor blackColor];
        NSDictionary*att = @{NSFontAttributeName: font, NSForegroundColorAttributeName:color};
        
        
        [textToDraw drawWithRect:renderingRect options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:nil];
    }
    
}
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
-(void)addImageWithRect:(UIImage *)image inRect:(CGRect)rect{
    UIImage *newImage = [CRDocumentGenerator imageWithImage:image scaledToSize:CGSizeMake(rect.size.width, rect.size.height)];
    
    
    [self.imageArray addObject:newImage];
    [self.imageRectArray addObject:[NSValue valueWithCGRect:rect]];
}
-(void)addTextWithRect:(NSString *)text inRect:(CGRect)rect{
    [self.textArray addObject:text];
    [self.textRectArray addObject:[NSValue valueWithCGRect:rect]];
}
-(void)addHeadertWithRect:(NSString *)text inRect:(CGRect)rect{
    [self.header addObject:text];
    [self.headerRect addObject:[NSValue valueWithCGRect:rect]];
}

- (NSMutableData*) generatePdfWithFilePath: (NSString *)thefilePath
{
    
    UIGraphicsBeginPDFContextToFile(thefilePath, CGRectZero, nil);
    
    
    BOOL done = NO;
    do
    {
        //Start a new page.
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, self.size.width, self.size.height), nil);
        
        //Draw Header
        [self drawHeader];
        //Draw Text
        [self drawText];
        //Draw an image
        [self drawImage];
        
        done = YES;
    }
    while (!done);
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
    
    
    //For data
    UIGraphicsBeginPDFContextToData(self.data, CGRectZero, nil);
    
    
    BOOL done1 = NO;
    do
    {
        //Start a new page.
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, self.size.width, self.size.height), nil);
        
        //Draw Header
        [self drawHeader];
        //Draw Text
        [self drawText];
        //Draw an image
        [self drawImage];
        
        done1 = YES;
    } 
    while (!done1);
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
    return self.data;
}


-(void)CreaPDFconPath:(NSString*)pdfFilePath
{
    
    
    UIFont*font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0];
    
    UIColor*color = [UIColor blackColor];
    NSDictionary*att = @{NSFontAttributeName: font, NSForegroundColorAttributeName:color};
    
    NSString* text = [NSString stringWithFormat:@"%@ \n\n%@", @"self.ingredienti.text", @"self.preparazione.text"];
    
    CGFloat stringSize = [text boundingRectWithSize:CGSizeMake(980, CGFLOAT_MAX)// use CGFLOAT_MAX to dinamically calculate the height of a string
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:att context:nil].size.height;
    
    //creo pdf e vi aggiungo testo e immagini
    CRDocumentGenerator *pdfFile = [[CRDocumentGenerator alloc]init];
    [pdfFile initContent];
    [pdfFile setSize:CGSizeMake(1000, 400+ stringSize)];
    
    [pdfFile addHeadertWithRect:@"self.fieldNome.text" inRect:CGRectMake(10, 10, 980, 60)];
    
    [pdfFile addImageWithRect:[UIImage imageNamed:@"self.image.image"] inRect:CGRectMake(10, 80, 250, 250)];
    
    NSString*stringInfo = [NSString stringWithFormat:@"%@:%@ \n\n%@", @"self.oreCottura.text" , @"self.minutiDiCottura.text", @"self.numeroPersone.text"];
    [pdfFile addHeadertWithRect:stringInfo inRect:CGRectMake(300, 190, 500, 120)];
    
    [pdfFile addTextWithRect:text inRect:CGRectMake(10, 350, 980, CGFLOAT_MAX)];
    
    [pdfFile drawHeader];
    [pdfFile drawImage];
    [pdfFile drawText];

    [pdfFile generatePdfWithFilePath:pdfFilePath];
}

@end
