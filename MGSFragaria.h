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
extern NSString * const MGSFODocumentName;

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


@class MGSTextMenuController;
@class MGSExtraInterfaceController;

#import "MGSFragariaPreferences.h"
#import "MGSBreakpointDelegate.h"
#import "MGSDragOperationDelegate.h"
#import "SMLSyntaxError.h"
#import "SMLSyntaxColouringDelegate.h"
#import "SMLSyntaxDefinition.h"
#import "MGSSyntaxErrorController.h"


/**
 *  This protocol defines an interface for delegates that wish
 *  to receive notifications when from Fragaria's text view.
 **/
#pragma mark - MGSFragariaTextViewDelegate Protocol
@protocol MGSFragariaTextViewDelegate <NSObject>
@optional

/**
 * This notification is send when the paste has been accepted. You can use
 * this delegate method to query the pasteboard for additional pasteboard content
 * that may be relevant to the application: eg: a plist that may contain custom data.
 * @param note is an NSNotification instance.
 **/
- (void)mgsTextDidPaste:(NSNotification *)note;

@end


/**
 * MGSFragaria is the main controller class for all of the individual components
 * that constitute the MGSFragaria framework. As the main controller it owns the
 * helper components that allow it to function, such as the custom text view, the
 * gutter view, and so on.
 **/
#pragma mark - Interface
@interface MGSFragaria : NSObject


/// @name Properties - Content Strings
#pragma mark - Properties - Content Strings

@property (nonatomic, assign) NSString * string;
@property (nonatomic, assign) NSAttributedString *attributedString;
@property (nonatomic, strong, readonly) NSAttributedString *attributedStringWithTemporaryAttributesApplied;


/// @name Properties - Appearance and Display
#pragma mark - Properties - Appearance and Display

@property (nonatomic, assign) NSString *documentName; // @todo fix strong, currently being retained elsewhere
@property (nonatomic, assign) BOOL hasVerticalScroller;
@property (nonatomic, assign) BOOL lineWrap;
@property (nonatomic, assign) BOOL scrollElasticityDisabled;
@property (nonatomic, assign) BOOL showsLineNumbers;
@property (nonatomic, assign) BOOL showsWarningsInGutter;
@property (nonatomic, assign) NSUInteger startingLineNumber;
@property (nonatomic, assign) BOOL isSyntaxColoured;
@property (nonatomic, assign) NSString *syntaxDefinitionName; // @todo fix strong, currently duplicate retain

/**
 *  When set to an array containing SMLSyntaxError instances, Fragaria
 *  use these instances to provide feedback to the user in the form of:
 *   - highlighting lines and syntax errors in the text view.
 *   - displaying warning icons in the gutter.
 *   - providing a description of the syntax errors in popovers.
 **/
@property (nonatomic, assign) NSArray *syntaxErrors;


/// @name Properties - System Components (although exposed these are for internal use)
/// @note: (jsd) to be migrated to a private header.
#pragma mark - Properties - System Components
/**
 *  This property provides access to Fragaria's extra interface items. Consult
 *  MGSExtraInterfaceController.h for a description of what is available.
**/
@property (nonatomic, readonly) MGSExtraInterfaceController *extraInterfaceController;

/**
 *  SyntaxErrorController provides access to Fragaria's internal syntax
 *  error controller. Although it is exposed you should not use this property.
 **/
@property (nonatomic, strong, readonly) MGSSyntaxErrorController *syntaxErrorController;

/**
 *  This property exposes Fragaria's textView.
 **/
@property (nonatomic, assign, readonly) NSTextView *textView;

/*
 *  Do not develop further or use unless necessary. This is to be deprecated
 *  in favor of public and private properties.
 **/
@property (nonatomic, strong) id docSpec;


/// @name Class Methods
#pragma mark - Class Methods

+ (id)createDocSpec;
+ (void)docSpec:(id)docSpec setString:(NSString *)string;
+ (void)docSpec:(id)docSpec setString:(NSString *)string options:(NSDictionary *)options;
+ (void)docSpec:(id)docSpec setAttributedString:(NSAttributedString *)string;
+ (void)docSpec:(id)docSpec setAttributedString:(NSAttributedString *)string options:(NSDictionary *)options;
+ (NSString *)stringForDocSpec:(id)docSpec;
+ (NSAttributedString *)attributedStringForDocSpec:(id)docSpec;
+ (NSAttributedString *)attributedStringWithTemporaryAttributesAppliedForDocSpec:(id)docSpec;


/// @name Class Methods (deprecated)
#pragma mark - Class Methods (deprecated)
+ (id)currentInstance DEPRECATED_ATTRIBUTE;
+ (void)setCurrentInstance:(MGSFragaria *)anInstance DEPRECATED_ATTRIBUTE;
+ (NSImage *)imageNamed:(NSString *)name DEPRECATED_ATTRIBUTE;


/// @name Instance Methods
#pragma mark - Instance Methods

- (id)initWithObject:(id)object;
- (void)setObject:(id)object forKey:(id)key;
- (id)objectForKey:(id)key;
- (void)embedInView:(NSView *)view;
- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)text options:(NSDictionary *)options;
- (void)goToLine:(NSInteger)lineToGoTo centered:(BOOL)centered highlight:(BOOL)highlight;

- (void)setString:(NSString *)aString options:(NSDictionary *)options;
- (void)setAttributedString:(NSAttributedString *)aString options:(NSDictionary *)options;
- (void)reloadString;


/// @name Instance Methods (deprecated)
#pragma mark - Instance Methods (deprecated)
- (MGSTextMenuController *)textMenuController DEPRECATED_ATTRIBUTE;


@end
