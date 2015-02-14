/*
 *  MGSFragaria.h
 *  Fragaria
 *
 *  Created by Jonathan on 30/04/2010.
 *  Copyright 2010 mugginsoft.com. All rights reserved.
 *
 */

// valid keys for 
// - (void)setObject:(id)object forKey:(id)key;
// - (id)objectForKey:(id)key;

// BOOL
extern NSString * const MGSFOIsSyntaxColoured;
extern NSString * const MGSFOShowLineNumberGutter;
extern NSString * const MGSFOHasVerticalScroller;
extern NSString * const MGSFODisableScrollElasticity;
extern NSString * const MGSFOLineWrap;
extern NSString * const MGSFOShowsWarningsInGutter;
extern NSString * const MGSFOShowsWarningsInEditor; // keep in case gutter is turned off.

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
#import "MGSSyntaxErrors.h"
#import "SMLSyntaxColouringDelegate.h"
#import "SMLSyntaxDefinition.h"

@protocol MGSFragariaTextViewDelegate <NSObject>
@optional
- (void)mgsTextDidPaste:(NSNotification *)note;
@end

@interface MGSFragaria : NSObject
{
	@private
	MGSExtraInterfaceController *extraInterfaceController;
    id docSpec;
    NSSet* objectGetterKeys;
    NSSet* objectSetterKeys;
}

@property (nonatomic, readonly) MGSExtraInterfaceController *extraInterfaceController;
@property (nonatomic, strong) id docSpec;

// class methods
+ (id)currentInstance DEPRECATED_ATTRIBUTE;
+ (void)setCurrentInstance:(MGSFragaria *)anInstance DEPRECATED_ATTRIBUTE;
+ (void)initializeFramework;
+ (id)createDocSpec;
+ (void)docSpec:(id)docSpec setString:(NSString *)string;
+ (void)docSpec:(id)docSpec setString:(NSString *)string options:(NSDictionary *)options;
+ (void)docSpec:(id)docSpec setAttributedString:(NSAttributedString *)string;
+ (void)docSpec:(id)docSpec setAttributedString:(NSAttributedString *)string options:(NSDictionary *)options;
+ (NSString *)stringForDocSpec:(id)docSpec;
+ (NSAttributedString *)attributedStringForDocSpec:(id)docSpec;
+ (NSAttributedString *)attributedStringWithTemporaryAttributesAppliedForDocSpec:(id)docSpec;

// instance methods
- (id)initWithObject:(id)object;
- (void)setObject:(id)object forKey:(id)key;
- (id)objectForKey:(id)key;
- (void)embedInView:(NSView *)view;
- (void)goToLine:(NSInteger)lineToGoTo centered:(BOOL)centered highlight:(BOOL)highlight;
- (void)setString:(NSString *)aString;
- (void)setString:(NSString *)aString options:(NSDictionary *)options;
- (void)setAttributedString:(NSAttributedString *)aString;
- (void)setAttributedString:(NSAttributedString *)aString options:(NSDictionary *)options;
- (NSAttributedString *)attributedString;
- (NSAttributedString *)attributedStringWithTemporaryAttributesApplied;
- (NSString *)string;
- (NSTextView *)textView;
- (MGSTextMenuController *)textMenuController;
- (void)setSyntaxColoured:(BOOL)value;
- (BOOL)isSyntaxColoured;
- (void)setShowsLineNumbers:(BOOL)value;
- (BOOL)showsLineNumbers;
- (void)setLineWrap:(BOOL)value;
- (BOOL)lineWrap;
- (void)setShowsWarningsInGutter:(BOOL)value;
- (BOOL)showsWarningsInGutter;
- (void)setShowsWarningsInEditor:(BOOL)value;
- (BOOL)showsWarningsInEditor;
- (void)reloadString;
- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)text options:(NSDictionary *)options;
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

- (void)setSyntaxErrors:(id <MGSSyntaxErrors>)errors;
- (id <MGSSyntaxErrors>)syntaxErrors;
+ (NSImage *)imageNamed:(NSString *)name;

@end
