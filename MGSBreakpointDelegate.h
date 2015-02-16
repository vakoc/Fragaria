//
//  MGSBreakpointDelegate.h
//  Fragaria
//
//  Created by Viktor Lidholt on 3/5/13.
//
//

#import <Foundation/Foundation.h>

@protocol MGSBreakpointDelegate <NSObject>


@optional

- (NSSet*) breakpointsForFile:(NSString*)file;

- (void) toggleBreakpointForFile:(NSString*)file onLine:(int)line;

@end
