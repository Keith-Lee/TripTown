//
//  REGION.h
//  TripTown
//
//  Created by 李 國揚 on 13/5/26.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LOCATION, TRIP;

@interface REGION : NSManagedObject

@property (nonatomic, retain) NSString * r_name;
@property (nonatomic, retain) NSSet *location;
@property (nonatomic, retain) TRIP *trip;
@end

@interface REGION (CoreDataGeneratedAccessors)

- (void)addLocationObject:(LOCATION *)value;
- (void)removeLocationObject:(LOCATION *)value;
- (void)addLocation:(NSSet *)values;
- (void)removeLocation:(NSSet *)values;

@end
