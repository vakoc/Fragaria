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

@class MGSFragaria;

/**
 *  The SMLTextView is the text view used by Fragaria, and offers rich integration
 *  possibilities with the rest of the MGSFragaria framework.
 **/
@interface SMLTextView : NSTextView


/// @name Properties

@property (nonatomic,assign,readonly) MGSFragaria *fragaria;         ///< A reference to the owning Fragaria instance.

@property (nonatomic) BOOL lineWrap;                                 ///< Indicates whether or not line wrap (word wrap) is enabled.

@property (readonly) NSMutableIndexSet *inspectedCharacterIndexes;   ///< Indicates the character indices that have been inspected.

@property (nonatomic) BOOL highlightCurrentLine;                     ///< Indicates whether or not the current line is highlighted.

@property NSColor *currentLineHighlightColor;                        ///< Indicates the color to use for current line highlighting.


/// @name Instance Methods

- (id)initWithFrame:(NSRect)frame fragaria:(MGSFragaria *)fragaria;   ///< initWithFrame, assigning Fragaria instance at same time.

- (void)setDefaults;                                                  ///< Sets the initial defaults for the text view.

- (void)setTextDefaults;                                              ///< Sets the initial text defaults for the text view.

- (NSInteger)lineHeight;                                              ///< Returns the default line height for the current font.

/**
 *  Set the width of every tab by first checking the size of the tab in spaces in the current
 *  font and then remove all tabs that sets automatically and then set the default tab stop distance.
 **/
- (void)setTabWidth;

/**
 *  Set the page guide values based on the size of the current font.
 **/
- (void)setPageGuideValues;

/**
 *  Sets the text with a string with possible options.
 *  @param text Is the string to set.
 *  @param options is a dictionary of options. Currently `undo` can be `YES` or `NO`.
 **/
- (void)setString:(NSString *)text options:(NSDictionary *)options;

/**
 *  Sets the text view with an attributed string.
 *  @param text The attributed string to set.
 **/
- (void)setAttributedString:(NSAttributedString *)text;

/**
 *  Sets the text with an attributed string with possible options.
 *  @param text Is the string to set.
 *  @param options is a dictionary of options. Currently `undo` can be `YES` or `NO`.
 **/
- (void)setAttributedString:(NSAttributedString *)text options:(NSDictionary *)options;

/**
 *  Configures the view for lineWrapping based on the `lineWrap` property.
 **/
- (void)updateLineWrap;

/**
 *  Replaces the characters in a given range with a string, with possible options.
 *  @param range The range of text to replace.
 *  @param text The new text to be inserted.
 *  @param options A dictionary of options. Currently `undo` can be `YES` or `NO`.
 **/
- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)text options:(NSDictionary *)options;


@end
