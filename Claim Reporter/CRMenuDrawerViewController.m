//
//  CRMenuDrawerViewController.m
//  Claim Reporter
//
//  Created by Seema on 18/04/14.
//  Copyright (c) 2014 iDoodle. All rights reserved.
//

#import "CRMenuDrawerViewController.h"
#import "CRMenuViewController.h"

@interface CRMenuDrawerViewController ()

@property (nonatomic, weak) CRMenuViewController *menuViewController;

@end

@implementation CRMenuDrawerViewController


- (void) setContent:(UIViewController *)content
{
    if(_content)
    {
        [_content.view removeFromSuperview];
        [_content removeFromParentViewController];
        
        content.view.frame = _content.view.frame;
    }
    _content = content;
    [self addChildViewController:_content];
    [_content didMoveToParentViewController:self];
    [self.view addSubview:_content.view];
    
    [self closeDrawer];
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
    [self.menuViewController performSegueWithIdentifier:@"displayText" sender:self.menuViewController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slideDrawer:) name:@"notifyButtonPressed" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)slideDrawer:(id)sender
{
    if(self.content.view.frame.origin.x > 0)
    {
        [self closeDrawer];
    }
    else
    {
        [self openDrawer];
    }
}
-(void)openDrawer
{
    CGRect fm = self.content.view.frame;
    fm.origin.x = 240.0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.content.view.frame = fm;
    }];
}

-(void)closeDrawer
{
    CGRect fm = self.content.view.frame;
    fm.origin.x = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.content.view.frame = fm;
    }];
}





#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"embedMenu"]) {
        CRMenuViewController *menuViewController = segue.destinationViewController;
        menuViewController.menuDrawerViewController = self;
        self.menuViewController = menuViewController;
    }
}


@end
