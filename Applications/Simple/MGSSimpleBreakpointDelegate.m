//
//  MGSSimpleBreakpointDelegate.m
//  Fragaria
//
//  Created by Daniele Cattaneo on 29/01/15.
//
//

#import "MGSSimpleBreakpointDelegate.h"


@implementation MGSSimpleBreakpointDelegate


- (instancetype)init {
    self = [super init];
    breakpoints = [[NSMutableSet alloc] init];
    return self;
}


- (void)toggleBreakpointForFile:(NSString*)file onLine:(int)line {
    NSNumber *lineNumber;
    
    lineNumber = [NSNumber numberWithInt:line];
    if ([breakpoints containsObject:lineNumber])
        [breakpoints removeObject:lineNumber];
    else
        [breakpoints addObject:lineNumber];
}


- (NSSet*)breakpointsForFile:(NSString*)file {
    return [breakpoints copy];
}




@end
