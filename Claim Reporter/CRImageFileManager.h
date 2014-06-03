//
//  CRImageFileManager.h
//  Claim Reporter
//
//  Created by Seema on 25/05/14.
//  Copyright (c) 2014 iDoodle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRImageFileManager : NSObject

+ (NSString *)saveImage:(UIImage *)image withFileName:(NSString *)fileName;
+ (UIImage *)getImage:(NSString *)filePath;
+ (void)deleteImage:(NSString *)filePath;

@end
