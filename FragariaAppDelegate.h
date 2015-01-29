//
//  FragariaAppDelegate.h
//  Fragaria
//
//  Created by Jonathan on 30/04/2010.
//  Copyright 2010 mugginsoft.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SMLTextView;
@class MGSFragaria;
@class MGSSimpleBreakpointDelegate;

@interface FragariaAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *__weak window;
	IBOutlet NSView *editView;
	MGSFragaria *fragaria;
	BOOL isEdited;
    MGSSimpleBreakpointDelegate *breakptDelegate;
}

- (IBAction)showPreferencesWindow:(id)sender;
- (IBAction)copyToPasteBoard:(id)sender;
- (IBAction)reloadString:(id)sender;
@property (weak) IBOutlet NSWindow *window;

- (void)setSyntaxDefinition:(NSString *)name;
- (NSString *)syntaxDefinition;

@end
