//
//  MGSLineNumberView.h
//  MGSFragaria
//
//  Copyright (c) 2015 Daniele Cattaneo
//

//
//  NoodleLineNumberView.h
//  NoodleKit
//
//  Created by Paul Kim on 9/28/08.
//  Copyright (c) 2008-2012 Noodlesoft, LLC. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//

#import <Cocoa/Cocoa.h>
#import "MGSFragaria.h"

/**
 *  Displays line numbers for an NSTextView.
 */

@protocol MGSBreakpointDelegate;


@interface MGSLineNumberView : NSRulerView
{
    // Array of character indices for the beginning of each line
    NSMutableArray      *_lineIndices;
    // When text is edited, this is the start of the editing region. All line
    // calculations after this point are invalid and need to be recalculated.
    NSUInteger          _invalidCharacterIndex;
}


/// @name Properties


/** Indicates the object acting as the breakpoint delegate. */
@property (nonatomic, weak) id <MGSBreakpointDelegate> breakpointDelegate;

/** A reference to the owning Fragaria instance. */
@property (nonatomic, weak, readonly) MGSFragaria *fragaria;

/** The display font for the text editor. */
@property (nonatomic) NSFont *font;
/** Primary text color for the text editor. */
@property (nonatomic) NSColor *textColor;
/** Alternate text color for the text editor. */
@property (nonatomic) NSColor *alternateTextColor;
/** Text editor background color. */
@property (nonatomic) NSColor *backgroundColor;
/** Minimum width of the gutter. */
@property (nonatomic) CGFloat minimumWidth;

/** The starting line number in the editor. */
@property (nonatomic) NSUInteger startingLineNumber;
/** A dictionary of NSImages, keyed by zero-based line numbers as NSNumbers.
 * The NSImages will be shown at the line specified by their key. */
@property (nonatomic) NSDictionary *decorations;
/** The target of the action that is sent when a decoration is clicked. */
@property (weak) id decorationActionTarget;
/** The action that is sent to decorationActionTarget when a decoration is
 * clicked. */
@property (assign) SEL decorationActionSelector;
/** The last line clicked by the user in the gutter. May be used by
 * decorationActionTarget to determine which decoration was clicked. */
@property (readonly) NSUInteger selectedLineNumber;

/** Indicates whether or not line numbers should be drawn. */
@property (nonatomic) BOOL *drawsLineNumbers;

/** Indicates the default color to be used for breakpoint markers when
 * not specified by the delegate. */
@property (nonatomic) NSColor *markerColor;


/// @name Instance Methods


/** Initializes a new instance of MGSLineNumberView, associating is with aScrollView.
 * and an owning Fragaria instance.
 * @param aScrollView Indicates the scroll view associated with this instance.
 * @param fragaria Indicates the Fragaria instance associated with this instance. */
- (id)initWithScrollView:(NSScrollView *)aScrollView fragaria:(MGSFragaria *)fragaria;

/** Initializes a new instance of MGSLineNumberView, associating is with aScrollView.
 * @param aScrollView Indicates the scroll view associated with this instance. */
- (id)initWithScrollView:(NSScrollView *)aScrollView;

/** Returns the line number for a character position.
 * @param location The character position being checked. */
- (NSUInteger)lineNumberForLocation:(CGFloat)location;

/** The rectangle (relative to this view's origin) where the decoration of
 * the specified line is drawn.
 * @param line A zero-based line number. */
- (NSRect)decorationRectOfLine:(NSUInteger)line;


@end
