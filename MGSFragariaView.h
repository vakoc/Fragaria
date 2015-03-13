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
 *  MGSFragariaView abstracts much of Fragaria's overhead into an IB-compatible
 *  view. Implements an NSView subclass that abstracts several characteristics
 *  of Fragaria, such as the use of Interface Builder to set delegates and
 *  assign key-value pairs.
 *  Also provides two-way bindable property abstractions for Fragaria's
 *  settings and methods.
 *
 *  Consult MGSFragariaAPI.h for the other properties and methods this class
 *  shares with MGSFragaria.
 */

@interface MGSFragariaView : NSView <MGSFragariaAPI>


/** Provides direct access to the view's instance of MGSFragaria. */
@property (nonatomic, strong, readonly) MGSFragaria *fragaria;

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
