//
//  AlbumScrollViewController.m
//  TripTown
//
//  Created by 李 國揚 on 13/5/15.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import "AlbumScrollViewController.h"

@interface AlbumScrollViewController (){
    //NSInteger theIndexOfImage;
    NSArray *photoArray;
    DataAccess *da;
}

@end

@implementation AlbumScrollViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadPage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what you have to display, then do nothing
        return;
    }
    
    // 1
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        // 2
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        
        // 3
        UIImageView *newPageView = [[UIImageView alloc] initWithImage:[self.pageImages objectAtIndex:page]];
        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        //newPageView.translatesAutoresizingMaskIntoConstraints = NO;
        newPageView.frame = frame;
        [self.scrollView addSubview:newPageView];
        // 4
        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
    }
}

- (void)purgePage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what you have to display, then do nothing
        return;
    }
    
    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}



- (void)loadVisiblePages {
    // First, determine which page is currently visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    //NSLog(@"%f, %f",self.scrollView.contentOffset.x, self.scrollView.contentOffset.y);
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    //theIndexOfImage = page;
    self.thePageOfView = page;
    //NSLog(@"the index of image is %i", theIndexOfImage);
    NSLog(@"self.thePageOfView is %i",self.thePageOfView);
    
    // Update the page control
    //self.pageControl.currentPage = page;
    
    // Work out which pages you want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
    }
    
	// Load pages in our range
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
    
	// Purge anything after the last page
    for (NSInteger i=lastPage+1; i<self.pageImages.count; i++) {
        [self purgePage:i];
    }
    
    PHOTO *photo = [photoArray objectAtIndex:page];
    self.desciptionLabel.text = photo.p_description;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages that are now on screen
    [self loadVisiblePages];
}


- (IBAction)barBtn_delete_pressed:(id)sender {
    UIActionSheet *deleteActionSheet = [[UIActionSheet alloc]initWithTitle:@"Delete" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil, nil];
    
    deleteActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    [deleteActionSheet showInView:self.view];
    
}



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        //Delete button
        PHOTO *photoToDelete = (PHOTO *)[[da getAllPhotoForTrip:da.theTrip] objectAtIndex:self.thePageOfView];
        if([photoToDelete.location.photo count] == 1 && [photoToDelete.location.region.location count] == 1){
            [da deleteDataModelObject:photoToDelete.location.region];
        }
        
        else if([photoToDelete.location.photo count] == 1 && [photoToDelete.location.region.location count] > 1){
            [da deleteDataModelObject:photoToDelete.location];
        }
        else{
            [da deleteDataModelObject:photoToDelete];
        }
        
        
        NSMutableArray *mutableImagesArray = [NSMutableArray arrayWithArray:self.pageImages];
        [mutableImagesArray removeObjectAtIndex:self.thePageOfView];
        [self.pageViews removeObjectAtIndex:self.thePageOfView];
        self.pageImages = (NSArray *)mutableImagesArray;
        NSLog(@"pageImages: %@",[self.pageImages description]);
        NSLog(@"pageViews: %@",[self.pageViews description]);
        
        //如果是在最後一張相片要往前挪，不是的話就不做改變，相片會往後移一張。
        // 1
        NSInteger pageCount = self.pageImages.count;
        
        // 2
        //self.pageControl.currentPage = 1;
        //self.pageControl.numberOfPages = pageCount;
        
        // 3
        for (UIView *view in [self.scrollView subviews]) {
            [view removeFromSuperview];
        }
        
     
        for (NSInteger i = 0; i < pageCount; ++i) {
            [self.pageViews replaceObjectAtIndex:i withObject:[NSNull null]];
        }
        
        NSLog(@"pageViews: %i",[self.pageViews count]);
        
        [self resetView];
        //[self.scrollView setNeedsDisplay];
        NSLog(@"self.thePageOfView is %i",self.thePageOfView);
        [self loadVisiblePages];
        
    }
}


- (void)resetView{
    //NSLog(@"page number %i",self.thePageOfView);
    // 4
    
    photoArray = self.categorizedPhotoArray;
    
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    self.scrollView.autoresizesSubviews = YES;
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageImages.count, pagesScrollViewSize.height);
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * (self.thePageOfView), 0)];
    //self.scrollView.contentSize = CGSizeMake(1024.0, 1300.0);
    // 5
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //設定toolbar樣式
    UIImage *image = [UIImage imageNamed:@"navBarBG.png"];
    [self.ToolbarOutlet setBackgroundImage:image forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];

    da = [DataAccess sharedDataSource];
    //self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 1
    NSInteger pageCount = self.pageImages.count;
    NSLog(@"page count is %i", pageCount);
    NSLog(@"pageOfView is %i", self.thePageOfView);
    NSLog(@"pageImage is %@", [self.pageImages description]);
    
    // 2
    //self.pageControl.currentPage = 1;
    //self.pageControl.numberOfPages = pageCount;
    
    // 3
    self.pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < pageCount; ++i) {
        [self.pageViews addObject:[NSNull null]];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self resetView];
    
    [self loadVisiblePages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
