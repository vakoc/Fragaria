//
//  AppDelegate.h
//  MGSFragariaView Demo
//
//  Created by Jim Derry on 2015/03/15.
//
//  A playground and demonstration for MGSFragariaView and the new-style
//  preferences panels.
//
//

#import <Cocoa/Cocoa.h>
#import <MGSFragaria/MGSBreakpointDelegate.h>
#import <MGSFragaria/MGSDragOperationDelegate.h>


@interface AppDelegate : NSObject <NSApplicationDelegate, MGSBreakpointDelegate, MGSDragOperationDelegate>

@property (nonatomic, assign, readonly) NSArray *availableSyntaxDefinitions;

@end

