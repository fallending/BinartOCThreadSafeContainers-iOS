# BinartOCThreadSafeContainers

[![CI Status](https://img.shields.io/travis/fallending/BinartOCThreadSafeContainers.svg?style=flat)](https://travis-ci.org/fallending/BinartOCThreadSafeContainers)
[![Version](https://img.shields.io/cocoapods/v/BinartOCThreadSafeContainers.svg?style=flat)](https://cocoapods.org/pods/BinartOCThreadSafeContainers)
[![License](https://img.shields.io/cocoapods/l/BinartOCThreadSafeContainers.svg?style=flat)](https://cocoapods.org/pods/BinartOCThreadSafeContainers)
[![Platform](https://img.shields.io/cocoapods/p/BinartOCThreadSafeContainers.svg?style=flat)](https://cocoapods.org/pods/BinartOCThreadSafeContainers)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

BinartOCThreadSafeContainers is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BinartOCThreadSafeContainers'
```

## Notes

**Repeats 1000times**

```
^synchronized used : 1.628879 
NSLock used : 0.428537 
NSCondition used : 6.428604 
NSConditionLock used : 1.2S6706 
NSRecursiveLock used : 0.590866 
pthread_mutex used : 0.264639 
dispatch_semaphore used : 0.156741 
OSSpinLock used : 0.0688099
```

#### OSSpinLock

**优先级翻转的问题**

如果一个低优先级的线程获得锁并访问共享资源，这时一个高优先级的线程也尝试获得这个锁，它会处于 spin lock 的忙等状态从而占用大量 CPU。此时低优先级线程无法与高优先级线程争夺 CPU 时间，从而导致任务迟迟完不成、无法释放 lock。这并不只是理论上的问题，libobjc 已经遇到了很多次这个问题了，于是苹果的工程师停用了 OSSpinLock。


新版 iOS 中，系统维护了 5 个不同的线程优先级/QoS: background，utility，default，user-initiated，user-interactive。

iOS10以后，苹果给出了新的api

```
os_unfair_lock_t unfairLock = &(OS_UNFAIR_LOCK_INIT);
os_unfair_lock_lock(unfairLock);
sleep(4);
os_unfair_lock_unlock(unfairLock);
```

#### OSAtomicCompareAndSwap32 + volatile

```
@interface AClass () {
    byte volatile _lockFlag;
}
@end

while(!OSAtomicCompareAndSwap32(0, 1, &_lockFlag));
sleep(4);
OSAtomicCompareAndSwap32(1, 0, &_lockFlag);
```

但是，被废弃了

```
OSATOMIC_DEPRECATED_REPLACE_WITH(atomic_compare_exchange_strong)
__OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_2_0)
bool OSAtomicCompareAndSwap32( int32_t __oldValue, int32_t __newValue, volatile int32_t *__theValue );
```

#### 


## TODOs

当前还没仔细做过锁的性能消耗对比，暂时使用YYThreadSafeArray的方案

1. [iOS中各种锁的性能对比](https://www.jianshu.com/p/54879519fa99)
2. [原子性内存栅栏问题简述](http://djs66256.github.io/2018/03/29/2018-03-29-%E5%86%85%E5%AD%98%E6%A0%85%E6%A0%8F%E9%97%AE%E9%A2%98%E7%AE%80%E8%BF%B0/)

## Author

fallending, fengzilijie@qq.com

## License

BinartOCThreadSafeContainers is available under the MIT license. See the LICENSE file for more info.
