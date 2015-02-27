/*
 *  MGSFragariaPreferences.h
 *  Fragaria
 *
 *  Created by Jonathan on 06/05/2010.
 *  Copyright 2010 mugginsoft.com. All rights reserved.
 *
 */


#pragma mark - Global Keys for Accessing Preferences' Strings

/*
 *  Fragaria Preference Keys By Type
 *  @todo: rearrange by function/component.
 *  @todo: take an inventory of all components to ensure no keys are missing.
 */


// color data
// [NSArchiver archivedDataWithRootObject:[NSColor whiteColor]]
extern NSString * const MGSFragariaPrefsCommandsColourWell;
extern NSString * const MGSFragariaPrefsCommentsColourWell;
extern NSString * const MGSFragariaPrefsInstructionsColourWell;
extern NSString * const MGSFragariaPrefsKeywordsColourWell;
extern NSString * const MGSFragariaPrefsAutocompleteColourWell;
extern NSString * const MGSFragariaPrefsVariablesColourWell;
extern NSString * const MGSFragariaPrefsStringsColourWell;
extern NSString * const MGSFragariaPrefsAttributesColourWell;
extern NSString * const MGSFragariaPrefsBackgroundColourWell;
extern NSString * const MGSFragariaPrefsTextColourWell;
extern NSString * const MGSFragariaPrefsGutterTextColourWell;
extern NSString * const MGSFragariaPrefsInvisibleCharactersColourWell;
extern NSString * const MGSFragariaPrefsHighlightLineColourWell;
extern NSString * const MGSFragariaPrefsNumbersColourWell;

// bool
extern NSString * const MGSFragariaPrefsColourNumbers;
extern NSString * const MGSFragariaPrefsColourCommands;
extern NSString * const MGSFragariaPrefsColourComments;
extern NSString * const MGSFragariaPrefsColourInstructions;
extern NSString * const MGSFragariaPrefsColourKeywords;
extern NSString * const MGSFragariaPrefsColourAutocomplete;
extern NSString * const MGSFragariaPrefsColourVariables;
extern NSString * const MGSFragariaPrefsColourStrings;	
extern NSString * const MGSFragariaPrefsColourAttributes;	
extern NSString * const MGSFragariaPrefsShowFullPathInWindowTitle;
extern NSString * const MGSFragariaPrefsShowLineNumberGutter;
extern NSString * const MGSFragariaPrefsSyntaxColourNewDocuments;            // Despite the name, this never affected only new documents, but also the current document.
extern NSString * const MGSFragariaPrefsLineWrapNewDocuments;                // Desptie the name, this never affected only new documents, but also the current document.
extern NSString * const MGSFragariaPrefsIndentNewLinesAutomatically;
extern NSString * const MGSFragariaPrefsOnlyColourTillTheEndOfLine;
extern NSString * const MGSFragariaPrefsShowMatchingBraces;
extern NSString * const MGSFragariaPrefsShowInvisibleCharacters;
extern NSString * const MGSFragariaPrefsIndentWithSpaces;
extern NSString * const MGSFragariaPrefsColourMultiLineStrings;
extern NSString * const MGSFragariaPrefsAutocompleteSuggestAutomatically;
extern NSString * const MGSFragariaPrefsAutocompleteIncludeStandardWords;
extern NSString * const MGSFragariaPrefsAutoSpellCheck;
extern NSString * const MGSFragariaPrefsAutoGrammarCheck;
extern NSString * const MGSFragariaPrefsSmartInsertDelete;
extern NSString * const MGSFragariaPrefsAutomaticLinkDetection;
extern NSString * const MGSFragariaPrefsAutomaticQuoteSubstitution;
extern NSString * const MGSFragariaPrefsUseTabStops;
extern NSString * const MGSFragariaPrefsHighlightCurrentLine;
extern NSString * const MGSFragariaPrefsAutomaticallyIndentBraces;
extern NSString * const MGSFragariaPrefsAutoInsertAClosingParenthesis;
extern NSString * const MGSFragariaPrefsAutoInsertAClosingBrace;
extern NSString * const MGSFragariaPrefsShowPageGuide;

// integer
extern NSString * const MGSFragariaPrefsGutterWidth;
extern NSString * const MGSFragariaPrefsTabWidth;
extern NSString * const MGSFragariaPrefsIndentWidth;
extern NSString * const MGSFragariaPrefsShowPageGuideAtColumn;	
extern NSString * const MGSFragariaPrefsSpacesPerTabEntabDetab;

// float
extern NSString * const MGSFragariaPrefsAutocompleteAfterDelay;	

// font data
// [NSArchiver archivedDataWithRootObject:[NSFont fontWithName:@"Menlo" size:11]]
extern NSString * const MGSFragariaPrefsTextFont;

// string
extern NSString * const MGSFragariaPrefsSyntaxColouringPopUpString;


#import "MGSFragariaPrefsViewController.h"
#import "MGSFragariaFontsAndColoursPrefsViewController.h"
#import "MGSFragariaTextEditingPrefsViewController.h"


#pragma mark - MGSFragariaPreferences

/**
 *  MGSFragariaPreferences is responsible for registering the userDefaults for instances
 *  of Fragaria, and also offers some ready-made viewControllers should you want to
 *  implement them in your application.
 **/
@interface MGSFragariaPreferences : NSObject


/// @name Class Methods

/**
 *  Uses registerUserDefaults to add all of Fragaria's defaults to the defaults database.
 **/
+ (void)initializeValues DEPRECATED_MSG_ATTRIBUTE("Deprecated, do not use. Use the fragariaDefaultsDictionary property instead.");


/**
 *  Provides a singleton instance of MGSFragariaPreferences.
 *  @todo: this is *only* used in the demo application. And there, it's only
 *         use is to resolve to `revertToStandardSettings`, which uses a
 *         global NSUserDefaultsController to perform its action. Issue #30.
 **/
+ (MGSFragariaPreferences *)sharedInstance DEPRECATED_MSG_ATTRIBUTE("Proposed elimination.");


/// @name Instance Methods

/**
 *  Used by the preference view controllers to propagate the changeFont message
 *  up the responder chain.
 *  @param sender is the sender of the message.
 **/
- (void)changeFont:(id)sender DEPRECATED_MSG_ATTRIBUTE("Proposed elimination.");


/**
 *  Used by the preference view controllers, sets the shared userDefaultsController
 *  back to initial values.
 *  @param sender is the sender of the message.
 **/
- (void)revertToStandardSettings:(id)sender DEPRECATED_MSG_ATTRIBUTE("Proposed elimination.");


/// @name Properties

/**
 *  Provides a dictionary of Fragaria's default values suitable for adding to your registerUserDefaults call in your
 *  application.
 *  @discussion The Framework should not register user defaults for you; you should register them yourself. This
 *  dictionary is suitable for using with your own user defaults when your application starts up.
 **/
@property (nonatomic, readonly) NSDictionary *fragariaDefaultsDictionary;


/**
 *  Provides a ready-made instance of MGSFragariaFontsAndColoursPrefsViewController for applications.
 **/
@property (readonly) MGSFragariaFontsAndColoursPrefsViewController *fontsAndColoursPrefsViewController DEPRECATED_MSG_ATTRIBUTE("Proposed elimination.");


/**
 * Provides a ready-made instance of MGSFragariaTextEditingPrefsViewController for applications.
 **/
@property (readonly) MGSFragariaTextEditingPrefsViewController *textEditingPrefsViewController DEPRECATED_MSG_ATTRIBUTE("Proposed elimination.");


@end

