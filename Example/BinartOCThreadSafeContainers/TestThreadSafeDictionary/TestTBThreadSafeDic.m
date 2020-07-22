//
//  TestTBThreadSafeDic.m
//  TestLockless-iOS
//
//  Created by trongbangvp@gmail.com on 9/1/16.
//  Copyright © 2016 trongbangvp@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FastestThreadSafeDictionary.h"
#import "PMutexThreadSafeDictionary.h"
#import "SpinLockThreadSafeDictionary.h"
#import "BarrierThreadSafeDictionary.h"
#import "FirstRWThreadsafeDictionary.h"

void readWriteOnMultiThread(NSMutableDictionary* dic)
{
    dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t concurrentQueue = dispatch_queue_create("ccQueue", DISPATCH_QUEUE_CONCURRENT);
    
    NSString* key = @"key";
    NSString* key1 = @"key1";
    NSString* key2 = @"key2";
    NSString* newVal = @"newVal";
    
    dispatch_apply(100, concurrentQueue, ^(size_t idx) {
        for(size_t count = 0; count < 1000; ++count)
        {
            //NSString* key = [NSString stringWithFormat:@"key%zu%zu",idx,count];
            //NSString* newVal = [NSString stringWithFormat:@"Val%zu%zu",idx,count];
            
            int i = rand() % 2;
            if(i == 0)
            {
                //Test read use both [] and objectForKey
                id val = dic[key];
                val = [dic objectForKey:key];
                
                NSUInteger n = dic.count;
                id arr = dic.allKeys;
                arr = dic.allValues;
                id enumerator = dic.keyEnumerator;
            }
            else
            {
                [dic removeAllObjects];
                [dic removeObjectForKey:key];
                
                //Test write use [] and setObject
                dic[key] = newVal;
                dic[key1] = newVal;
                dic[key2] = newVal;
                [dic setObject:newVal forKey:key];
                [dic setObject:newVal forKey:key1];
                [dic setObject:newVal forKey:key2];
            }
        }
    });
}


//Test multi thread read and write to the dictionary
void testUnsafeDic()
{
    NSMutableDictionary* dic = [NSMutableDictionary new];
    readWriteOnMultiThread(dic);
}

void testThreadSafeDic()
{
    FastestThreadSafeDictionary* dic = [[FastestThreadSafeDictionary alloc] initWithDictionary:[NSMutableDictionary new]];
    readWriteOnMultiThread(dic);
}

void testPMutexDic()
{
    PMutexThreadSafeDictionary* dic = [PMutexThreadSafeDictionary new];
    readWriteOnMultiThread(dic);
}

void testSpinLockDic()
{
    SpinLockThreadSafeDictionary* dic = [SpinLockThreadSafeDictionary new];
    readWriteOnMultiThread(dic);
}

void testBarrierDic()
{
    BarrierThreadSafeDictionary* dic = [BarrierThreadSafeDictionary new];
    readWriteOnMultiThread(dic);
}

void testFirstRWDic()
{
    FirstRWThreadsafeDictionary* dic = [FirstRWThreadsafeDictionary new];
    readWriteOnMultiThread(dic);
}
