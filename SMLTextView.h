/*
 MGSFragaria
 Written by Jonathan Mitchell, jonathan@mugginsoft.com
 Find the latest version at https://github.com/mugginsoft/Fragaria

 Smultron version 3.6b1, 2009-09-12
 Written by Peter Borg, pgw3@mac.com
 Find the latest version at http://smultron.sourceforge.net

 Copyright 2004-2009 Peter Borg

 Licensed under the Apache License, Version 2.0 (the "License"); you may not use
 this file except in compliance with the License. You may obtain a copy of the
 License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software distributed
 under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
 CONDITIONS OF ANY KIND, either express or implied. See the License for the
 specific language governing permissions and limitations under the License.
 */

#import <Cocoa/Cocoa.h>
#import "MGSFragariaTextViewDelegate.h"
#import "MGSDragOperationDelegate.h"


@class MGSFragaria;

/**
 *  The SMLTextView is the text view used by Fragaria, and offers rich integration
 *  possibilities with the rest of the MGSFragaria framework.
 **/
@interface SMLTextView : NSTextView


/// @name Properties - Internal
#pragma mark - Properties - Internal

/** A reference to the owning Fragaria instance. */
@property (nonatomic,assign,readonly) MGSFragaria *fragaria;


/// @name Properties - Appearance and Behaviours
#pragma mark - Properties - Appearance and Behaviours

/** Specifies whether or not auto complete is enabled. */
@property (nonatomic, assign) BOOL autoCompleteEnabled;

/** Specifies the delay time for autocomplete, in seconds. */
@property (nonatomic, assign) double autoCompleteDelay;

/** Indicates the color to use for current line highlighting. */
@property (nonatomic, strong) NSColor *currentLineHighlightColour;

/** Indicates whether or not the current line is highlighted. */
@property (nonatomic, assign) BOOL highlightCurrentLine;

/** Indicates whether or not braces should be indented automatically. */
@property (nonatomic, assign) BOOL indentBracesAutomatically;

/** Indicates whether or not new lines should be indented automatically. */
@property (nonatomic, assign) BOOL indentNewLinesAutomatically;

/** Specifies the automatic indentation width. */
@property (nonatomic, assign) NSUInteger indentWidth;

/** Specifies whether spaces should be inserted instead of tab characters when indenting. */
@property (nonatomic, assign) BOOL indentWithSpaces;

/** Specifies whether or not closing paretheses are inserted automatically. */
@property (nonatomic, assign) BOOL insertClosingParenthesisAutomatically;

/** Speicifies whether or not closing braces are inserted automatically. */
@property (nonatomic, assign) BOOL insertClosingBraceAutomatically;

/** Indicates the current insertion point color. */
@property (nonatomic, assign) NSColor *insertionPointColor;

/** Indicates whether or not line wrap (word wrap) is enabled. */
@property (nonatomic, assign) BOOL lineWrap;

/** Specifies the column position to draw the page guide. */
@property (nonatomic, assign) NSInteger pageGuideColumn;

/** Specifies whether or not matching braces are shown in the editor. */
@property (nonatomic, assign) BOOL showsMatchingBraces;

/** Specifies whether or not to show the page guide. */
@property (nonatomic, assign) BOOL showsPageGuide;

/** Indicates the number of spaces when performing entab or detab operations. */
@property (nonatomic, assign) NSUInteger spacesPerEntabDetab;
 
 
/** Indicates the number of spaces per tab character. **/
@property (nonatomic, assign) NSInteger tabWidth;

/** Indicates the current text color. */
@property (nonatomic, assign) NSColor *textColor;

/** Indicates the current editor font. */
@property (nonatomic, strong) NSFont *textFont;

/** Specified whether or not tab stops should be used when indenting. */
@property (nonatomic, assign) BOOL useTabStops;


/// @name Properties - Delegates
#pragma mark - Properties - Delegates

/** The text view's delegate */
@property (nonatomic, assign) id<MGSFragariaTextViewDelegate, MGSDragOperationDelegate> delegate;


/// @name Strings - Properties and Methods
#pragma mark - Strings - Properties and Methods

/** The string property represents the string in the text view. */
@property (nonatomic, strong) NSString *string;

/** The attributedString property represents the string in the text view as an attributed string. */
@property (nonatomic, strong) NSAttributedString *attributedString;

/** The text editor string, including temporary attributes which have been applied as attributes. */
@property (nonatomic, strong, readonly) NSAttributedString *attributedStringWithTemporaryAttributesApplied;

/**
 *  Sets the text with a string with possible options.
 *  @param text Is the string to set.
 *  @param options is a dictionary of options. Currently `undo` can be `YES` or `NO`.
 **/
- (void)setString:(NSString *)text options:(NSDictionary *)options;

/**
 *  Sets the text with an attributed string with possible options.
 *  @param text Is the string to set.
 *  @param options is a dictionary of options. Currently `undo` can be `YES` or `NO`.
 **/
- (void)setAttributedString:(NSAttributedString *)text options:(NSDictionary *)options;

/**
 *  Replaces the characters in a given range with a string, with possible options.
 *  @param range The range of text to replace.
 *  @param text The new text to be inserted.
 *  @param options A dictionary of options. Currently `undo` can be `YES` or `NO`.
 **/
- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)text options:(NSDictionary *)options;


/// @name Instance Methods - Initializers and Setup
#pragma mark - Instance Methods - Intializers and Setup

/**
 *  Standard initWithFrame, also allowing `fragaria` assignment at same time.
 *  @param frame The frame for the view.
 *  @param fragaria The instance of Fragaria to associate with this view.
 **/
- (id)initWithFrame:(NSRect)frame fragaria:(MGSFragaria *)fragaria;

- (void)setDefaults;                                                  ///< Sets the initial defaults for the text view.


@end
