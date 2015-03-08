//
//  RecordManager.m
//  RecMobile
//
//  Created by BiXiaopeng on 15/3/8.
//  Copyright (c) 2015年 BiXiaopeng. All rights reserved.
//

#import "RecordManager.h"

@interface RecordManager()
@property (strong,nonatomic)NSManagedObjectContext* objCtx;
@property (strong,nonatomic)NSManagedObjectModel* objMdl;
@property (strong,nonatomic)NSDateFormatter* formatter;
@end

@implementation RecordManager

+(instancetype)sharedManager{
    static id _shareManager=nil;
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        _shareManager = [[self alloc]init];
    });
    return _shareManager;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        id delegate = [[UIApplication sharedApplication]delegate];
        self.objCtx = [delegate managedObjectContext];
        self.objMdl = [delegate managedObjectModel];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyyMMddHHmmss"];
        self.formatter = format;
    }
    return self;
}
-(MotionEvent*)newMotionEvent{
    MotionEvent* motionEvent = (MotionEvent*)[NSEntityDescription insertNewObjectForEntityForName:@"MotionEvent" inManagedObjectContext:self.objCtx];
    return motionEvent;
}
-(void)insertRecord:(NSString*)url{
    MotionEvent *e = [self newMotionEvent];
    e.url = url;
    e.readed = [NSNumber numberWithBool:NO];
    NSURL *pathURL = [NSURL URLWithString:e.url];
    NSString *fileName = pathURL.lastPathComponent;
    NSString *createdTime = [[fileName substringToIndex:[fileName length]-3]stringByAppendingString:@""];
    
    NSDate *parsed = [self.formatter dateFromString:createdTime];
    NSLog(@"%@ %@",createdTime,parsed.description);
    e.created = parsed;
    NSError* error;
    [self.objCtx save:&error];
}
-(void)deleteRecord:(MotionEvent*)event{
    [self.objCtx deleteObject:event];
}
-(NSArray *)getRecords{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MotionEvent" inManagedObjectContext:self.objCtx];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"created" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSError *error = nil;
    NSArray *result = [self.objCtx executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        
    }
    return result;
}

@end
