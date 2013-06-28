//
//  LogInViewController.m
//  TripTown
//
//  Created by 李 國揚 on 13/4/21.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import "LogInViewController.h"
#import "ProjectAppDelegate.h"
#import "MainViewController.h"
#import <RestKit/CoreData.h>
#import <Foundation/Foundation.h>
@interface LogInViewController ()
@end

@implementation LogInViewController
@synthesize spinner,passwordField,nameField,gotkey,gotname;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)performLogin:(id)sender
{
    NSLog(@"Logged in to account %@ with password %@",nameField.text,passwordField.text);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)performFBLogin:(id)sender {
    
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
    ProjectAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate openSession];
    NSString * token = [FBSession activeSession].accessTokenData.accessToken;
    NSLog(@"LoginView token:%@",token);
    
    
}
- (void)loginFailed
{
    // User switched back to the app without authorizing. Stay here, but
    // stop the spinner.
    [self.spinner stopAnimating];
    self.spinner.hidden = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //設定背景圖
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"LoginBG.png"]];
    self.view.backgroundColor = background;
    
    self.spinner.hidden = YES;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)postTokenwithRK{
    
    NSString * token = [FBSession activeSession].accessTokenData.accessToken;
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{ @"api_key": @"api_key",@"username":@"username"}];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:requestMapping pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://140.119.19.20:8000/fb/mobile_connect/?access_token=%@",token]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        //RKLogInfo(@"Load collection of Articles: %@", mappingResult.array);
        [[NSUserDefaults standardUserDefaults] setObject:[[mappingResult array] valueForKey:@"username"] forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setObject:[[mappingResult array] valueForKey:@"api_key"] forKey:@"api_key"];
        NSLog(@"name is %@, api_key is %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"username"],[[NSUserDefaults standardUserDefaults] valueForKey:@"api_key"]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Operation failed with error: %@", error);
    }];
    
    [objectRequestOperation start];
}
@end
