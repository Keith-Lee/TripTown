//
//  AlbumCollectionViewController.m
//  TripTown
//
//  Created by 李 國揚 on 13/5/15.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import "AlbumCollectionViewController.h"
#import "ECSlidingViewController.h"

@interface AlbumCollectionViewController (){
    NSArray *photoArray;
    NSArray *imageArray;
    NSMutableArray *sortedImageArray;
    NSMutableArray *sortedPhotoArray;
    NSArray *regionArray;
    NSMutableArray *locationCategorizedArray;
    NSMutableArray *dateCategorizedArray;
    NSMutableArray *locationCategorizedPhotoArray;
    NSMutableArray *dateCategorizedPhotoArray;
    BOOL isUsingLocationSorting;
    BOOL isUsingDateSorting;
    
    NSArray *dateArray;
    
}

@end

@implementation AlbumCollectionViewController

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
    
    if(self.segmentControll_sortingMethod.selectedSegmentIndex == 0){
        isUsingLocationSorting = YES;
        isUsingDateSorting = NO;
    }
    
    [self.segmentedControlOutlet setTitleTextAttributes:@{
                                    UITextAttributeFont: [UIFont fontWithName:@"BebasNeue" size:20.0f]} forState:UIControlStateNormal];
    

	// Do any additional setup after loading the view.
    //NSLog(@"image array is %@",[imageArray description]);

    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self.albumCollectionView reloadData];
    
    [self.activityIndicator startAnimating];


}

- (void)viewDidAppear:(BOOL)animated{
    DataAccess *da = [DataAccess sharedDataSource];
    imageArray = [da getAllPhotoImageForTrip:da.theTrip];
    photoArray = [da getAllPhotoForTrip:da.theTrip];
    regionArray = [da getAllRegionInTrip:da.theTrip];
    locationCategorizedArray = [NSMutableArray array];
    dateCategorizedArray = [NSMutableArray array];
    locationCategorizedPhotoArray = [NSMutableArray array];
    dateCategorizedPhotoArray = [NSMutableArray array];
    
    NSMutableSet *dateSet = [NSMutableSet set];
    for(PHOTO *photo in photoArray){
        NSDate *currentDate = photo.p_date;
        unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:flags fromDate:currentDate];
        //Taking the time zone into account
        NSDate *dateOnly = [[calendar dateFromComponents:components] dateByAddingTimeInterval:[[NSTimeZone localTimeZone]secondsFromGMT]];
        
        [dateSet addObject:dateOnly];
    }
    
    dateArray = [[dateSet allObjects] sortedArrayUsingComparator:
                 ^NSComparisonResult(id obj1, id obj2) {
                     return [obj1 compare:obj2];
                 }];
    
    [self.albumCollectionView reloadData];
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    
    NSLog(@"dateArray is: %@", [dateArray description]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if(isUsingLocationSorting)
        return [regionArray count];
    else
        return [dateArray count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    AlbumPhotoHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"albumPhotoHeaderView" forIndexPath:indexPath];
    if(isUsingLocationSorting) {
        REGION *currentRegion = [regionArray objectAtIndex:indexPath.section];
        headerView.headerLabel.text = currentRegion.r_name;
    }
    else{
        NSDate *currentDate = [dateArray objectAtIndex:indexPath.section];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:currentDate];
        NSString *dateString = [NSString stringWithFormat:@"%i/%i/%i", components.year, components.month, components.day];
        
        headerView.headerLabel.text = dateString;
    }
    
    return headerView;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(isUsingLocationSorting) {
        REGION *currentRegion = [regionArray objectAtIndex:section];
        NSMutableArray *currentPhotoImageArray = [NSMutableArray array];
        NSMutableArray *currentPhotoArray = [NSMutableArray array];
        for( PHOTO *photo in photoArray){
            if([photo.location.region.r_name isEqualToString:currentRegion.r_name]){
                NSURL *url = [NSURL URLWithString:photo.p_image];
                UIImage *image = [[DataAccess sharedDataSource]tranferURLtoImage:url];
                [currentPhotoImageArray addObject:image];
                [currentPhotoArray addObject:photo];
            }
        }
    
        [locationCategorizedArray addObject:currentPhotoImageArray];
        [locationCategorizedPhotoArray addObject:currentPhotoArray];
        return [currentPhotoImageArray count];
    }
    
    else{
        NSMutableArray *currentPhotoImageArray = [NSMutableArray array];
        NSMutableArray *currentPhotoArray = [NSMutableArray array];
        NSDate *theDate = [dateArray objectAtIndex:section];
        for(PHOTO *photo in photoArray){
            NSDate *currentDate = photo.p_date;
            unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
            NSCalendar* calendar = [NSCalendar currentCalendar];
            NSDateComponents* components = [calendar components:flags fromDate:currentDate];
            //Taking the time zone into account
            NSDate *dateOnly = [[calendar dateFromComponents:components] dateByAddingTimeInterval:[[NSTimeZone localTimeZone]secondsFromGMT]];
            if([dateOnly compare:theDate] == NSOrderedSame){
                NSURL *url = [NSURL URLWithString:photo.p_image];
                UIImage *image = [[DataAccess sharedDataSource]tranferURLtoImage:url];
                [currentPhotoImageArray addObject:image];
                [currentPhotoArray addObject:photo];
                
            }
        }
        [dateCategorizedArray addObject:currentPhotoImageArray];
        [dateCategorizedPhotoArray addObject:currentPhotoArray];
        return [currentPhotoImageArray count];
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString * const identifier = @"albumCell";
    AlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UIImage *image = nil;
    if(isUsingLocationSorting) {
        image = [[locationCategorizedArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    else{
        image = [[dateCategorizedArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }

    cell.imageView.image = image;

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = 0;
    NSInteger theSection = indexPath.section;
    for (NSInteger i = 0; i < theSection; i++) {
        index += [collectionView numberOfItemsInSection:i];
    }
    index += indexPath.row;
    //NSLog(@"index is %i", index);
    [self performSegueWithIdentifier:@"albumToScrollSegue" sender:[NSString stringWithFormat:@"%i", index]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSInteger number = [(NSString *)sender intValue];
    if([[segue identifier] isEqualToString:@"albumToScrollSegue"]){
        AlbumScrollViewController *vc = [segue destinationViewController];
        vc.thePageOfView = number;
        sortedImageArray = [NSMutableArray array];
        sortedPhotoArray = [NSMutableArray array];
        if(isUsingDateSorting){
            for(int i = 0; i < [dateCategorizedArray count]; i++){
                for(int j = 0; j < [[dateCategorizedArray objectAtIndex:i] count]; j++){
                    [sortedImageArray addObject:(UIImage *)[[dateCategorizedArray objectAtIndex:i]objectAtIndex:j]];
                    [sortedPhotoArray addObject:(PHOTO *)[[dateCategorizedPhotoArray objectAtIndex:i]objectAtIndex:j]];
                }
            }
            
        }
        else{
            for(int i = 0; i < [locationCategorizedArray count]; i++){
                for(int j = 0; j < [[locationCategorizedArray objectAtIndex:i] count]; j++){
                    [sortedImageArray addObject:(UIImage *)[[locationCategorizedArray objectAtIndex:i]objectAtIndex:j]];
                    [sortedPhotoArray addObject:(PHOTO *)[[locationCategorizedPhotoArray objectAtIndex:i]objectAtIndex:j]];
                }
            }
            
        }

        vc.pageImages = (NSArray *)sortedImageArray;
        vc.categorizedPhotoArray = (NSArray *)sortedPhotoArray;
    }
}

- (IBAction)barBtn_back_pressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)segment_sortingMethodChanged:(id)sender {
    if(isUsingLocationSorting == YES && isUsingDateSorting == NO){
        isUsingLocationSorting = NO;
        isUsingDateSorting = YES;
        [self.albumCollectionView reloadData];
    }
    else{
        isUsingDateSorting = NO;
        isUsingLocationSorting = YES;
        [self.albumCollectionView reloadData];
    }
    
}
@end
