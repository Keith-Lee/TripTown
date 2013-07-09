//
//  DataAccess.h
//  TripTown
//
//  Created by 李 國揚 on 13/5/1.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectAppDelegate.h" // 用以取得 Core Data 存取物件
#import "DataModel.h" //資料庫互動類別
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MyAssetsManager.h"


@interface DataAccess : NSObject{
    //代理物件的參照
    ProjectAppDelegate *appDelegate;
}

//用以作為method的參照
@property(nonatomic, strong) TRIP *theTrip;
@property(nonatomic, strong) LOCATION *theLocation;
@property(nonatomic, strong) REGION *theRegion;
@property(nonatomic, strong) NSString *customLat;
@property(nonatomic, strong) NSString *customLon;


#pragma mark - singleton method
+(DataAccess *) sharedDataSource;

#pragma mark - for TRIP
- (void) createNewTripWithName: (NSString*)name StartDate: (NSDate *)startDate EndDate: (NSDate *)endDate;
- (BOOL) isTripExistWithTripName: (NSString *)tripName;
- (BOOL) isOngoingTripExist;
- (TRIP *) fetchTripWithTripName: (NSString *)tripName;
- (NSArray *) getAllTrip;

#pragma mark - for REGION
- (void) createRegionWithName: (NSString *)name;
- (BOOL) isRegionWithName: (NSString *)name ExistInTrip: (TRIP *)trip;
- (REGION *) getRegionWithName: (NSString *)name inTrip: (TRIP *)trip;
- (NSArray *) getAllRegionInTrip: (TRIP *)trip;

#pragma mark - for LOCATION
- (void) createLocationWithCoordinate: (CLLocationCoordinate2D) coordinate;
- (BOOL) isLocationWithLatitude: (NSString *)latitude andLongitude: (NSString *)longitude ExistInTripWithTripName: (NSString *)tripName;
- (LOCATION *) fetchLocationWithLatitude: (NSString *)latitude andLongitude: (NSString *)longitude inTrip: (TRIP *)trip;
- (NSArray *) getAllLocationsCoordinateInTripWithName: (NSString *)tripName;


#pragma mark - for PHOTO
- (void) createPhotoWithDate: (NSDate *)date WithImageReference: (NSString *)reference andDescription: (NSString *)description;
- (NSArray *) getAllPhotoForTrip: (TRIP *)trip;
- (NSArray *) getAllPhotoImageForTrip: (TRIP *)trip;
- (NSArray *) getAllPhotoFromLocation: (LOCATION *)location inTrip: (TRIP *)trip;
- (NSArray *) getAllPhotoImageFromLocation: (LOCATION *)location inTrip: (TRIP *)trip;
- (UIImage *) tranferURLtoImage: (NSURL *)url;


#pragma mark - DataModel
- (void) deleteDataModelObject: (id)object;

#pragma mark - for Assets
- (void)createNewAlbumWithName: (NSString *)albumName;
- (ALAssetsGroup *) getAlbumWithName: (NSString *)albumName;
- (NSURL *) returnURLAfterSaveImage: (UIImage *)image withInfoDictionary: (NSDictionary *)info toAlbum: (ALAssetsGroup *)album;
- (void) saveImageWithURL: (NSURL *)url toAlbum: (ALAssetsGroup *)album;
- (ALAsset *)getPhotoAssetWithURL: (NSURL *)url;
- (void) replacePhotoWithNewPhoto: (UIImage *)photo withInfo: (NSDictionary *)info;

@end
