//
//  MotionEvent.h
//  RecMobile
//
//  Created by BiXiaopeng on 15/3/8.
//  Copyright (c) 2015年 BiXiaopeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Capture;

@interface MotionEvent : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * readed;
@property (nonatomic, retain) NSSet *captures;
@end

@interface MotionEvent (CoreDataGeneratedAccessors)

- (void)addCapturesObject:(Capture *)value;
- (void)removeCapturesObject:(Capture *)value;
- (void)addCaptures:(NSSet *)values;
- (void)removeCaptures:(NSSet *)values;

@end
