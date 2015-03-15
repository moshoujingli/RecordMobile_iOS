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
@property (strong,nonatomic)AFAmazonS3Manager *s3Manager;
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
        self.formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        self.s3Manager = [[AFAmazonS3Manager alloc]initWithAccessKeyID:S3_ACCESS_KEY_ID secret:S3_SECRET];
        self.s3Manager.requestSerializer.region = AFAmazonS3APNortheast2Region;
        self.s3Manager.requestSerializer.bucket = S3_BUCKET;
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

-(void)loadImageInEvent:(MotionEvent *)event
               progress:(void (^)(NSUInteger byteReaded,NSUInteger byteDecompressed,NSUInteger byteTotal))progress
                success:(void (^)(NSArray *images))success
                failure:(void (^)(NSError *error))failure{
    NSURL *url = [NSURL URLWithString:event.url];
    NSString *path = url.path;
    
    [self.s3Manager getObjectWithPath:path progress:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        progress(bytesRead,0,totalBytesExpectedToRead);
    } success:^(id responseObject, NSData *responseData) {
        NSString *outPath =[NSHomeDirectory() stringByAppendingString:@"/Documents/temp"];
        [[NSFileManager defaultManager] createDirectoryAtPath: outPath withIntermediateDirectories:YES attributes:nil error:nil];
        NSArray *content = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:outPath error:nil];
        for (NSString *fileName in content) {
            NSString *tempFilePath = [outPath stringByAppendingPathComponent:fileName];
            [[NSFileManager defaultManager]removeItemAtPath:tempFilePath error:nil];
        }
        NSString *zipFile = [outPath stringByAppendingPathComponent:@"temp.zip"];
        [responseData writeToFile:zipFile atomically:YES];
        [SSZipArchive unzipFileAtPath:zipFile toDestination:outPath];
        NSLog(@"%@",outPath);
        content = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:outPath error:nil];
        NSLog(@"%@",content);
        NSMutableArray *images = [[NSMutableArray alloc]init];
        for (NSString *fileName in content) {
            if ([fileName hasSuffix:@"jpg"]) {
                [images addObject:[UIImage imageWithContentsOfFile:[outPath stringByAppendingPathComponent:fileName]]];
            }
        }
        success(images);
//        NSData *unziped = [responseData gunzippedData];
//        NSLog(@"%@",unziped);
    } failure:^(NSError *error) {
        failure(error);
    }];
}



@end
