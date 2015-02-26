//
//  FragariaAppDelegate.h
//  Fragaria
//
//  Created by Jonathan on 30/04/2010.
//  Copyright 2010 mugginsoft.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MGSFragaria/MGSFragariaTextViewDelegate.h>
#import <MGSFragaria/SMLSyntaxColouringDelegate.h>

@class SMLTextView;
@class MGSFragaria;
@class MGSSimpleBreakpointDelegate;

@interface FragariaAppDelegate : NSObject <NSApplicationDelegate, MGSFragariaTextViewDelegate, SMLSyntaxColouringDelegate>

- (IBAction)showPreferencesWindow:(id)sender;
- (IBAction)copyToPasteBoard:(id)sender;
- (IBAction)reloadString:(id)sender;

@property (weak) IBOutlet NSWindow *window;

@property (weak) IBOutlet NSView *editView;

@property (nonatomic,assign) NSString *syntaxDefinition;


@end
