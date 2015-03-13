/*
 *  MGSFragaria.h
 *  Fragaria
 *
 *  Created by Jonathan on 30/04/2010.
 *  Copyright 2010 mugginsoft.com. All rights reserved.
 *
 */


/** The following keys are valid keys for:
 *   - (void)setObject:(id)object forKey:(id)key;
 *   - (id)objectForKey:(id)key;
 *  Note that this usage is going away with the elimination of the
 *  docSpec in favor of the use of properties. */
#pragma mark - externs

// BOOL
extern NSString * const MGSFOIsSyntaxColoured DEPRECATED_ATTRIBUTE;
extern NSString * const MGSFOShowLineNumberGutter DEPRECATED_ATTRIBUTE;
extern NSString * const MGSFOHasVerticalScroller DEPRECATED_ATTRIBUTE;
extern NSString * const MGSFODisableScrollElasticity DEPRECATED_ATTRIBUTE;

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
#import "MGSFragariaAPI.h"

@class MGSLineNumberView;
@class SMLSyntaxColouring;

/**
 * MGSFragaria is the main controller class for all of the individual components
 * that constitute the MGSFragaria framework. As the main controller it owns the
 * helper components that allow it to function, such as the custom text view, the
 * gutter view, and so on.
 *
 * @discuss Many of the properties are dynamic, meaning they don't work with
 * KVC. Fortunately most of them simply wrap properties for Fragaria's
 * components, which are KVC-compliant. You might consider updating your code
 * in order to access these properties directly, too, as these property
 * wrappers may be deprecated in the future.
 **/

@interface MGSFragaria : NSObject <MGSFragariaAPI>


#pragma mark - Initializing
/// @name Initializing


/** Adds Fragaria and its components to the specified empty view. This method
 *  replaces embedInView, and is equivalent to calling
 *  -initWithView:useStandardPreferences: with the autopref parameter set to
 *  YES.
 *
 *  @param view The parent view for Fragaria's components. */
- (instancetype)initWithView:(NSView*)view;

/** Designated Initializer
 *
 *  Adds Fragaria and its components to the specified empty view. If the
 *  autopref parameter is YES, Fragaria will automatically register for
 *  observation of the NSUserDefaults preference keys listed in
 *  MGSFragariaPreferences.h, otherwise, Fragaria will not observe any
 *  preference.
 *
 *  @param view     The parent view for Fragaria's components.
 *  @param autopref Set to NO if you don't want to use Fragaria's standard
 *                  preference panels. */
- (instancetype)initWithView:(NSView*)view useStandardPreferences:(BOOL)autopref;


#pragma mark - Deprecated Methods
/// @name Deprecated Methods


/** Deprecated. Do not use. */
+ (id)currentInstance DEPRECATED_ATTRIBUTE;

/** Deprecated. Do not use.
 *  @param anInstance Deprecated. */
+ (void)setCurrentInstance:(MGSFragaria *)anInstance DEPRECATED_ATTRIBUTE;

/** Deprecated. Do not use.
 *  @param name Deprecated. */
+ (NSImage *)imageNamed:(NSString *)name DEPRECATED_ATTRIBUTE;


/** Deprecated. Do not use. */
- (MGSTextMenuController *)textMenuController DEPRECATED_ATTRIBUTE;

/** Sets the value `object` identified by `key`.
 *  @param object Any Objective-C object.
 *  @param key A unique object to serve as the key; typically an NSString. */
- (void)setObject:(id)object forKey:(id)key DEPRECATED_ATTRIBUTE;

/** Returns the object specified by `key`.
 *  @param key The lookup key. */
- (id)objectForKey:(id)key DEPRECATED_ATTRIBUTE;


@end
