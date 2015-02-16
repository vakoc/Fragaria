//
//  MGSBreakpointDelegate.h
//  Fragaria
//
//  Created by Viktor Lidholt on 3/5/13.
//
//

#import <Foundation/Foundation.h>

/**
 *  The <MGSBreakpointDelegate> protocol specifies methods for delegates
 *  to adopt in order to receive breakpoint-related messages from Fragaria.
 **/
@protocol MGSBreakpointDelegate <NSObject>


@optional

/**
 *  This message is sent to a delegate when Fragaria requests
 *  a set of line numbers containing breakpoints.
 *  @param sender The object sending the message, and is a reference to the Fragaria instance.
 *  @return A set if NSNumber indicating the line numbers that have breakpoints.
 **/
- (NSSet*) breakpointsForView:(id)sender;


/**
 * This message is sent to a delegate when Fragaria indicates
 * that a request to toggle a breakpoint was made.
 * @param sender The object sending the message, and is a reference to the Fragaria instance.
 @ @param line The line number for which the request was made.
 **/
- (void) toggleBreakpointForView:(id)sender onLine:(int)line;


/**
 *  @deprecated Use breakpointsForView: instead.
 **/
- (NSSet*) breakpointsForFile:(NSString*)file __deprecated_msg("Use breakpointsForView: instead.");


/**
 *  @deprecated Use toggleBreakpointForView:onLine: instead.
 **/
- (void) toggleBreakpointForFile:(NSString*)file onLine:(int)line __deprecated_msg("Use toggleBreakpointForView:onLine: instead.");

@end
