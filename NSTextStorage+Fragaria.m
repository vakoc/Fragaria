//
//  NSTextStorage+Fragaria.m
//  Fragaria
//
//  Created by Daniele Cattaneo on 12/12/15.
//
//

#import "NSTextStorage+Fragaria.h"
#import "NSString+Fragaria.h"
#import <objc/runtime.h>


/* MGSTextStorageLineNumberData is a helper class that tells NSTextStorage when
 * it has been edited. It sounds ridicuolous, but consider that:
 *  - overriding a method is not allowed in a category
 *  - subclassing NSTextStorage *is not* an option for obvious reasons (the
 *    application owns NSTextStorage, and forcing the world to give us only
 *    instances of MGSLittleSnowflakeTextStorage is impossible)
 *  - method swizzling is unfeasible because NSTextStorage is a class cluster,
 *    and some random class in the cluster might override the method you
 *    swizzle, canceling it out. */

@interface MGSTextStorageLineNumberData : NSObject
{
    @public
    NSUInteger firstInvalidCharacter;
    NSMutableArray *firstCharacterOfEachLine;
}

@end


@implementation MGSTextStorageLineNumberData


- (instancetype)initWithTextStorage:(NSTextStorage *)ts
{
    NSNotificationCenter *nc;
    
    self = [super init];
    
    firstInvalidCharacter = 0;
    firstCharacterOfEachLine = [[NSMutableArray alloc] init];
    
    nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(textStorageWillProcessEditing:)
      name:NSTextStorageWillProcessEditingNotification object:ts];
    
    return self;
}


- (void)textStorageWillProcessEditing:(NSNotification *)notification
{
    NSTextStorage *ts;
    
    ts = [notification object];
    firstInvalidCharacter = ts.editedRange.location;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end



const static void *MGSLineNumberData = &MGSLineNumberData;


@implementation NSTextStorage (Fragaria)


- (MGSTextStorageLineNumberData *)mgs_lineNumberData
{
    MGSTextStorageLineNumberData *lnd;
    
    if (!(lnd = objc_getAssociatedObject(self, MGSLineNumberData))) {
        lnd = [[MGSTextStorageLineNumberData alloc] initWithTextStorage:self];
        objc_setAssociatedObject(self, MGSLineNumberData, lnd, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return lnd;
}

/* maxc and maxl can be any valid or invalid character index.
 * This function caches all the lines up to and including the one which
 * contains the specified character, stopping early if the given line number
 * was reached. Empty new lines are special cased to appear as a phantom
 * character trailing the string. */
- (NSUInteger)mgs_cacheLineNumberDataUntilCharacter:(NSUInteger)maxc orLine:(NSUInteger)maxl
{
    MGSTextStorageLineNumberData *lnd = [self mgs_lineNumberData];
    NSMutableArray *fcla;
    NSUInteger i, l, len, e;
    NSString *s;
    NSRange lr;
    
    fcla = lnd->firstCharacterOfEachLine;
    len = self.length;
    
    if (lnd->firstInvalidCharacter > 0) {
        i = lnd->firstInvalidCharacter - 1;
        l = [self mgs_rowOfValidCharacter:i];
    } else
        i = l = 0;
    if ([fcla count] > l)
        [fcla removeObjectsInRange:NSMakeRange(l, [fcla count] - l)];
    
    s = [self mutableString];
    lr = [s lineRangeForRange:NSMakeRange(i, 0)];
    while (maxc >= lr.location && maxl >= l) {
        [fcla addObject:@(lr.location)];
        i = NSMaxRange(lr);
        l++;
        if (i == len) {
            if (lr.length == 0) {
                /* Already handled last empty line */
                i++;
                break;
            } else {
                /* Check for last empty line special case */
                [s getLineStart:NULL end:NULL contentsEnd:&e forRange:lr];
                if (e != i)
                    lr = NSMakeRange(i, 0);
                else
                    break;
            }
        } else
            lr = [s lineRangeForRange:NSMakeRange(i, 0)];
    }
    lnd->firstInvalidCharacter = i;
    return l-1;
}


/* c must point to a character of self, or be equal to self.length */
- (NSUInteger)mgs_rowOfValidCharacter:(NSUInteger)c
{
    MGSTextStorageLineNumberData *lnd = [self mgs_lineNumberData];
    NSUInteger i, n;
    NSMutableArray *fcla;
    
    fcla = lnd->firstCharacterOfEachLine;
    n = [fcla count];
    
    /* Optimize last character */
    if (c == [self length])
        return n - 1;
    
    i = [fcla indexOfObject:@(c) inSortedRange:NSMakeRange(0, n)
                    options:NSBinarySearchingInsertionIndex | NSBinarySearchingLastEqual
            usingComparator:^ NSComparisonResult(id obj1, id obj2) {
                return [obj1 compare:obj2];
            }];
    
    if (i == n || ![[fcla objectAtIndex:i] isEqual:@(c)])
        i--;
    return i;
}


- (NSUInteger)mgs_rowOfCharacter:(NSUInteger)c
{
    MGSTextStorageLineNumberData *lnd = [self mgs_lineNumberData];
    
    if (c > [self length])
        return NSNotFound;
    if (c == 0)
        return 0;
    
    if (c < lnd->firstInvalidCharacter)
        return [self mgs_rowOfValidCharacter:c];
    return [self mgs_cacheLineNumberDataUntilCharacter:c orLine:NSUIntegerMax];
}


- (NSUInteger)mgs_firstCharacterInRow:(NSUInteger)l
{
    MGSTextStorageLineNumberData *lnd = [self mgs_lineNumberData];
    NSMutableArray *fcla;
    NSUInteger c, maxl;
    
    fcla = lnd->firstCharacterOfEachLine;
    if ([fcla count] > l) {
        c = [[fcla objectAtIndex:l] unsignedIntegerValue];
        if (c < lnd->firstInvalidCharacter)
            return c;
    }
    
    maxl = [self mgs_cacheLineNumberDataUntilCharacter:NSUIntegerMax orLine:l];
    if (maxl < l)
        return NSNotFound;
    return [[fcla objectAtIndex:l] unsignedIntegerValue];
}


- (NSUInteger)mgs_characterAtIndex:(NSUInteger)i withinRow:(NSUInteger)l
{
    NSUInteger c, e;
    
    c = [self mgs_firstCharacterInRow:l];
    if (c == NSNotFound)
        return NSNotFound;
    if (c == [self length])
        return c;
    
    [self.mutableString getLineStart:NULL end:NULL contentsEnd:&e forRange:NSMakeRange(c, 0)];
    if (c+i < MAX(c, i)) /* Unsigned overflow */
        return e;
    return MIN(e, c+i);
}


@end
