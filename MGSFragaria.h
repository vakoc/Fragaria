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
@interface MGSFragaria : NSObject
{
	@private
	MGSExtraInterfaceController *extraInterfaceController;
    id docSpec;
    NSSet* objectGetterKeys;
    NSSet* objectSetterKeys;
}


/// @name Properties

/**
 *  This property provides access to Fragaria's extra interface items. Consult
 *  MGSExtraInterfaceController.h for a description of what is available.
 *  @todo: (jsd) Is this intended to be exposed for direct programmer use, or
 *  is this something that we should abstract away via Fragaria's public properties?
 **/

@property (nonatomic, readonly) MGSExtraInterfaceController *extraInterfaceController;

/**
 *  When set to an array containing SMLSyntaxError instances, Fragaria can use these
 *  instances to provide feedback to the user in the form of:
 *   - highlighting lines and syntax errors in the text view.
 *   - displaying warning icons in the gutter.
 *   - providing a description of the syntax errors in popovers.
 **/
@property (nonatomic, assign) NSArray *syntaxErrors;


/// @name Private Properties (although exposed these are for internal use)

/**
 *  SyntaxErrorController provides access to Fragaria's internal syntax
 *  error controller. Although it is exposed you should not use this property.
 *  @todo: (jsd) Will eventually migrate these into a category in a private header.
 **/
@property (nonatomic, strong, readonly) MGSSyntaxErrorController *syntaxErrorController;

/*
 *  Do not develop further or use unless necessary. This is to be depreacated
 *  in favor of public and private properties.
 **/
@property (nonatomic, strong) id docSpec;


/// @name Class Methods

+ (void)initializeFramework;
+ (id)createDocSpec;
+ (void)docSpec:(id)docSpec setString:(NSString *)string;
+ (void)docSpec:(id)docSpec setString:(NSString *)string options:(NSDictionary *)options;
+ (void)docSpec:(id)docSpec setAttributedString:(NSAttributedString *)string;
+ (void)docSpec:(id)docSpec setAttributedString:(NSAttributedString *)string options:(NSDictionary *)options;
+ (NSString *)stringForDocSpec:(id)docSpec;
+ (NSAttributedString *)attributedStringForDocSpec:(id)docSpec;
+ (NSAttributedString *)attributedStringWithTemporaryAttributesAppliedForDocSpec:(id)docSpec;
+ (NSImage *)imageNamed:(NSString *)name;


/// @name Class Methods (deprecated)
+ (id)currentInstance DEPRECATED_ATTRIBUTE;
+ (void)setCurrentInstance:(MGSFragaria *)anInstance DEPRECATED_ATTRIBUTE;


/// @name Instance Methods - General

- (id)initWithObject:(id)object;
- (void)setObject:(id)object forKey:(id)key;
- (id)objectForKey:(id)key;
- (void)embedInView:(NSView *)view;
- (MGSTextMenuController *)textMenuController;
- (void)reloadString;
- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)text options:(NSDictionary *)options;
- (void)goToLine:(NSInteger)lineToGoTo centered:(BOOL)centered highlight:(BOOL)highlight;


/// @name Instance Methods - Strings Related
- (void)setString:(NSString *)aString;
- (void)setString:(NSString *)aString options:(NSDictionary *)options;
- (void)setAttributedString:(NSAttributedString *)aString;
- (void)setAttributedString:(NSAttributedString *)aString options:(NSDictionary *)options;
- (NSAttributedString *)attributedString;
- (NSAttributedString *)attributedStringWithTemporaryAttributesApplied;
- (NSString *)string;
- (NSTextView *)textView;


/// @name Instance Methods - Appearance and Display

- (void)setSyntaxColoured:(BOOL)value;
- (BOOL)isSyntaxColoured;
- (void)setShowsLineNumbers:(BOOL)value;
- (BOOL)showsLineNumbers;
- (void)setLineWrap:(BOOL)value;
- (BOOL)lineWrap;
- (void)setShowsWarningsInGutter:(BOOL)value;
- (BOOL)showsWarningsInGutter;


- (void)setHasVerticalScroller:(BOOL)value;
- (BOOL)hasVerticalScroller;
- (void)setDisableScrollElasticity:(BOOL)value;
- (BOOL)isScrollElasticityDisabled;
- (void)setStartingLineNumber:(NSUInteger)value;
- (NSUInteger)startingLineNumber;

- (void)setDocumentName:(NSString *)value;
- (NSString *)documentName;

- (void)setSyntaxDefinitionName:(NSString *)value;
- (NSString *)syntaxDefinitionName;


/// @name Instance Methods that are synonyms of properties

- (void)setSyntaxErrors:(NSArray *)errors;
- (NSArray *)syntaxErrors;

@end
