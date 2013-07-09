//
//  TRIP.h
//  TripTown
//
//  Created by 李 國揚 on 13/7/9.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class REGION, USER;

@interface TRIP : NSManagedObject

@property (nonatomic, retain) NSDate * t_endDate;
@property (nonatomic, retain) NSNumber * t_isOngoing;
@property (nonatomic, retain) NSString * t_name;
@property (nonatomic, retain) NSDate * t_startDate;
@property (nonatomic, retain) NSSet *region;
@property (nonatomic, retain) USER *user;
@end

@interface TRIP (CoreDataGeneratedAccessors)

- (void)addRegionObject:(REGION *)value;
- (void)removeRegionObject:(REGION *)value;
- (void)addRegion:(NSSet *)values;
- (void)removeRegion:(NSSet *)values;

@end
