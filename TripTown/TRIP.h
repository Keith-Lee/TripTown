//
//  TRIP.h
//  TripTown
//
//  Created by 李 國揚 on 13/5/26.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LOCATION, REGION, USER;

@interface TRIP : NSManagedObject

@property (nonatomic, retain) NSDate * t_endDate;
@property (nonatomic, retain) NSNumber * t_isOngoing;
@property (nonatomic, retain) NSString * t_name;
@property (nonatomic, retain) NSDate * t_startDate;
@property (nonatomic, retain) NSSet *location;
@property (nonatomic, retain) USER *user;
@property (nonatomic, retain) NSSet *region;
@end

@interface TRIP (CoreDataGeneratedAccessors)

- (void)addLocationObject:(LOCATION *)value;
- (void)removeLocationObject:(LOCATION *)value;
- (void)addLocation:(NSSet *)values;
- (void)removeLocation:(NSSet *)values;

- (void)addRegionObject:(REGION *)value;
- (void)removeRegionObject:(REGION *)value;
- (void)addRegion:(NSSet *)values;
- (void)removeRegion:(NSSet *)values;

@end
