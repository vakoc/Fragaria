//
//  AppDelegate.h
//  MGSFragariaView Demo
//
//  Created by Jim Derry on 2015/02/07.
//
//  A playground and demonstration for MGSFragariaView, and
//  Fragaria and Smulton in general.
//

#import <Cocoa/Cocoa.h>
#import <MGSFragaria/MGSBreakpointDelegate.h>
#import <MGSFragaria/MGSDragOperationDelegate.h>


@interface AppDelegate : NSObject <NSApplicationDelegate, MGSBreakpointDelegate, MGSDragOperationDelegate>

@end

