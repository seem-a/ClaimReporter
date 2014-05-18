//
//  CRAnnotationView.m
//  Claim Reporter
//
//  Created by Seema on 4/05/14.
//  Copyright (c) 2014 iDoodle. All rights reserved.
//

#import "CRAnnotationView.h"

@implementation CRAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"cars-25.png"];
        self.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        self.centerOffset = CGPointMake(0, -20.0);
        self.opaque = NO;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed:@"cars-25.png"];
    [image drawInRect:CGRectInset(self.bounds, 5, 5)];
}


@end
