//
//  Capture.h
//  RecMobile
//
//  Created by BiXiaopeng on 15/3/8.
//  Copyright (c) 2015年 BiXiaopeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MotionEvent;

@interface Capture : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * originalName;
@property (nonatomic, retain) MotionEvent *event;

@end
