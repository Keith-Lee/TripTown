//
//  DataAccess.m
//  TripTown
//
//  Created by 李 國揚 on 13/5/1.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import "DataAccess.h"

@implementation DataAccess

#pragma mark - Singleton Method

+ (DataAccess *)sharedDataSource {
    static DataAccess *sharedDataSource = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataSource = [[self alloc] init];
    });
    return sharedDataSource;
}

#pragma mark - for TRIP

-(void)createNewTripWithName:(NSString *)name StartDate:(NSDate *)startDate EndDate:(NSDate *)endDate{
    
    //取得應用程式的代理物件參照
    appDelegate = [[UIApplication sharedApplication]delegate];
    
    
    //新增一個 TRIP 的 entity.
    TRIP *newTrip = (TRIP *)[NSEntityDescription insertNewObjectForEntityForName:@"TRIP" inManagedObjectContext:[appDelegate managedObjectContext]];
    
    //從參數設定物件初始值
    newTrip.t_name = name;
    newTrip.t_startDate = startDate;
    newTrip.t_isOngoing = [NSNumber numberWithBool:YES];
    newTrip.t_endDate = endDate;
    
    
    //準備將 Entity 存進 Core Data
    NSError *error = nil;
    
    if(![appDelegate.managedObjectContext save: &error]){
        NSLog(@"新增旅程時候發生錯誤");
    }
    else{
        //在新增旅程之後就定義這是現在參照的trip
        self.theTrip = newTrip;
        NSLog(@"theTrip now is %@", self.theTrip.t_name);
    }
    NSMutableArray *targetarray = [NSMutableArray array];
    [[NSUserDefaults standardUserDefaults] setValue:targetarray forKey:name];
}

-(TRIP *)fetchTripWithTripName:(NSString *)tripName{
    //取得應用程式的代理物件參照
    appDelegate = [[UIApplication sharedApplication]delegate];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"t_name == %@", tripName];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"TRIP"];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [[appDelegate managedObjectContext] executeFetchRequest:request error:&error];
    
    if(array.count == 1){
        return (TRIP *)[array objectAtIndex:0];
    }
    else{
        NSLog(@"cannot find single result");
        return nil;
    }
}

-(NSArray *)getAllTrip{
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"TRIP"];
    NSError *error = nil;
    NSArray *array = [[appDelegate managedObjectContext] executeFetchRequest:request error: &error];
    
    NSLog(@"Now we have %i trip in db.", [array count]);
    
    return array;
}

-(BOOL)isOngoingTripExist{
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"t_isOngoing == 1"];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"TRIP"];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [[appDelegate managedObjectContext]executeFetchRequest:request error:&error];
    if([array count] == 1){
        self.theTrip = (TRIP *)[array objectAtIndex:0];
        NSLog(@"Ongoing trip is detected, name is %@", self.theTrip.t_name);
        return  YES;
    }
    else{
        NSLog(@"No or multiple ongoing trip exist, amount is %i", [array count]);
        return NO;
    }
}


-(BOOL)isTripExistWithTripName:(NSString *)tripName{
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"t_name == %@", tripName];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"TRIP"];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [[appDelegate managedObjectContext] executeFetchRequest:request error:&error];
    
    if([array count] != 0){
        return  YES;
    }
    else{
        return  NO;
    }
    
}

#pragma mark - for REGION

- (void)createRegionWithName:(NSString *)name{
    //取得應用程式的代理物件參照
    appDelegate = [[UIApplication sharedApplication]delegate];
    
    REGION *newRegion = (REGION *) [NSEntityDescription insertNewObjectForEntityForName:@"REGION" inManagedObjectContext:[appDelegate managedObjectContext]];
    
    newRegion.r_name = name;
    
    
    [self.theTrip addRegionObject:newRegion];
    
    NSError *error = nil;
    
    if(![appDelegate.managedObjectContext save: &error]){
        NSLog(@"新增區域時發生錯誤");
    }
    else{
        NSLog(@"Create a region with name %@", name);
        self.theRegion = newRegion;
    }
}

-(BOOL)isRegionWithName:(NSString *)name ExistInTrip:(TRIP *)trip{
    
    appDelegate = [[UIApplication sharedApplication]delegate];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"r_name == %@ && trip.t_name == %@", name, trip.t_name];
    
    //NSLog(@"fetch side predicate is %@", [predicate description]);
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"REGION"];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [[appDelegate managedObjectContext] executeFetchRequest:request error:&error];
    
    if([array count] != 0){
        NSLog(@"REGION already exist in this trip");
        return  YES;
    }
    else{
        NSLog(@"It's a new region in this trip");
        return  NO;
    }

}

- (REGION *)getRegionWithName:(NSString *)name inTrip:(TRIP *)trip{
    
    appDelegate = [[UIApplication sharedApplication]delegate];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"r_name == %@ && trip.t_name == %@", name, trip.t_name];
    
    //NSLog(@"fetch side predicate is %@", [predicate description]);
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"REGION"];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [[appDelegate managedObjectContext] executeFetchRequest:request error:&error];
    
    if(array.count == 1){
        return (REGION *)[array objectAtIndex:0];
    }
    else{
        NSLog(@"cannot find single result, amount is %i", [array count]);
        return nil;
    }
}

- (NSArray *)getAllRegionInTrip:(TRIP *)trip{
    
    appDelegate = [[UIApplication sharedApplication]delegate];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"trip.t_name == %@", trip.t_name];
    
    //NSLog(@"fetch side predicate is %@", [predicate description]);
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"REGION"];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [[appDelegate managedObjectContext] executeFetchRequest:request error:&error];
    
    if(array.count == 0){
        NSLog(@"Cannot find any region in this trip");
        return nil;
    }
    else{
        return array;
    }

}


#pragma mark - for LOCATION

-(void)createLocationWithCoordinate:(CLLocationCoordinate2D)coordinate{
    
    
    //取得應用程式的代理物件參照
    appDelegate = [[UIApplication sharedApplication]delegate];
    
    //新增一個Location的entity.
    LOCATION *newLocation = (LOCATION *)[NSEntityDescription insertNewObjectForEntityForName:@"LOCATION" inManagedObjectContext:[appDelegate managedObjectContext]];
    
    //從參數設定物件初始值
    //newLocation.l_id = @"0";
    newLocation.l_longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    newLocation.l_latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    
    //NSLog(@"mappointis %@, %@", newLocation.l_latitude, newLocation.l_longitude);
    
    
    [self.theTrip addLocationObject:newLocation];
    [self.theRegion addLocationObject:newLocation];
    
    NSError *error = nil;
    
    if(![appDelegate.managedObjectContext save: &error]){
        NSLog(@"新增地點時候發生錯誤");
    }
    else{
        //新增地點到下一個新地點出現前都是用這個地點作為參照
        self.theLocation = newLocation;
        NSLog(@"新的位置: %@ 已寫入", [self.theLocation description]);
    }
}


-(LOCATION *)fetchLocationWithLatitude:(NSString *)latitude andLongitude:(NSString *)longitude inTrip:(TRIP *)trip{
    appDelegate = [[UIApplication sharedApplication]delegate];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"l_latitude == %@ and l_longitude == %@ and trip.t_name == %@", latitude, longitude, trip.t_name];
    
    //NSLog(@"fetch side predicate is %@", [predicate description]);
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"LOCATION"];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [[appDelegate managedObjectContext] executeFetchRequest:request error:&error];
    
    if(array.count == 1){
        return (LOCATION *)[array objectAtIndex:0];
    }
    else{
        NSLog(@"cannot find single result in trip %@, the result number is %i", trip.t_name, [array count]);
        return nil;
    }
}

-(NSArray *)getAllLocationsCoordinateInTripWithName:(NSString *)tripName{
    //取得應用程式的代理物件參照
    appDelegate = [[UIApplication sharedApplication]delegate];
    
    //取得所有該tripName的Location
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"trip.t_name == %@", tripName];
    //NSLog(@"predicate trip name is %@",tripName);
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"LOCATION"];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [[appDelegate managedObjectContext] executeFetchRequest:request error:&error];
    
    if(array.count == 0){
        NSLog(@"Cannot find any location in this trip, error message: %@", error);
        return nil;
    }
    else{
        return array;
    }
}


-(BOOL)isLocationWithLatitude:(NSString *)latitude andLongitude:(NSString *)longitude ExistInTripWithTripName:(NSString *)tripName{
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"l_latitude == %@ and l_longitude == %@ and trip.t_name == %@", latitude, longitude, tripName];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"LOCATION"];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [[appDelegate managedObjectContext] executeFetchRequest:request error:&error];
    
    if([array count] != 0){
        NSLog(@"Location already exist in this trip");
        return  YES;
    }
    else{
        NSLog(@"It's a new location in this trip");
        return  NO;
    }
}

#pragma mark - for PHOTO

-(void)createPhotoWithDate:(NSDate *)date WithImageReference:(NSString *)reference andDescription:(NSString *)description{
    //取得應用程式的代理物件參照
    appDelegate = [[UIApplication sharedApplication]delegate];
    
    //新增一個photo的entity
    PHOTO *newPhoto = (PHOTO *)[NSEntityDescription insertNewObjectForEntityForName:@"PHOTO" inManagedObjectContext:[appDelegate managedObjectContext]];
    
    //從參數設定初始值
    newPhoto.p_date = date;
    newPhoto.p_image = reference;
    newPhoto.p_description = description;
    
    //找出對應的location並加入這個photo
    NSLog(@"theLocation is %@", [self.theLocation description]);
    [self.theLocation addPhotoObject:newPhoto];
    
    NSError *error = nil;
    
    if(![appDelegate.managedObjectContext save: &error]){
        NSLog(@"新增相片時發生錯誤");
    }
    else{
        NSLog(@"新的相片已經寫入");
    }
    
}


-(NSArray *)getAllPhotoForTrip:(TRIP *)trip{
    appDelegate = [[UIApplication sharedApplication]delegate];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"location.trip.t_name == %@", trip.t_name];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"PHOTO"];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [[appDelegate managedObjectContext]executeFetchRequest:request error: &error];
    
    if([array count] == 0){
        NSLog(@"(DataAccess)Cannot find any PHOTO in trip");
        return  nil;
    }
    else{
        return array;
    }
    
}


-(NSArray *)getAllPhotoImageForTrip:(TRIP *)trip{
    
    NSArray *array = [self getAllPhotoForTrip:trip];
    
    NSMutableArray *resultMutableArray = [NSMutableArray array];
    for(PHOTO *photo in array){
        UIImage *image = [self tranferURLtoImage:[NSURL URLWithString:photo.p_image]];
        if(image == nil){
            NSLog(@"Image is not found , delete the Object");
            //假設我們找不到這個圖片，就表示user已從相簿刪除該像片，所以資料庫也要同步刪除
            //[self deleteDataModelObject:(PHOTO *)photo];
            if([photo.location.photo count] == 1 && [photo.location.region.location count] == 1){
                [self deleteDataModelObject:photo.location.region];
            }
            
            else if([photo.location.photo count] == 1 && [photo.location.region.location count] > 1){
                [self deleteDataModelObject:photo.location];
            }
            else{
                [self deleteDataModelObject:photo];
            }
        }
        else{
            [resultMutableArray addObject:image];
        }
    }
    
    if([resultMutableArray count] > 0)
        return (NSArray *)resultMutableArray;
    else
        return nil;
    
}

/*- (NSArray *)getAllPhotoForRegion:(REGION *)region inTrip:(TRIP *)trip{
    appDelegate = [[UIApplication sharedApplication]delegate];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"location.region.trip.t_name == %@ && location.region.r_name == %@", trip.t_name, region.r_name];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"PHOTO"];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [[appDelegate managedObjectContext]executeFetchRequest:request error: &error];
    
    if([array count] == 0){
        NSLog(@"(DataAccess)Cannot find any PHOTO in REGION");
        return  nil;
    }
    else{
        return array;
    }
    
}


- (NSArray *)getAllPhotoImageForRegion:(REGION *)region inTrip:(TRIP *)trip{
    
    appDelegate = [[UIApplication sharedApplication]delegate];
    
}*/



- (UIImage *)tranferURLtoImage:(NSURL *)url{
#warning - block method would execute asynchrounously so here is the way to make the main thread wait until the block method is finished;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    
    ALAssetsLibrary *library = [MyAssetsManager defaultAssetLibrary];
    __block UIImage *returnImage = nil;
    dispatch_async(queue, ^{
        [library assetForURL:url
                 resultBlock:^(ALAsset *asset) {
                     //NSLog(@"%@",[asset description]);
                     //如果傳回的結果是nil
                     if(asset == nil){
                         returnImage = nil;
                     }
                     //如果有抓到image
                     else{
                         returnImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
                     }
                     dispatch_semaphore_signal(sema);
                 }
                failureBlock:^(NSError *error) {
                    NSLog(@"Error: %@", [error description]);
                    dispatch_semaphore_signal(sema);
                }];
    });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    return returnImage;
    
    
    
}

//傳回一個PHOTO類別的array
-(NSArray *)getAllPhotoFromLocation:(LOCATION *)location inTrip:(TRIP *)trip{
    appDelegate = [[UIApplication sharedApplication]delegate];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"location.l_latitude == %@ and location.l_longitude == %@ and location.trip.t_name == %@", location.l_latitude, location.l_longitude, trip.t_name];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"PHOTO"];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [[appDelegate managedObjectContext]executeFetchRequest:request error: &error];
    if([array count] >0)
        return array;
    else{
        NSLog(@"cannot find any photo in the location");
        return nil;
    }
}

//傳回一個image的array
- (NSArray *)getAllPhotoImageFromLocation:(LOCATION *)location inTrip:(TRIP *)trip{
    
    NSArray *array = [self getAllPhotoFromLocation:location inTrip:trip];
    
    NSMutableArray *resultMutableArray = [NSMutableArray array];
    for(PHOTO *photo in array){
        UIImage *image = [self tranferURLtoImage:[NSURL URLWithString:photo.p_image]];
        if(image == nil){
            NSLog(@"Image is not found , delete the Object");
            //[self deleteDataModelObject:(PHOTO *)photo];
        }
        else{
            [resultMutableArray addObject: image];
        }
    }
    
    if([resultMutableArray count] > 0)
        return (NSArray *)resultMutableArray;
    else
        return nil;
}

#pragma mark - for Assets

-(void)createNewAlbumWithName:(NSString *)albumName{
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    
    ALAssetsLibrary *library = [MyAssetsManager defaultAssetLibrary];
    
    dispatch_async(queue, ^{
        [library addAssetsGroupAlbumWithName:albumName
                                 resultBlock:^(ALAssetsGroup *group) {
                                     NSLog(@"added album:%@", albumName);
                                     dispatch_semaphore_signal(sema);
                                 }
                                failureBlock:^(NSError *error) {
                                    NSLog(@"error adding album");
                                    dispatch_semaphore_signal(sema);
                                }];
    });
    
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

- (ALAssetsGroup *)getAlbumWithName:(NSString *)albumName{
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    ALAssetsLibrary *library = [MyAssetsManager defaultAssetLibrary];
    //NSLog(@"library is %@", [library description]);
    __block ALAssetsGroup* groupToAddTo = nil;
    dispatch_async(queue, ^{
        [library enumerateGroupsWithTypes:ALAssetsGroupAlbum
                               usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                   if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:albumName]) {
                                       NSLog(@"found album %@", albumName);
                                       groupToAddTo = group;
                                       *stop = YES;
                                       
                                       dispatch_semaphore_signal(sema);
                                   }
                                   else{
                                       NSLog(@"Cannot find the album");
                                       //groupToAddTo = [self getAlbumWithName:albumName];
                                       dispatch_semaphore_signal(sema);
                                       
                                   }
                                   
                               }
                             failureBlock:^(NSError* error) {
                                 NSLog(@"failed to enumerate albums:\nError: %@", [error localizedDescription]);
                                 dispatch_semaphore_signal(sema);
                             }];
    });
    while (dispatch_semaphore_wait(sema, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    }
    /*if(groupToAddTo == nil){
     NSLog(@"Try to recreate the album");
     [self createNewAlbumWithName:albumName];
     groupToAddTo = [self getAlbumWithName:albumName];
     }*/
    
    return groupToAddTo;
}


-(void)deleteDataModelObject:(id)object{
    
    appDelegate = [[UIApplication sharedApplication]delegate];
    [[appDelegate managedObjectContext]deleteObject:object];
    NSError *error = nil;
    if(![[appDelegate managedObjectContext] save:&error]){
        NSLog(@"刪除資料發生錯誤");
    }
    else{
        NSLog(@"Object deleted: %@", [object description]);
    }
}

// 使用相機拍照的存入方法
- (NSURL *)returnURLAfterSaveImage:(UIImage *)image withInfoDictionary:(NSDictionary *)info toAlbum:(ALAssetsGroup *)album{
    //NSLog(@"meta data: %@",[[info objectForKey:UIImagePickerControllerMediaMetadata] description]);
    ALAssetsLibrary *library = [MyAssetsManager defaultAssetLibrary];
    __block NSURL *photoURL = nil;
    CGImageRef img = [image CGImage];
    
    
    [library writeImageToSavedPhotosAlbum:img
                                 metadata:[info objectForKey:UIImagePickerControllerMediaMetadata]
                          completionBlock:^(NSURL* assetURL, NSError* error) {
                              if (error.code == 0) {
                                  photoURL = assetURL;
                                  NSLog(@"saved image completed:\nurl: %@", assetURL);
                                  
                                  
                                  // try to get the asset
                                  [library assetForURL:assetURL
                                           resultBlock:^(ALAsset *asset) {
                                               // assign the photo to the album
                                               //NSLog(@"assetURL is %@",[assetURL description]);
                                               [album addAsset:asset];
                                               //NSLog(@"asset is %@ ", [[asset valueForProperty:ALAssetPropertyAssetURL] description]);
                                               NSLog(@"Added %@ to %@", [[asset defaultRepresentation] filename], [album description]);
                                               
                                               
                                           }
                                   
                                   
                                          failureBlock:^(NSError* error) {
                                              NSLog(@"failed to retrieve image asset:\nError: %@ ", [error localizedDescription]);
                                              
                                              
                                          }];
                              }
                              else {
                                  NSLog(@"saved image failed.\nerror code %i\n%@", error.code, [error localizedDescription]);
                                  
                              }
                              
                              
                          }];
    
    while (photoURL == nil) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    //NSLog(@"photoURL is %@", photoURL);
    return photoURL;
}

//從相簿內選取的存入方法
-(void)saveImageWithURL:(NSURL *)url toAlbum:(ALAssetsGroup *)album{
    ALAssetsLibrary *library = [MyAssetsManager defaultAssetLibrary];
    [library assetForURL:url
             resultBlock:^(ALAsset *asset) {
                 [album addAsset:asset];
                 
                 NSLog(@"Added %@ to %@", [[asset defaultRepresentation] filename], [album description]);
             }
            failureBlock:^(NSError* error) {
                NSLog(@"failed to retrieve image asset:\nError: %@ ", [error localizedDescription]);
            }];
    
}

- (ALAsset *)getPhotoAssetWithURL:(NSURL *)url{
    __block ALAsset *photoAsset = nil;
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    
    ALAssetsLibrary *library = [MyAssetsManager defaultAssetLibrary];
    dispatch_async(queue, ^{
        [library assetForURL:url
                 resultBlock:^(ALAsset *asset) {
                     //NSLog(@"%@",[asset description]);
                     //如果傳回的結果是nil
                     if(asset == nil){
                         photoAsset = nil;
                         NSLog(@"Cannot find asset");
                     }
                     //如果有抓到image
                     else{
                         photoAsset = asset;
                         NSLog(@"photo asset is found");
                     }
                     dispatch_semaphore_signal(sema);
                 }
                failureBlock:^(NSError *error) {
                    NSLog(@"Error: %@", [error description]);
                    dispatch_semaphore_signal(sema);
                }];
    });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return photoAsset;
    
}

- (void)replacePhotoWithNewPhoto:(UIImage *)photo withMetadata:(NSDictionary *)info{
    NSData *imageData = UIImagePNGRepresentation(photo);
    ALAsset *photoAsset = [self getPhotoAssetWithURL:(NSURL *)[info objectForKey:@"UIImagePickerControllerReferenceURL"]];
    if ([photoAsset isEditable]) {
        
        [photoAsset setImageData:imageData metadata:[info objectForKey:UIImagePickerControllerMediaMetadata] completionBlock:^(NSURL *assetURL, NSError *error) {
            if (assetURL == nil){
                NSLog(@"cannot replace photo of asset!!");
            }
            else{
                NSLog(@"photo replacement is done");
            }
        }];
    }
    
    else{
        NSLog(@"the asset isn't editable");
    }
}
@end
