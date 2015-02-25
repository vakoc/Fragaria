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
extern NSString * const MGSFOIsSyntaxColoured;
extern NSString * const MGSFOShowLineNumberGutter;
extern NSString * const MGSFOHasVerticalScroller;
extern NSString * const MGSFODisableScrollElasticity;
extern NSString * const MGSFOLineWrap;
extern NSString * const MGSFOShowsWarningsInGutter;

// string
extern NSString * const MGSFOSyntaxDefinitionName;

// integer
extern NSString * const MGSFOGutterWidth;

// NSView *
extern NSString * const ro_MGSFOTextView; // readonly
extern NSString * const ro_MGSFOScrollView; // readonly
extern NSString * const ro_MGSFOGutterScrollView; // readonly, deprecated
extern NSString * const ro_MGSFOGutterView; // readonly, new

// NSObject
extern NSString * const MGSFODelegate;
extern NSString * const MGSFOBreakpointDelegate;
extern NSString * const MGSFOAutoCompleteDelegate;
extern NSString * const MGSFOSyntaxColouringDelegate;
extern NSString * const ro_MGSFOLineNumbers; // readonly
extern NSString * const ro_MGSFOSyntaxColouring; // readonly


@class MGSTextMenuController;               // @todo: (jsd) can be removed when the textMenuController deprecation is removed.

#import "MGSBreakpointDelegate.h"           // Justification: public delegate.
#import "MGSDragOperationDelegate.h"        // Justification: public delegate.
#import "MGSFragariaTextViewDelegate.h"     // Justification: public delegate.
#import "SMLSyntaxColouringDelegate.h"      // Justification: public delegate.

#import "MGSFragariaPreferences.h"          // Justification: currently exposed, but to be killed of later.
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
@property (nonatomic, strong) NSString *documentName;                 ///< The document name. If set, Fragaria can try to guess the syntax definition.
@property (nonatomic, assign) NSString *syntaxDefinitionName;         ///< Specified the current syntax definition name. @todo: (jsd) fix strong, currently duplicate retain
@property (nonatomic, assign) NSString * string;                      ///< The plain text string of the text editor.
@property (nonatomic, assign) NSAttributedString *attributedString;   ///< The text editor string with attributes.

/**
 *  The text editor string, including temporary attributes which
 *  have been applied as attributes.
 **/
@property (nonatomic, strong, readonly) NSAttributedString *attributedStringWithTemporaryAttributesApplied;


/// @name Properties - Overall Appearance and Display
#pragma mark - Properties - Overall Appearance and Display

@property (nonatomic, assign) BOOL hasVerticalScroller;       ///< Indicates whether or not the vertical scroller should be displayed.
@property (nonatomic, assign) BOOL isSyntaxColoured;          ///< Specifies whether the document shall be syntax highlighted.
@property (nonatomic, assign) BOOL lineWrap;                  ///< Indicates whether or not line wrap is enabled.
@property (nonatomic, assign) BOOL scrollElasticityDisabled;  ///< Indicates whether or not the "rubber band" effect is disabled.
@property (nonatomic, assign) BOOL showsLineNumbers;          ///< Indicates whether or not line numbers are displayed.
@property (nonatomic, assign) BOOL showsWarningsInGutter;     ///< Indicates whether or not error warnings are displayed.
@property (nonatomic, assign) NSUInteger startingLineNumber;  ///< Specifies the starting line number in the text view.


/// @name Properties - Syntax Errors

/**
 *  When set to an array containing SMLSyntaxError instances, Fragaria
 *  use these instances to provide feedback to the user in the form of:
 *   - highlighting lines and syntax errors in the text view.
 *   - displaying warning icons in the gutter.
 *   - providing a description of the syntax errors in popovers.
 **/
@property (nonatomic, assign) NSArray *syntaxErrors;


/// @name Properties - System Components
#pragma mark - Properties - System Components

/**
 *  Fragaria's text view.
 **/
@property (nonatomic, assign, readonly) SMLTextView *textView;

/**
 *  Do not develop further or use unless necessary. This is to be deprecated
 *  in favor of public and private properties.
 **/
@property (nonatomic, strong) id docSpec;


/// @name Class Methods
#pragma mark - Class Methods

/**
 *  Creates the docSpec for the document.
 **/
+ (id)createDocSpec;

/**
 *  Set the docSpec's string.
 *  @param docSpec The docSpec whose string is to be set.
 *  @param string The string to set.
 **/
+ (void)docSpec:(id)docSpec setString:(NSString *)string;

/**
 *  Set's the docSpec's string, possible with options.
 *  @param docSpec The docSpec whose string is to be set.
 *  @param string The string to set.
 *  @param options is a dictionary of options. Currently `undo` can be `YES` or `NO`..
 **/
+ (void)docSpec:(id)docSpec setString:(NSString *)string options:(NSDictionary *)options;

/**
 *  Sets the docSpec's string using an attributed string.
 *  @param docSpec The docSpec whose string is to be set.
 *  @param string The string to set.
 **/
+ (void)docSpec:(id)docSpec setAttributedString:(NSAttributedString *)string;

/**
 *  Sets the docSpec's string using an attributed string, with options.
 *  @param docSpec The docSpec whose string is to be set.
 *  @param string The string to set.
 *  @param options A dictionary of options. Currently `undo` can be `YES` or `NO`.
 **/
+ (void)docSpec:(id)docSpec setAttributedString:(NSAttributedString *)string options:(NSDictionary *)options;

/**
 *  Returns the string for the given docSpec.
 *  @param docSpec The docSpec for which to return the string.
 **/
+ (NSString *)stringForDocSpec:(id)docSpec;

/**
 *  Returns the attributed string for the given docSpec.
 *  @param docSpec The docSpec for which to return the string.
 **/
+ (NSAttributedString *)attributedStringForDocSpec:(id)docSpec;

/**
 *  Returns the attributed string for the given docSpec, with temporary
 *  applied as attributes.
 *  @param docSpec The docSpec for which to return the string.
 **/
+ (NSAttributedString *)attributedStringWithTemporaryAttributesAppliedForDocSpec:(id)docSpec;


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

/**
 *  Initializes a new instance with `object`.
 *  @param object A docSpec or nil.
 **/
- (id)initWithObject:(id)object;

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
 *  Adds Fragaria and its components to the empty view.
 *  @param view The empty view wherein Fragaria constructs its views.
 **/
- (void)embedInView:(NSView *)view;

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
 *
 **/
- (void)reloadString;


/// @name Instance Methods (deprecated)
#pragma mark - Instance Methods (deprecated)

/**
 *
 **/
- (MGSTextMenuController *)textMenuController DEPRECATED_ATTRIBUTE;


@end
