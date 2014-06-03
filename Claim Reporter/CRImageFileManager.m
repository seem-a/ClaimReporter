//
//  CRImageFileManager.m
//  Claim Reporter
//
//  Created by Seema on 25/05/14.
//  Copyright (c) 2014 iDoodle. All rights reserved.
//

#import "CRImageFileManager.h"

@implementation CRImageFileManager

+ (NSString *)saveImage:(UIImage *)image withFileName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths firstObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];

    NSData *pngData = UIImagePNGRepresentation(image);
    [pngData writeToFile:filePath atomically:YES];
    
    return filePath;
}
+ (UIImage *)getImage:(NSString *)filePath
{
    NSData *pngData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [UIImage imageWithData:pngData];
    
    return image;
}
+ (void)deleteImage:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    
    if (![fileManager removeItemAtPath:filePath error:&error]) {
        NSLog(@"[Error] %@ (%@)", error, filePath);
    }
}



@end
