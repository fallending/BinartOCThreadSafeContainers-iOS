
#import <Foundation/Foundation.h>

@interface BAThreadSafeWeakArray : NSObject // : NSMutableArray

- (NSUInteger)count;

- (BOOL)containsObject:(id)anObject;

- (NSEnumerator *)objectEnumerator;

- (void)addObject:(id)anObject;

- (void)removeAllObjects;

- (void)removeObject:(id)anObject;

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id __unsafe_unretained[])stackbuf
                                    count:(NSUInteger)len;
// 遍历
//for (id item in weakArray.objectEnumerator) {
//    [item isProxy];
//}

@end
