//
//  RecordManager.h
//  RecMobile
//
//  Created by BiXiaopeng on 15/3/8.
//  Copyright (c) 2015年 BiXiaopeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MotionEvent.h"
#import <UIKit/UIKit.h>

@interface RecordManager : NSObject
+(instancetype)sharedManager;
-(void)insertRecord:(NSString*)url;
-(void)deleteRecord:(MotionEvent*)event;
-(NSArray*)getRecords;
@end
