//
//  MotionEvent.h
//  RecMobile
//
//  Created by BiXiaopeng on 15/3/2.
//  Copyright (c) 2015年 BiXiaopeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MotionEvent : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * readed;
@property (nonatomic, retain) NSManagedObject *captures;

@end
