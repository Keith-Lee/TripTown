//
//  RegisterViewController.m
//  TripTown
//
//  Created by 李 國揚 on 13/4/21.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController
@synthesize nameField,emailField,passwordField;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)registerDone:(id)sender {
    NSLog(@"Your Name is %@, email is %@, password is %@",nameField.text,emailField.text,passwordField.text);
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
