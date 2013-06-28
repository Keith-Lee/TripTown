//
//  LOCATION.h
//  TripTown
//
//  Created by 李 國揚 on 13/5/2.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PHOTO, REGION, TRIP;

@interface LOCATION : NSManagedObject

@property (nonatomic, retain) NSString * l_latitude;
@property (nonatomic, retain) NSString * l_longitude;
@property (nonatomic, retain) NSSet *photo;
@property (nonatomic, retain) REGION *region;
@property (nonatomic, retain) TRIP *trip;
@end

@interface LOCATION (CoreDataGeneratedAccessors)

- (void)addPhotoObject:(PHOTO *)value;
- (void)removePhotoObject:(PHOTO *)value;
- (void)addPhoto:(NSSet *)values;
- (void)removePhoto:(NSSet *)values;

@end
