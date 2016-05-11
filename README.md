# SZKCleanCache
iOS开发-清理缓存，将计算缓存，清理缓存封装成类方法，并将清理结果利用block方法实现返回，一键调用，轻松实现

SZKCleanCache 详细介绍：http://www.jianshu.com/p/5ebe4f21c486

封装的SZKCleanCache.h中

```
#import <Foundation/Foundation.h>

typedef void(^cleanCacheBlock)();

@interface SZKCleanCache : NSObject
/**
 *  清理缓存
 */
+(void)cleanCache:(cleanCacheBlock)block;
/**
 *  整个缓存目录的大小
 */
+(float)folderSizeAtPath;

@end
```

SZKCleanCache.m中实现方法：

```
/**
 *  计算单个文件大小
 */
+(long long)fileSizeAtPath:(NSString *)filePath{

    NSFileManager *manager = [NSFileManager defaultManager];

    if ([manager fileExistsAtPath :filePath]){

        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize];
    }
    return 0 ;

}
```

```
/**
 *  计算整个目录大小
 */
+(float)folderSizeAtPath
{
    NSString *folderPath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];

    NSFileManager * manager=[NSFileManager defaultManager ];
    if (![manager fileExistsAtPath :folderPath]) {
        return 0 ;
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }

    return folderSize/( 1024.0 * 1024.0 );
}

```

```
/**
 *  清理缓存
 */
+(void)cleanCache:(cleanCacheBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //文件路径
        NSString *directoryPath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];

        NSArray *subpaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:nil];

        for (NSString *subPath in subpaths) {
            NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
        //返回主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    });

}

```

SZKCleanCache 详细介绍：http://www.jianshu.com/p/5ebe4f21c486











