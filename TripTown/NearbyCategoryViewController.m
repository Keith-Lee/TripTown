//
//  NearbyCategoryViewController.m
//  TripTown
//
//  Created by 李 國揚 on 13/4/21.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import "NearbyCategoryViewController.h"
#import "NearbyResultMapViewController.h"

@interface NearbyCategoryViewController ()

@end

@implementation NearbyCategoryViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //  NSString *categoryID;
    getid = [[NSMutableArray alloc] init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Table view data source

-(IBAction)Artselect:(id)sender{
    if (!artCheck) {
        [self.checkArtBoxButton setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        [getid addObject:@"4d4b7104d754a06370d81259"];
        artCheck = YES;
    }else if (artCheck) {
        [self.checkArtBoxButton setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
        artCheck = NO;
        
        for(int i =0;i<([getid count]);i++){
            if ([[getid objectAtIndex:i]isEqualToString:@"4d4b7104d754a06370d81259"])
            {
                [getid removeObjectAtIndex:i];
                //NSLog(@"REMOVEart");
            }
        }
    }
}
-(IBAction)Collegeselect:(id)sender{
    if (!collegeCheck) {
        [self.checkCoellegeBoxButton setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        [getid addObject:@"4d4b7105d754a06372d81259"];
        collegeCheck = YES;
        
    }else if (collegeCheck) {
        [self.checkCoellegeBoxButton setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
        collegeCheck = NO;
        
        for(int i =0;i<([getid count]);i++){
            if ([[getid objectAtIndex:i]isEqualToString:@"4d4b7105d754a06372d81259"])
            {
                [getid removeObjectAtIndex:i];
                //NSLog(@"REMOVEcollege");
            }
        }
    }
}
-(IBAction)Foodselect:(id)sender{
    if (!foodCheck) {
        [self.checkFoodBoxButton setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        [getid addObject:@"4d4b7105d754a06374d81259"];
        foodCheck = YES;
        
    }else if (foodCheck) {
        [self.checkFoodBoxButton setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
        foodCheck = NO;
        
        for(int i =0;i<([getid count]);i++){
            if ([[getid objectAtIndex:i]isEqualToString:@"4d4b7105d754a06374d81259"])
            {
                [getid removeObjectAtIndex:i];
                //NSLog(@"REMOVEfood");
            }
        }
    }
}
-(IBAction)Nightselect:(id)sender{
    if (!nightCheck) {
        [self.checkNightBoxButton setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        [getid addObject:@"4d4b7105d754a06376d81259"];
        nightCheck = YES;
        
    }else if (nightCheck) {
        [self.checkNightBoxButton setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
        nightCheck = NO;
        
        for(int i =0;i<([getid count]);i++){
            if ([[getid objectAtIndex:i]isEqualToString:@"4d4b7105d754a06376d81259"])
            {
                [getid removeObjectAtIndex:i];
                //NSLog(@"REMOVEnight");
            }
        }
    }
}
-(IBAction)Outdoorsselect:(id)sender{
    if (!outdoorCheck) {
        [self.checkOutdoorBoxButton setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        [getid addObject:@"4d4b7105d754a06377d81259"];
        outdoorCheck = YES;
        
    }else if (outdoorCheck) {
        [self.checkOutdoorBoxButton setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
        outdoorCheck = NO;
        
        for(int i =0;i<([getid count]);i++){
            if ([[getid objectAtIndex:i]isEqualToString:@"4d4b7105d754a06377d81259"])
            {
                [getid removeObjectAtIndex:i];
                //NSLog(@"REMOVEoutdoor");
            }
        }
    }
}
-(IBAction)Professionelect:(id)sender{
    if (!professionCheck) {
        [self.checkProfessionBoxButton setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        [getid addObject:@"4d4b7105d754a06375d81259"];
        professionCheck = YES;
        
    }else if (professionCheck) {
        [self.checkProfessionBoxButton setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
        professionCheck = NO;
        
        for(int i =0;i<([getid count]);i++){
            if ([[getid objectAtIndex:i]isEqualToString:@"4d4b7105d754a06375d81259"])
            {
                [getid removeObjectAtIndex:i];
                //NSLog(@"REMOVEprofession");
            }
        }
    }
}
-(IBAction)Residenceselect:(id)sender{
    if (!ResidenceCheck) {
        [self.checkResidenceBoxButton setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        [getid addObject:@"4e67e38e036454776db1fb3a"];
        ResidenceCheck = YES;
        
    }else if (ResidenceCheck) {
        [self.checkResidenceBoxButton setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
        ResidenceCheck = NO;
        
        for(int i =0;i<([getid count]);i++){
            if ([[getid objectAtIndex:i]isEqualToString:@"4e67e38e036454776db1fb3a"])
            {
                [getid removeObjectAtIndex:i];
                //NSLog(@"REMOVEresidence");
            }
        }
    }
}
-(IBAction)Shopselect:(id)sender{
    if (!shopCheck) {
        [self.checkShopBoxButton setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        [getid addObject:@"4d4b7105d754a06378d81259"];
        shopCheck = YES;
        
    }else if (shopCheck) {
        [self.checkShopBoxButton setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
        shopCheck = NO;
        
        for(int i =0;i<([getid count]);i++){
            if ([[getid objectAtIndex:i]isEqualToString:@"4d4b7105d754a06378d81259"])
            {
                [getid removeObjectAtIndex:i];
                //NSLog(@"REMOVEshop");
            }
        }
    }
}
-(IBAction)Travelselect:(id)sender{
    if (!travelCheck) {
        [self.checkTravelBoxButton setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        [getid addObject:@"4d4b7105d754a06379d81259"];
        travelCheck = YES;
        
    }else if (travelCheck) {
        [self.checkTravelBoxButton setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
        travelCheck = NO;
        
        for(int i =0;i<([getid count]);i++){
            if ([[getid objectAtIndex:i]isEqualToString:@"4d4b7105d754a06379d81259"])
            {
                [getid removeObjectAtIndex:i];
                //NSLog(@"REMOVEtravel");
            }
        }
    }
}
/*
 -(IBAction)show{
 NSLog(@"%d",getid.count);
 for(int i =0;i<([getid count]);i++){
 
 NSLog(@"%d=%@",i,[getid objectAtIndex:i]);
 }
 
 }
 */
#pragma mark - Table view delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NearbyResultMapViewController *category=segue.destinationViewController;
    //NSString *sentence = [getid componentsJoinedByString:@","];
    category.categoryId=[getid componentsJoinedByString:@","];
    category.categoryName=@"Nearby";
    // category.result=reback;
}
- (IBAction)barBtn_back_pressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
