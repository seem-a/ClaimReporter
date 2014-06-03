//
//  Photo.h
//  Claim Reporter
//
//  Created by Seema on 25/05/14.
//  Copyright (c) 2014 iDoodle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * claimID;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * imageFilePath;

@end
