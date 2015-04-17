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
#import "SMLAutoCompleteDelegate.h"


@class MGSFragaria;

/**
 *  The SMLTextView is the text view used by Fragaria, and offers rich integration
 *  possibilities with the rest of the MGSFragaria framework.
 **/
@interface SMLTextView : NSTextView


/// @name Properties - Appearance and Behaviours
#pragma mark - Properties - Appearance and Behaviours

/** Specifies the delay time for autocomplete, in seconds. */
@property double autoCompleteDelay;

/** Specifies whether or not auto complete is enabled. */
@property BOOL autoCompleteEnabled;

/** If set to YES, the autocomplete list will contain all the keywords of
 * the current syntax definition, in addition to the list provided by the
 * autocomplete delegate. */
@property BOOL autoCompleteWithKeywords;

/** Indicates the color to use for current line highlighting. */
@property (nonatomic, strong) NSColor *currentLineHighlightColour;

/** Indicates whether or not the current line is highlighted. */
@property (nonatomic, assign) BOOL highlightsCurrentLine;

/** Indicates whether or not braces should be indented automatically. */
@property (nonatomic, assign) BOOL indentBracesAutomatically;

/** Indicates whether or not new lines should be indented automatically. */
@property (nonatomic, assign) BOOL indentNewLinesAutomatically;

/** Specifies the automatic indentation width. */
@property (nonatomic, assign) NSUInteger indentWidth;

/** Specifies whether spaces should be inserted instead of tab characters when indenting. */
@property (nonatomic, assign) BOOL indentWithSpaces;

/** Specifies whether or not closing parentheses are inserted automatically. */
@property (nonatomic, assign) BOOL insertClosingParenthesisAutomatically;

/** Specifies whether or not closing braces are inserted automatically. */
@property (nonatomic, assign) BOOL insertClosingBraceAutomatically;

/** Indicates the current insertion point color. */
@property (nonatomic, assign) NSColor *insertionPointColor;

/** Indicates whether or not line wrap (word wrap) is enabled. */
@property (nonatomic, assign) BOOL lineWrap;

/** If lineWrap is enabled, this indicates whether the line should wrap at the page guide column. */
@property (nonatomic, assign) BOOL lineWrapsAtPageGuide;

/** Specifies the column position to draw the page guide. Independently of
    whether or not showsPageGuide is enabled, also indicates the line wrap
    column when both lineWrap and lineWrapsAtPageGuide are enabled.*/
@property (nonatomic, assign) NSInteger pageGuideColumn;

/** Indicates whether or not invisible characters in the editor are revealed.*/
@property (nonatomic, assign) BOOL showsInvisibleCharacters;

/** Specifies whether or not matching braces are shown in the editor. */
@property (nonatomic, assign) BOOL showsMatchingBraces;

/** Specifies whether or not to show the page guide. */
@property (nonatomic, assign) BOOL showsPageGuide;
 
/** Indicates the number of spaces per tab character. **/
@property (nonatomic, assign) NSInteger tabWidth;

/** The natural line height of the receiver is multiplied by this factor to
 *  get the real line height. The default value is 0.0. */
@property (nonatomic) CGFloat lineHeightMultiple;

/** Indicates the current text color. */
@property (copy) NSColor *textColor;

/** Indicates the current editor font. */
@property (nonatomic, strong) NSFont *textFont;

/** Specifies the colour to render invisible characters in the text view.*/
@property (nonatomic, assign) NSColor *textInvisibleCharactersColour;

/** Specifies whether or not tab stops should be used when indenting. */
@property (nonatomic, assign) BOOL useTabStops;

/** Specifies if the syntax colourer has to be disabled or not. */
@property (nonatomic, getter=isSyntaxColoured) BOOL syntaxColoured;


/// @name Properties - Delegates
#pragma mark - Properties - Delegates


/** The text view's delegate */
@property (assign) id<MGSFragariaTextViewDelegate, MGSDragOperationDelegate> delegate;

/** The autocomplete delegate for this text view. */
@property (weak) id<SMLAutoCompleteDelegate> autoCompleteDelegate;


/// @name Strings - Properties and Methods
#pragma mark - Strings - Properties and Methods


/** The text editor string, including temporary attributes which have been
 *  applied by the syntax colourer. */
- (NSAttributedString *)attributedStringWithTemporaryAttributesApplied;


/// @name Instance Methods - Initializers and Setup
#pragma mark - Instance Methods - Setup


- (void)setDefaults;                                                  ///< Sets the initial defaults for the text view.


@end
