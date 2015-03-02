/*
 *  MGSFragaria.h
 *  Fragaria
 *
 *  Created by Jonathan on 30/04/2010.
 *  Copyright 2010 mugginsoft.com. All rights reserved.
 *
 */


/**
 *  The following keys are valid keys for:
 *   - (void)setObject:(id)object forKey:(id)key;
 *   - (id)objectForKey:(id)key;
 *  Note that this usage is going away with the elimination of the
 *  docSpec in favor of the use of properties.
 **/
#pragma mark - externs

// BOOL
extern NSString * const MGSFOIsSyntaxColoured DEPRECATED_ATTRIBUTE;
extern NSString * const MGSFOShowLineNumberGutter DEPRECATED_ATTRIBUTE;
extern NSString * const MGSFOHasVerticalScroller DEPRECATED_ATTRIBUTE;
extern NSString * const MGSFODisableScrollElasticity DEPRECATED_ATTRIBUTE;
extern NSString * const MGSFOLineWrap DEPRECATED_ATTRIBUTE;
extern NSString * const MGSFOShowsWarningsInGutter DEPRECATED_ATTRIBUTE;

// string
extern NSString * const MGSFOSyntaxDefinitionName DEPRECATED_ATTRIBUTE;

// NSView *
extern NSString * const ro_MGSFOTextView DEPRECATED_ATTRIBUTE; // readonly
extern NSString * const ro_MGSFOScrollView DEPRECATED_ATTRIBUTE; // readonly

// NSObject
extern NSString * const MGSFODelegate DEPRECATED_ATTRIBUTE;
extern NSString * const MGSFOBreakpointDelegate DEPRECATED_ATTRIBUTE;
extern NSString * const MGSFOSyntaxColouringDelegate DEPRECATED_ATTRIBUTE;
extern NSString * const MGSFOAutoCompleteDelegate DEPRECATED_ATTRIBUTE;


@class MGSTextMenuController;               // @todo: (jsd) can be removed when the textMenuController deprecation is removed.

#import "MGSBreakpointDelegate.h"           // Justification: public delegate.
#import "MGSDragOperationDelegate.h"        // Justification: public delegate.
#import "MGSFragariaTextViewDelegate.h"     // Justification: public delegate.
#import "SMLSyntaxColouringDelegate.h"      // Justification: public delegate.
#import "SMLAutoCompleteDelegate.h"         // Justification: public delegate.

#import "MGSFragariaPreferences.h"          // Justification: currently exposed, but to be killed off later.
#import "SMLSyntaxError.h"                  // Justification: external users require it.
#import "MGSFragariaView.h"                 // Justification: external users require it.
#import "SMLTextView.h"                     // Justification: external users require it / textView property is exposed.


/**
 * MGSFragaria is the main controller class for all of the individual components
 * that constitute the MGSFragaria framework. As the main controller it owns the
 * helper components that allow it to function, such as the custom text view, the
 * gutter view, and so on.
 **/
#pragma mark - Interface
@interface MGSFragaria : NSObject


/// @name Properties - Document Properties
#pragma mark - Properties - Document Support


@property (nonatomic) NSString *syntaxDefinitionName;         ///< Specifies the current syntax definition name.
@property (nonatomic, assign) NSString * string;                      ///< The plain text string of the text editor.
@property (nonatomic, assign) NSAttributedString *attributedString;   ///< The text editor string with attributes.

/**
 *  The text editor string, including temporary attributes which
 *  have been applied as attributes.
 **/
@property (nonatomic, strong, readonly) NSAttributedString *attributedStringWithTemporaryAttributesApplied;


/// @name Properties - Overall Appearance and Display
#pragma mark - Properties - Overall Appearance and Display

@property (nonatomic, assign) double autoCompleteDelay;                   ///< Specifies the delay time for autocomplete, in seconds.
@property (nonatomic, assign) BOOL autoCompleteEnabled;                   ///< Specifies whether or not auto complete is enabled.
@property (nonatomic, assign) BOOL automaticDashSubstitutionEnabled;      ///< Specifies whether or not automatic dash substitution is enabled.
@property (nonatomic, assign) BOOL automaticDataDetectionEnabled;         ///< Specifies whether or not automatic data detection is enabled.
@property (nonatomic, assign) BOOL automaticLinkDetectionEnabled;         ///< Specifies whether or not automatic link detection is enabled.
@property (nonatomic, assign) BOOL automaticQuoteSubstitutionEnabled;     ///< Specifies whether or not automatic quote substitution is enabled.
@property (nonatomic, assign) BOOL automaticTextReplacementEnabled;       ///< Specifies whether or not automatic text replacement is enabled.
@property (nonatomic, assign) NSColor *backgroundColor;                   ///< Indicates the text view background color.
@property (nonatomic, strong) NSColor *colourForAttributes;               ///< Specifies the colour for attributes.
@property (nonatomic, strong) NSColor *colourForAutocomplete;             ///< Specifies the colour for autocomplete.
@property (nonatomic, strong) NSColor *colourForCommands;                 ///< Specifies the colour for commands.
@property (nonatomic, strong) NSColor *colourForComments;                 ///< Specifies the colour for comments.
@property (nonatomic, strong) NSColor *colourForInstructions;             ///< Specifies the colour for instructions.
@property (nonatomic, strong) NSColor *colourForKeywords;                 ///< Specifies the colour for keywords.
@property (nonatomic, strong) NSColor *colourForNumbers;                  ///< Specifies the colour for numbers.
@property (nonatomic, strong) NSColor *colourForStrings;                  ///< Specifies the colour for strings.
@property (nonatomic, strong) NSColor *colourForVariables;                ///< Specifies the colour for variables.
@property (nonatomic, assign) BOOL coloursAttributes;                     ///< Indicates if attributes should be coloured.
@property (nonatomic, assign) BOOL coloursAutocomplete;                   ///< Indicates if autocomplete should be coloured.
@property (nonatomic, assign) BOOL coloursCommands;                       ///< Indicates if commands should be coloured.
@property (nonatomic, assign) BOOL coloursComments;                       ///< Indicates if comments should be coloured.
@property (nonatomic, assign) BOOL coloursInstructions;                   ///< Indicates if instructions should be coloured.
@property (nonatomic, assign) BOOL coloursKeywords;                       ///< Indicates if keywords should be coloured.
@property (nonatomic, assign) BOOL coloursNumbers;                        ///< Indicates if numbers should be coloured.
@property (nonatomic, assign) BOOL coloursStrings;                        ///< Indicates if strings should be coloured.
@property (nonatomic, assign) BOOL coloursVariables;                      ///< Indicates if variables should be coloured.
@property (nonatomic, assign) BOOL colourMultiLineStringsEnabled;         ///< Indicates if multiline strings should be coloured.
@property (nonatomic, assign) BOOL colourOnlyUntilEndOfLineEnabled;       ///< Indicates if coloring should end at end of line.
@property (nonatomic, assign) BOOL continuousSpellCheckingEnabled;        ///< Specifies whether or not automatic spell checking is enabled.
@property (nonatomic, assign) NSColor *currentLineHighlightColour;        ///< Specifies the color to use when highlighting the current line.
@property (nonatomic, assign) BOOL hasVerticalScroller;                   ///< Indicates whether or not the vertical scroller should be displayed.
@property (nonatomic, assign) BOOL grammarCheckingEnabled;                ///< Specifies whether or not automatic grammar checking is enabled.
@property (nonatomic, assign) NSFont *gutterFont;                         ///< Specifies the standard font for the line numbers in the gutter.
@property (nonatomic, assign) NSUInteger gutterMinimumWidth;              ///< Specifies the minimum width of the line number gutter.
@property (nonatomic, assign) NSColor *gutterTextColour;                  ///< Specifies the standard color of the line numbers in the gutter.
@property (nonatomic, assign) BOOL highlightsCurrentLine;                 ///< Specifies whether or not the line with the cursor should be highlighted.
@property (nonatomic, assign) BOOL indentBracesAutomatically;             ///< Indicates whether or not braces should be indented automatically.
@property (nonatomic, assign) BOOL indentNewLinesAutomatically;           ///< Indicates whether or not new lines should be indented automatically.
@property (nonatomic, assign) NSUInteger indentWidth;                     ///< Specifies the automatic indentation width.
@property (nonatomic, assign) BOOL indentWithSpaces;                      ///< Specifies whether spaces should be inserted instead of tab characters when indenting.
@property (nonatomic, assign) BOOL insertClosingParenthesisAutomatically; ///< Specifies whether or not closing paretheses are inserted automatically.
@property (nonatomic, assign) BOOL insertClosingBraceAutomatically;       ///< Specifies whether or not closing braces are inserted automatically.
@property (nonatomic, assign) NSColor *insertionPointColor;               ///< Indicates the color of the insertion point.
@property (nonatomic, assign) BOOL isSyntaxColoured;                      ///< Specifies whether the document shall be syntax highlighted.
@property (nonatomic, assign) BOOL lineWrap;                              ///< Indicates whether or not line wrap is enabled.
@property (nonatomic, assign) NSInteger pageGuideColumn;                  ///< Indicates the column number at which the page guide appears.
@property (nonatomic, assign) BOOL scrollElasticityDisabled;              ///< Indicates whether or not the "rubber band" effect is disabled.
@property (nonatomic, assign) BOOL showsLineNumbers;                      ///< Indicates whether or not line numbers are displayed when the gutter is visible.
@property (nonatomic, assign) BOOL showsGutter;                           ///< Indicates whether or not the gutter is visible.
@property (nonatomic, assign) BOOL showsInvisibleCharacters;              ///< Indicates whether or not invisible characters in the editor are revealed.
@property (nonatomic, assign) BOOL showsMatchingBraces;                   ///<Specifies whether or not matching braces are shown in the editor.
@property (nonatomic, assign) BOOL showsPageGuide;                        ///< Specifies whether or not to show the page guide.
@property (nonatomic, assign) BOOL showsWarningsInGutter;                 ///< Indicates whether or not error warnings are displayed.
@property (nonatomic, assign) BOOL smartInsertDeleteEnabled;              ///< Specifies whether or not smart insert and delete is enabled.
@property (nonatomic, assign) NSUInteger spacesPerEntabDetab;             ///< Indicates the number of spaces when performing entab or detab operations.
@property (nonatomic, assign) NSUInteger startingLineNumber;              ///< Specifies the starting line number in the text view.
@property (nonatomic, assign) NSInteger tabWidth;                         ///< Specifies the number of spaces per tab.
@property (nonatomic, assign) NSColor *textColor;                         ///< Indicates the base (non-highlighted) text color.
@property (nonatomic, assign) NSColor *textCurrentLineHighlightColour;    ///< Specifies the colour to render invisible characters in the text view.
@property (nonatomic, assign) NSFont *textFont;                           ///< Specifies the text editor font.
@property (nonatomic, assign) NSColor *textInvisibleCharactersColour;     ///< Specifies the colour to render invisible characters in the text view.
@property (nonatomic, assign) BOOL useTabStops;                           ///< Specifies whether or not tab stops should be used when indenting.


/// @name Properties - Syntax Errors
#pragma mark - Properties - Syntax Errors

/**
 *  When set to an array containing SMLSyntaxError instances, Fragaria
 *  use these instances to provide feedback to the user in the form of:
 *   - highlighting lines and syntax errors in the text view.
 *   - displaying warning icons in the gutter.
 *   - providing a description of the syntax errors in popovers.
 **/
@property (nonatomic, assign) NSArray *syntaxErrors;


/// @name Properties - Delegates
#pragma mark - Properties - Delegates


/** The autocomplete delegate for this instance of Fragaria. The autocomplete
 * delegate provides a list of words that can be used by the autocomplete
 * feature. If this property is nil, then the list of autocomple words will
 * be read from the current syntax highlighting dictionary. */
@property (nonatomic, weak) id<SMLAutoCompleteDelegate> autoCompleteDelegate;

/** The syntax colouring delegate for this instance of Fragaria. The syntax
 * colouring delegate gets notified of the start and end of each colouring pass
 * so that it can modify the default syntax colouring provided by Fragaria. */
@property (nonatomic, weak) id<SMLSyntaxColouringDelegate> syntaxColouringDelegate;

/** The breakpoint delegate for this instance of Fragaria. The breakpoint
 * delegate is responsible of managing a list of lines where a breakpoint
 * marker is present. */
@property (nonatomic, weak) id<MGSBreakpointDelegate> breakpointDelegate;

/** The text view delegate of this instance of Fragaria. This is an utility
 * accessor and setter for textView.delegate. */
@property (nonatomic, weak) id<MGSFragariaTextViewDelegate> textViewDelegate;


/// @name Properties - System Components
#pragma mark - Properties - System Components


/**
 *  Fragaria's text view.
 **/
@property (nonatomic, strong, readonly) SMLTextView *textView;


/// @name Class Methods (deprecated)
#pragma mark - Class Methods (deprecated)

/**
 *  Deprecated. Do not use.
 **/
+ (id)currentInstance DEPRECATED_ATTRIBUTE;

/**
 *  Deprecated. Do not use.
 *  @param anInstance Deprecated.
 **/
+ (void)setCurrentInstance:(MGSFragaria *)anInstance DEPRECATED_ATTRIBUTE;

/**
 *  Deprecated. Do not use.
 *  @param name Deprecated.
 **/
+ (NSImage *)imageNamed:(NSString *)name DEPRECATED_ATTRIBUTE;


/// @name Instance Methods
#pragma mark - Instance Methods

/** Designated Initializer
 *  Adds Fragaria and its components to the specified empty view. This method
 *  now replaces embedInView.
 *  @param view The parent view for Fragaria's components. */
- (id)initWithView:(NSView*)view;

/**
 *  Sets the value `object` identified by `key`.
 *  @param object Any Objective-C object.
 *  @param key A unique object to serve as the key; typically an NSString.
 **/
- (void)setObject:(id)object forKey:(id)key;

/**
 *  Returns the object specified by `key`.
 *  @param key The lookup key.
 **/
- (id)objectForKey:(id)key;

/**
 *  Replaces the characters specified in a range with new text, with options.
 *  @param range The range to be replaced.
 *  @param text The replacement text.
 *  @param options A dictionary of options. Currently `undo` can be `YES` or `NO`.
 **/
- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)text options:(NSDictionary *)options;

/**
 *  Moves the view to a specific line, possibly centering it and/or highlighting it.
 *  @param lineToGoTo Indicates the line the view should attempt to move to.
 *  @param centered Indicates whether the desired line should be centered, if possible.
 *  @param highlight Indicates whether or not the target line should be highlighted.
 **/
- (void)goToLine:(NSInteger)lineToGoTo centered:(BOOL)centered highlight:(BOOL)highlight;

/**
 *  Sets the string, with options.
 *  @param aString The string to set.
 *  @param options A dictionary of options. Currently `undo` can be `YES` or `NO`.
 **/
- (void)setString:(NSString *)aString options:(NSDictionary *)options;

/**
 *  Set the string using an attributed string, with options.
 *  @param aString The attributed string to set.
 *  @param options A dictionary of options. Currently `undo` can be `YES` or `NO`.
 **/
- (void)setAttributedString:(NSAttributedString *)aString options:(NSDictionary *)options;

/**
 *  Forces the text view to reload its string.
 **/
- (void)reloadString;


/// @name Instance Methods (deprecated)
#pragma mark - Instance Methods (deprecated)

/**
 *  Deprecated. Do not use.
 **/
- (MGSTextMenuController *)textMenuController DEPRECATED_ATTRIBUTE;


@end
