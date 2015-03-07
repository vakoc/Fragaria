//
//  MGSBreakpointDelegate.h
//  Fragaria
//
//  Created by Viktor Lidholt on 3/5/13.
//
//

#import <Cocoa/Cocoa.h>


@class MGSFragaria;


/** The <MGSBreakpointDelegate> protocol specifies methods for delegates
 *  to adopt in order to receive breakpoint-related messages from Fragaria. */

@protocol MGSBreakpointDelegate <NSObject>


@optional


/** This message is sent to a delegate when Fragaria requests a set of line
 *  numbers containing breakpoints.
 *  @param sender A reference to the MGSFragaria instance to which the gutter
 *                originating this message belongs.
 *  @return A set of NSNumber indicating the line numbers that have
 *          breakpoints. */
- (NSSet *)breakpointsForFragaria:(MGSFragaria *)sender;

/** This message is sent to a delegate when Fragaria indicates that a request
 *  to toggle a breakpoint was made.
 *  @param sender A reference to the MGSFragaria instance to which the gutter
 *                originating this message belongs.
 *  @param line The line number which the user clicked on. */
- (void)toggleBreakpointForFragaria:(MGSFragaria *)sender onLine:(NSUInteger)line;


/** @deprecated Use breakpointsForFragaria: instead.
 *  @param file Deprecated parameter. */
- (NSSet*) breakpointsForFile:(NSString*)file DEPRECATED_ATTRIBUTE;

/** @deprecated Use toggleBreakpointForFragaria:onLine: instead.
 *  @param file Deprecated parameter.
 *  @param line Deprecated parameter. */
- (void) toggleBreakpointForFile:(NSString*)file onLine:(int)line DEPRECATED_ATTRIBUTE;


@end
