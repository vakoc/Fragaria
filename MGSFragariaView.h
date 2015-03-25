//
//  MGSFragariaView.h
//  Fragaria
//
//  File created by Jim Derry on 2015/02/07.
//
//

#import <Foundation/Foundation.h>
#import "MGSFragariaAPI.h"


@class MGSFragaria;


/**
 *  MGSFragariaView remimplements MGSFragaria from scratch as an IB-compatible
 *  NSView. It is fully compatible with Fragaria's "modern" property-based API
 *  and leaves behind all support for the old docspec, setters and preferences.
 *
 *  MGSFragariaView adheres to <MGSFragariaAPI> so refer to its header file for
 *  the complete reference of properties and methods available.
 *
 *  All API properties are fully bindings-compatible (two-way).
 *
 *  Optional pre-set settings that largely match classic Fragaria's settings and
 *  appearance are available in MGSUserDefaultsDeifinitions, including a handy
 *  plist dictionary that can be used for userDefaults.
 *
 *  A complete management system for properties and user defaults, as well as
 *  a modern set of user interfaces are available in MGSUserDefaultsController
 *  group of files. These are for convenience and are in no way required in
 *  order to use MGSFragariaView.
 */

@interface MGSFragariaView : NSView <MGSFragariaAPI>


/** The same as in the protocol, but IBOutlet added. */
@property (nonatomic, weak) IBOutlet id<SMLAutoCompleteDelegate> autoCompleteDelegate;

/** The same as in the protocol, but IBOutlet added. */
@property (nonatomic, weak) IBOutlet id<MGSBreakpointDelegate> breakpointDelegate;

/** The same as in the protocol, but IBOutlet added. */
@property (nonatomic, weak) IBOutlet id<MGSFragariaTextViewDelegate, MGSDragOperationDelegate> textViewDelegate;

/** The same as in the protocol, but IBOutlet added. */
@property (nonatomic, weak) IBOutlet id<SMLSyntaxColouringDelegate> syntaxColouringDelegate;


#pragma mark - Syntax Highlighting Colours
/// @name Syntax Highlighting Colours


/** Specifies the autocomplete color **/
@property (nonatomic, assign) NSColor *colourForAutocomplete;

/** Specifies the attributes color **/
@property (nonatomic, assign) NSColor *colourForAttributes;

/** Specifies the commands color **/
@property (nonatomic, assign) NSColor *colourForCommands;

/** Specifies the comments color **/
@property (nonatomic, assign) NSColor *colourForComments;

/** Specifies the instructions color **/
@property (nonatomic, assign) NSColor *colourForInstructions;

/** Specifies the keywords color **/
@property (nonatomic, assign) NSColor *colourForKeywords;

/** Specifies the numbers color **/
@property (nonatomic, assign) NSColor *colourForNumbers;

/** Specifies the strings color **/
@property (nonatomic, assign) NSColor *colourForStrings;

/** Specifies the variables color **/
@property (nonatomic, assign) NSColor *colourForVariables;


#pragma mark - Syntax Highlighter Colouring Options
/// @name Syntax Highlighter Colouring Options


/** Specifies whether or not attributes should be syntax coloured. */
@property (nonatomic, assign) BOOL coloursAttributes;

/** Specifies whether or not attributes should be syntax coloured. */
@property (nonatomic, assign) BOOL coloursAutocomplete;

/** Specifies whether or not attributes should be syntax coloured. */
@property (nonatomic, assign) BOOL coloursCommands;

/** Specifies whether or not attributes should be syntax coloured. */
@property (nonatomic, assign) BOOL coloursComments;

/** Specifies whether or not attributes should be syntax coloured. */
@property (nonatomic, assign) BOOL coloursInstructions;

/** Specifies whether or not attributes should be syntax coloured. */
@property (nonatomic, assign) BOOL coloursKeywords;

/** Specifies whether or not attributes should be syntax coloured. */
@property (nonatomic, assign) BOOL coloursNumbers;

/** Specifies whether or not attributes should be syntax coloured. */
@property (nonatomic, assign) BOOL coloursStrings;

/** Specifies whether or not attributes should be syntax coloured. */
@property (nonatomic, assign) BOOL coloursVariables;


@end
