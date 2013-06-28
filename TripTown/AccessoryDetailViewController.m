//
//  AccessoryDetailViewController.m
//  TripTown
//
//  Created by 李 國揚 on 13/5/11.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import "AccessoryDetailViewController.h"

@interface AccessoryDetailViewController (){
    NSInteger theSerialNumberOfthePhotoToPass;
}

@end

@implementation AccessoryDetailViewController

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
    //設定按鈕樣式
    UIImage *barButtonImage = [[UIImage imageNamed:@"backBtn_G.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 6)];
    [self.backBtnOutlet setBackgroundImage:barButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //back鈕文字offset
    [self.backBtnOutlet setTitlePositionAdjustment:UIOffsetMake(4, 2) forBarMetrics:UIBarMetricsDefault];

	// Do any additional setup after loading the view.
    da = [DataAccess sharedDataSource];
    
    photoImageArray = [da getAllPhotoImageFromLocation:da.theLocation inTrip:da.theTrip];
    photoArray = [da getAllPhotoFromLocation:da.theLocation inTrip:da.theTrip];
    //NSLog(@"address is %@", self.addressTitle);
    self.navigationItem.title = self.addressTitle;
    
    //NSLog(@"theTrip is %@, theLocation is %@", [da.theTrip description], [da.theLocation description]);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [photoArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString * const identifier = @"accessoryCollectionCell";
    AccessoryDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UIImage *image = (UIImage *)[photoImageArray objectAtIndex:indexPath.row];
    PHOTO *photo = (PHOTO *)[photoArray objectAtIndex:indexPath.row];
    
    cell.photoImageView.image = image;
    cell.photoDateLabel.text = photo.p_description;
    //cell.tag = indexPath.row;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    theSerialNumberOfthePhotoToPass = indexPath.row;
    [self performSegueWithIdentifier:@"toImageScrollViewSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"toImageScrollViewSegue"]){
        ImageScrollViewController *vc =[segue destinationViewController];
        vc.thePageOfView = theSerialNumberOfthePhotoToPass;
        vc.pageImages = photoImageArray;
    }
}
- (IBAction)barBtn_back_pressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
