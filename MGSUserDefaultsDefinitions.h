//
//  MGSUserDefaultsDefinitions.h
//  Fragaria
//
//  Created by Jim Derry on 3/3/15.
//
//


#pragma mark - Property User Defaults Keys
/**
 *  #Fragaria Property User Defaults Keys
 *
 *  ## Use with MGSUserDefaultsController and MGSUserDefaults:
 *  These keys can be used in your code to manage Fragaria properties and
 *  user defaults for any instance of MGSFragariaView. The keys' names
 *  correspond fairly well with MGSFragriaView's properties properties.
 *
 *  ## For use in KVO/KVC/IB:
 *  The string values can be found in MGSUserDefaults.m and is also documented
 *  in the comments after each declaration below. For convenience the string
 *  value is identical to the MGSFaragariaView property name. These definitions
 *  are also critical to how MGSUserDefaultsController operates, so do not
 *  change them for namespacing purposes (see +fragariaNamespacedKeyForKey).
 *
 *  ## For use when managing defaults and properties yourself:
 *  For convenience and type safety some convenience methods are provided in
 *  this class in order to use the constants as much as possible.
 */

// Configuring Syntax Highlighting
extern NSString * const MGSFragariaDefaultsSyntaxColoured;                        // BOOL       syntaxColoured
extern NSString * const MGSFragariaDefaultsSyntaxDefinitionName;                  // NSString   syntaxDefinitionName
extern NSString * const MGSFragariaDefaultsColoursMultiLineStrings;               // BOOL       coloursMultiLineStrings
extern NSString * const MGSFragariaDefaultsColoursOnlyUntilEndOfLine;             // BOOL       coloursOnlyUntilEndOfLine

// Configuring Autocompletion
extern NSString * const MGSFragariaDefaultsAutoCompleteDelay;                     // double     autoCompleteDelay
extern NSString * const MGSFragariaDefaultsAutoCompleteEnabled;                   // BOOL       autoCompleteEnabled
extern NSString * const MGSFragariaDefaultsAutoCompleteWithKeywords;              // BOOL       autoCompleteWithKeywords

// Highlighting the current line
extern NSString * const MGSFragariaDefaultsCurrentLineHighlightColour;            // NSColor    currentLineHighlightColour
extern NSString * const MGSFragariaDefaultsHighlightsCurrentLine;                 // BOOL       highlightsCurrentLine

// Configuring the Gutter
extern NSString * const MGSFragariaDefaultsShowsGutter;                           // BOOL       showsGutter
extern NSString * const MGSFragariaDefaultsMinimumGutterWidth;                    // CGFloat    minimumGutterWidth
extern NSString * const MGSFragariaDefaultsShowsLineNumbers;                      // BOOL       showsLineNumbers
extern NSString * const MGSFragariaDefaultsStartingLineNumber;                    // NSUInteger startingLineNumber
extern NSString * const MGSFragariaDefaultsGutterFont;                            // NSFont     gutterFont
extern NSString * const MGSFragariaDefaultsGutterTextColour;                      // NSColor    gutterTextColour

// Showing Syntax Errors
extern NSString * const MGSFragariaDefaultsShowsSyntaxErrors;                     // BOOL       showsSyntaxErrors

// Tabulation and Indentation
extern NSString * const MGSFragariaDefaultsTabWidth;                              // NSInteger  tabWidth
extern NSString * const MGSFragariaDefaultsIndentWidth;                           // NSUInteger indentWidth
extern NSString * const MGSFragariaDefaultsUseTabStops;                           // BOOL       useTabStops
extern NSString * const MGSFragariaDefaultsIndentWithSpaces;                      // BOOL       indentWithSpaces
extern NSString * const MGSFragariaDefaultsIndentBracesAutomatically;             // BOOL       indentBracesAutomatically
extern NSString * const MGSFragariaDefaultsIndentNewLinesAutomatically;           // BOOL       indentNewLinesAutomatically

// Automatic Bracing
extern NSString * const MGSFragariaDefaultsInsertClosingBraceAutomatically;       // BOOL   insertClosingBraceAutomatically
extern NSString * const MGSFragariaDefaultsInsertClosingParenthesisAutomatically; // BOOL   insertClosingParenthesisAutomatically
extern NSString * const MGSFragariaDefaultsShowsMatchingBraces;                   // BOOL   showsMatchingBraces

// Page Guide and Line Wrap
extern NSString * const MGSFragariaDefaultsPageGuideColumn;                       // NSInteger  pageGuideColumn
extern NSString * const MGSFragariaDefaultsShowsPageGuide;                        // BOOL       showsPageGuide
extern NSString * const MGSFragariaDefaultsLineWrap;                              // BOOL       lineWrap

// Showing Invisible Characters
extern NSString * const MGSFragariaDefaultsShowsInvisibleCharacters;              // BOOL    showsInvisibleCharacters
extern NSString * const MGSFragariaDefaultsTextInvisibleCharactersColour;         // NSColor textInvisibleCharactersColour

// Configuring Text Appearance
extern NSString * const MGSFragariaDefaultsTextColor;                             // NSColor textColor
extern NSString * const MGSFragariaDefaultsBackgroundColor;                       // NSColor backgroundColor
extern NSString * const MGSFragariaDefaultsTextFont;                              // NSFont  textFont

// Configuring Additional Text View Behavior
extern NSString * const MGSFragariaDefaultsHasVerticalScroller;                   // BOOL    hasVerticalScroller
extern NSString * const MGSFragariaDefaultsInsertionPointColor;                   // NSColor insertionPointColor
extern NSString * const MGSFragariaDefaultsScrollElasticityDisabled;              // BOOL    scrollElasticityDisabled

// Syntax Highlighting Colours
extern NSString * const MGSFragariaDefaultsColourForAutocomplete;                 // NSColor colourForAutocomplete
extern NSString * const MGSFragariaDefaultsColourForAttributes;                   // NSColor colourForAttributes
extern NSString * const MGSFragariaDefaultsColourForCommands;                     // NSColor colourForCommands
extern NSString * const MGSFragariaDefaultsColourForComments;                     // NSColor colourForComments
extern NSString * const MGSFragariaDefaultsColourForInstructions;                 // NSColor colourForInstructions
extern NSString * const MGSFragariaDefaultsColourForKeywords;                     // NSColor colourForKeywords
extern NSString * const MGSFragariaDefaultsColourForNumbers;                      // NSColor colourForNumbers
extern NSString * const MGSFragariaDefaultsColourForStrings;                      // NSColor colourForStrings
extern NSString * const MGSFragariaDefaultsColourForVariables;                    // NSColor colourForVariables

// Syntax Highlighter Colouring Options
extern NSString * const MGSFragariaDefaultsColoursAttributes;                     // BOOL coloursAttributes
extern NSString * const MGSFragariaDefaultsColoursAutocomplete;                   // BOOL coloursAutocomplete
extern NSString * const MGSFragariaDefaultsColoursCommands;                       // BOOL coloursCommands
extern NSString * const MGSFragariaDefaultsColoursComments;                       // BOOL coloursComments
extern NSString * const MGSFragariaDefaultsColoursInstructions;                   // BOOL coloursInstructions
extern NSString * const MGSFragariaDefaultsColoursKeywords;                       // BOOL coloursKeywords
extern NSString * const MGSFragariaDefaultsColoursNumbers;                        // BOOL coloursNumbers
extern NSString * const MGSFragariaDefaultsColoursStrings;                        // BOOL coloursStrings
extern NSString * const MGSFragariaDefaultsColoursVariables;                      // BOOL coloursVariables



/**
 *  This macro defines the identifier for the global defaults, and is the name
 *  that will be used for the global defaults dictionary written to defaults.
 *  You should never have to worry about this, and is only used if you are
 *  using MGSUserDefaultsController.
 **/
#define MGSUSERDEFAULTS_GLOBAL_ID @"Global"


@class MGSFragariaView;


/**
 *  MGSUserDefaultsDefinitions class consists of several class methods that
 *  serve as conveniences for working with MGSFragaria. Although it is used
 *  by MGSUserDefaultsController, it may be of value to you if you choose to
 *  manage your own defaults and properties, as it can provide useful defaults
 *  for instances of Fragaria.
 **/
@interface MGSUserDefaultsDefinitions : NSObject


#pragma mark - Class Methods - Defaults Dictionaries


/**
 *  This class method returns an NSDictionary with key-value pairs offering
 *  suitable defaults that you can use in your application with
 *  `registerDefaults`, if you are managing your own defaults and properties.
 *
 *  @discuss If you are using MGSUserDefaultsController, then you should have
 *  no need to registerDefaults with these; it will be handled automatically.
 **/
+ (NSDictionary *)fragariaDefaultsDictionary;


/**
 *  This class method returns an dictionary that will be added automatically
 *  to +fragariaDefaultsDictionary and +fragariaDefaultsDictionaryWithNamespace.
 *
 *  @discuss The default implementation returns an empty dictionary. This method
 *  should be implemented by subclasses to return a dictionary of your preferred
 *  defaults settings so that you can override defaults choices that are already
 *  made. In this way you can avoid both altering the original source code of 
 *  this class and rewriting it entirely.
 **/
+ (NSDictionary *)fragariaSupplementalDefaultsDictionary;


#pragma mark - Class Methods - Manual Management Support


/**
 *  This method will namespace the string values of the constant string above,
 *  and is intended for use if you are managing your own properties and
 *  defaults.
 *
 *  @discuss Because the string values are simply the property name, you may
 *  not want to use them as NSUserDefaults keys without applying a namespace to
 *  them, lest you collide with other keys in your application.
 *
 *  @param aString The key to namespace.
 **/
+ (NSString *)fragariaNamespacedKeyForKey:(NSString *)aString;


/**
 *  This method will return the `fragariaDefaultsDictionary` as above, but with
 *  each key namespaced via `fragariaNamespacedKeyForKey:`. It is intended for
 *  use if you are managing your own properties and defaults.
 *
 *  @discuss Just in case you're adamant about managing Fragaria properties and
 *  user defaults yourself, you can use this class method instead of 
 *  `fragariaDefaultsDictionary`.
 **/
+ (NSDictionary *)fragariaDefaultsDictionaryWithNamespace;


/**
 *  This method will apply the defaults to an instance of MGSFragaria. It is
 *  meant only as a convenience to set your instance' defaults one time only,
 *  and only if you are managing your own properties and user defaults. After
 *  this, you're on your own.
 *
 *  @param fragaria In instance of Fragaria in which to apply defaults.
 **/
+ (void)applyDefaultsToFragariaView:(MGSFragariaView *)fragaria;


@end
