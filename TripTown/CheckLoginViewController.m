//
//  CheckLoginViewController.m
//  TripTown
//
//  Created by user on 13/5/24.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import "CheckLoginViewController.h"

@interface CheckLoginViewController ()

@end

@implementation CheckLoginViewController

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
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"TripTown.png"]];
    self.view.backgroundColor = background;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
