//
//  MGSLineNumberView.m
//  MGSFragaria
//
//  Copyright (c) 2015 Daniele Cattaneo
//

//
//  NoodleLineNumberView.m
//  NoodleKit
//
//  Created by Paul Kim on 9/28/08.
//  Copyright (c) 2008 Noodlesoft, LLC. All rights reserved.
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

#import "MGSLineNumberView.h"
#import "MGSFragariaFramework.h"
#import <tgmath.h>


#define RULER_MARGIN		5.0


@interface MGSLineNumberView (Private)

- (NSFont *)defaultFont;
- (NSColor *)defaultTextColor;
- (NSColor *)defaultAlternateTextColor;
- (NSColor *)defaultErrorTextColor;
- (NSMutableArray *)lineIndices;
- (void)invalidateLineIndicesFromCharacterIndex:(NSUInteger)charIndex;
- (void)calculateLines;
- (NSUInteger)lineNumberForCharacterIndex:(NSUInteger)index inText:(NSString *)text;
- (NSDictionary *)textAttributes;
- (NSDictionary *)markerTextAttributes;

@end


@implementation MGSLineNumberView


- (id)initWithScrollView:(NSScrollView *)aScrollView
{
    if ((self = [super initWithScrollView:aScrollView orientation:NSVerticalRuler]) != nil)
    {
        imgBreakpoint0 = [MGSFragaria imageNamed:@"editor-breakpoint-0.png"];
        imgBreakpoint1 = [MGSFragaria imageNamed:@"editor-breakpoint-1.png"];
        imgBreakpoint2 = [MGSFragaria imageNamed:@"editor-breakpoint-2.png"];
        
        _lineIndices = [[NSMutableArray alloc] init];
        _startingLineNumber = 0;
        [self setClientView:[aScrollView documentView]];
    }
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (NSFont *)defaultFont
{
    return [NSFont controlContentFontOfSize:0];
}


- (NSColor *)defaultTextColor
{
    return [NSColor blackColor];
}


- (NSColor *)defaultAlternateTextColor
{
    return [NSColor whiteColor];
}


- (NSColor *)defaultErrorTextColor
{
    return [NSColor blackColor];
}


- (NSColor *)defaultBackgroundColor
{
    return [NSColor controlBackgroundColor];
}


- (void)setMinimumWidth:(CGFloat)minimumWidth {
    _minimumWidth = minimumWidth;
    [self setRuleThickness:[self requiredThickness]];
}


- (void)setStartingLineNumber:(NSUInteger)startingLineNumber {
    _startingLineNumber = startingLineNumber;
    [self setNeedsDisplay:YES];
}


- (void)setFont:(NSFont *)font {
    _font = font;
    [self setNeedsDisplay:YES];
}


- (void)setTextColor:(NSColor *)textColor {
    _textColor = textColor;
    [self setNeedsDisplay:YES];
}


- (void)setAlternateTextColor:(NSColor *)alternateTextColor {
    _alternateTextColor = alternateTextColor;
    [self setNeedsDisplay:YES];
}


- (void)setErrorTextColor:(NSColor *)errorTextColor {
    _errorTextColor = errorTextColor;
    [self setNeedsDisplay:YES];
}


- (void)setBackgroundColor:(NSColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    [self setNeedsDisplay:YES];
}


- (void)setClientView:(NSView *)aView
{
	id		oldClientView;
	
    if (aView && ![aView isKindOfClass:[NSTextView class]])
        [NSException raise:@"MGSLineNumberViewNotTextViewClient"
                    format:@"MGSLineNumberView's client view must be a NSTextView."];
    
	oldClientView = [self clientView];
	
    if (oldClientView && (oldClientView != aView))
    {
		[[NSNotificationCenter defaultCenter] removeObserver:self name:NSTextStorageDidProcessEditingNotification object:[(NSTextView *)oldClientView textStorage]];
    }
    [super setClientView:aView];
    if (aView)
    {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textStorageDidProcessEditing:) name:NSTextStorageDidProcessEditingNotification object:[(NSTextView *)aView textStorage]];

		[self invalidateLineIndicesFromCharacterIndex:0];
    }
}


- (NSMutableArray *)lineIndices
{
	if (_invalidCharacterIndex < NSUIntegerMax)
	{
		[self calculateLines];
	}
	return _lineIndices;
}


// Forces recalculation of line indicies starting from the given index
- (void)invalidateLineIndicesFromCharacterIndex:(NSUInteger)charIndex
{
    _invalidCharacterIndex = MIN(charIndex, _invalidCharacterIndex);
}


- (void)textStorageDidProcessEditing:(NSNotification *)notification
{
    NSTextStorage       *storage;
    NSRange             range;
    
    storage = [notification object];

    // Invalidate the line indices. They will be recalculated and re-cached on demand.
    range = [storage editedRange];
    if (range.location != NSNotFound)
    {
        [self invalidateLineIndicesFromCharacterIndex:range.location];
        [self setNeedsDisplay:YES];
    }
}


- (void)calculateLines
{
    id              view;

    view = [self clientView];
    
    NSUInteger      charIndex, stringLength, lineEnd, contentEnd, count, lineIndex;
    NSString        *text;
    CGFloat         oldThickness, newThickness;
    
    text = [view string];
    stringLength = [text length];
    count = [_lineIndices count];

    charIndex = 0;
    lineIndex = [self lineNumberForCharacterIndex:_invalidCharacterIndex inText:text];
    if (count > 0)
    {
        charIndex = [[_lineIndices objectAtIndex:lineIndex] unsignedIntegerValue];
    }
    
    do
    {
        if (lineIndex < count)
        {
            [_lineIndices replaceObjectAtIndex:lineIndex withObject:[NSNumber numberWithUnsignedInteger:charIndex]];
        }
        else
        {
            [_lineIndices addObject:[NSNumber numberWithUnsignedInteger:charIndex]];
        }
        
        charIndex = NSMaxRange([text lineRangeForRange:NSMakeRange(charIndex, 0)]);
        lineIndex++;
    }
    while (charIndex < stringLength);
    
    if (lineIndex < count)
    {
        [_lineIndices removeObjectsInRange:NSMakeRange(lineIndex, count - lineIndex)];
    }
    _invalidCharacterIndex = NSUIntegerMax;

    // Check if text ends with a new line.
    [text getLineStart:NULL end:&lineEnd contentsEnd:&contentEnd forRange:NSMakeRange([[_lineIndices lastObject] unsignedIntegerValue], 0)];
    if (contentEnd < lineEnd)
    {
        [_lineIndices addObject:[NSNumber numberWithUnsignedInteger:charIndex]];
    }

    // See if we need to adjust the width of the view
    oldThickness = [self ruleThickness];
    newThickness = [self requiredThickness];
    if (fabs(oldThickness - newThickness) > 1)
    {
        // Not a good idea to resize the view during calculations (which
        // can happen during display). Do a delayed perform.
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setRuleThickness:newThickness];
        });
    }
}


- (NSUInteger)lineNumberForCharacterIndex:(NSUInteger)charIndex inText:(NSString *)text
{
    NSUInteger			left, right, mid, lineStart;
	NSMutableArray		*lines;

    if (_invalidCharacterIndex < NSUIntegerMax)
    {
        // We do not want to risk calculating the indices again since we are
        // probably doing it right now, thus possibly causing an infinite loop.
        lines = _lineIndices;
    }
    else
    {
        lines = [self lineIndices];
    }
	
    // Binary search
    left = 0;
    right = [lines count];

    while ((right - left) > 1)
    {
        mid = (right + left) / 2;
        lineStart = [[lines objectAtIndex:mid] unsignedIntegerValue];
        
        if (charIndex < lineStart)
        {
            right = mid;
        }
        else if (charIndex > lineStart)
        {
            left = mid;
        }
        else
        {
            return mid;
        }
    }
    return left;
}


- (NSDictionary *)textAttributes
{
    NSFont  *font;
    NSColor *color;
    
    font = [self font];    
    if (font == nil)
    {
        font = [self defaultFont];
    }
    
    color = [self textColor];
    if (color == nil)
    {
        color = [self defaultTextColor];
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, color, NSForegroundColorAttributeName, nil];
}


- (NSDictionary *)markerTextAttributes
{
    NSFont  *font;
    NSColor *color;
    
    font = [self font];    
    if (font == nil)
    {
        font = [self defaultFont];
    }
    
    color = [self alternateTextColor];
    if (color == nil)
    {
        color = [self defaultAlternateTextColor];
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, color, NSForegroundColorAttributeName, nil];
}


- (NSDictionary *)errorTextAttributes
{
    NSFont  *font;
    NSColor *color;

    font = [self font];
    if (font == nil)
    {
        font = [self defaultFont];
    }

    color = [self errorTextColor];
    if (color == nil)
    {
        color = [self defaultErrorTextColor];
    }

    return [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, color, NSForegroundColorAttributeName, nil];
}


- (CGFloat)requiredThickness
{
    NSUInteger			lineCount, digits, i;
    NSMutableString     *sampleString;
    NSSize              stringSize;
    
    lineCount = [[self lineIndices] count];
    digits = 1;
    if (lineCount > 0)
    {
        digits = (NSUInteger)log10(lineCount) + 1;
    }
	sampleString = [NSMutableString string];
    for (i = 0; i < digits; i++)
    {
        // Use "8" since it is one of the fatter numbers. Anything but "1"
        // will probably be ok here. I could be pedantic and actually find the fattest
		// number for the current font but nah.
        [sampleString appendString:@"8"];
    }
    
    stringSize = [sampleString sizeWithAttributes:[self textAttributes]];

	// Round up the value. There is a bug on 10.4 where the display gets all
    // wonky when scrolling if you don't return an integral value here.
    return ceil(MAX(_minimumWidth, stringSize.width + RULER_MARGIN * 2));
}


- (void)drawRect:(NSRect)dirtyRect
{
    id			view;
	NSRect		bounds;
    NSRect visibleRect;

	bounds = [self bounds];
    view = [self clientView];
    visibleRect = [[[self scrollView] contentView] bounds];

	if (_backgroundColor != nil) {
		[_backgroundColor set];
    } else {
        [[self defaultBackgroundColor] set];
    }
    NSRectFill(bounds);
    
    [[NSColor lightGrayColor] set];
    NSBezierPath *dottedLine = [NSBezierPath bezierPathWithRect:NSMakeRect(bounds.size.width, 0, 0, bounds.size.height)];
    CGFloat dash[2];
    dash[0] = 1.0f;
    dash[1] = 2.0f;
    [dottedLine setLineDash:dash count:2 phase:visibleRect.origin.y];
    [dottedLine stroke];
	
    NSLayoutManager			*layoutManager;
    NSTextContainer			*container;
    NSRange					range, glyphRange;
    NSString				*text, *labelText;
    NSUInteger				index, line, count, startingLine, stringLength;
    NSRect                  rect;
    CGFloat					ypos, yinset;
    NSDictionary			*textAttributes, *currentTextAttributes;
    NSSize					stringSize;
    NSMutableArray			*lines;
    NSTextContainer         *drawingTextContainer;
    NSTextStorage           *drawingTextStorage;
    NSLayoutManager         *drawingLayoutManager;
    NSSet                   *linesWithBreakpoints;
    NSArray                 *linesWithErrors;

    layoutManager = [view layoutManager];
    container = [view textContainer];
    text = [view string];
    stringLength = [text length];
    
    yinset = [view textContainerInset].height;

    drawingTextStorage = [[NSTextStorage alloc] init];
    drawingLayoutManager = [[NSLayoutManager alloc] init];
    [layoutManager setTypesetterBehavior:NSTypesetterLatestBehavior];
    drawingTextContainer = [[NSTextContainer alloc] initWithContainerSize:bounds.size];
    [drawingLayoutManager addTextContainer:drawingTextContainer];
    [drawingTextStorage addLayoutManager:drawingLayoutManager];
    [drawingTextContainer setLineFragmentPadding:0.0];

    textAttributes = [self textAttributes];
    
    lines = [self lineIndices];
    linesWithBreakpoints = [_breakpointDelegate breakpointsForFile:nil];

    linesWithErrors = [[self.syntaxErrors filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"hideWarning == %@", @(NO)]] valueForKeyPath:@"@distinctUnionOfObjects.line"];
    startingLine = _startingLineNumber + 1;

    // Clear all buttons
    NSMutableArray* buttons = [NSMutableArray array];
    for (NSView* subview in [self subviews])
    {
        if ([subview isKindOfClass:[NSButton class]])
        {
            [buttons addObject:subview];
        }
    }
    for (NSButton* button in buttons)
    {
        [button removeFromSuperview];
    }


    // Find the characters that are currently visible
    glyphRange = [layoutManager glyphRangeForBoundingRect:visibleRect inTextContainer:container];
    range = [layoutManager characterRangeForGlyphRange:glyphRange actualGlyphRange:NULL];
    
    // Fudge the range a tad in case there is an extra new line at end.
    // It doesn't show up in the glyphs so would not be accounted for.
    range.length++;
    
    count = [lines count];
    
    for (line = [self lineNumberForCharacterIndex:range.location inText:text]; line < count; line++)
    {
        index = [[lines objectAtIndex:line] unsignedIntegerValue];
        
        if (NSLocationInRange(index, range))
        {
            NSUInteger glyphIdx = [layoutManager glyphIndexForCharacterAtIndex:index];
            if (index < stringLength)
                rect = [layoutManager lineFragmentRectForGlyphAtIndex:glyphIdx effectiveRange:NULL];
            else
                rect = [layoutManager boundingRectForGlyphRange:NSMakeRange(glyphIdx, 0) inTextContainer:container];

            // Note that the ruler view is only as tall as the visible
            // portion. Need to compensate for the clipview's coordinates.
            ypos = yinset + NSMinY(rect) - NSMinY(visibleRect);

            currentTextAttributes = textAttributes;

            NSNumber *lineNum = [NSNumber numberWithInteger:line+1];
            if ([linesWithBreakpoints containsObject:lineNum]) {
                NSRect wholeLineRect;
                
                wholeLineRect.size.width = bounds.size.width;
                wholeLineRect.size.height = rect.size.height;
                wholeLineRect.origin.x = 0;
                wholeLineRect.origin.y = ypos;
                [self drawMarkerInRect:wholeLineRect ofLine:lineNum];
                currentTextAttributes = [self markerTextAttributes];
            }

            if (self.showsWarnings && [linesWithErrors containsObject:@(line+1)]) {
                NSRect wholeLineRect;

                wholeLineRect.size.width = bounds.size.width;
                wholeLineRect.size.height = rect.size.height;
                wholeLineRect.origin.x = 0;
                wholeLineRect.origin.y = ypos;
                [self drawErrorsInRect:wholeLineRect ofLine:lineNum];
                currentTextAttributes = [self errorTextAttributes];
            }

            // Line numbers are internally stored starting at 0
            labelText = [NSString stringWithFormat:@"%jd", (intmax_t)line + startingLine];
            
            [drawingTextStorage beginEditing];
            [[drawingTextStorage mutableString] setString:labelText];
            [drawingTextStorage setAttributes:currentTextAttributes range:NSMakeRange(0, [labelText length])];
            [drawingTextStorage endEditing];
            
            NSRange glyphRange = [drawingLayoutManager glyphRangeForTextContainer:drawingTextContainer];
            stringSize = [drawingLayoutManager usedRectForTextContainer:drawingTextContainer].size;
            
            NSPoint drawOrigin = NSMakePoint(NSWidth(bounds) - stringSize.width - RULER_MARGIN, ypos + (NSHeight(rect) - stringSize.height) / 2.0);
            // Draw string flush right, centered vertically within the line
            [drawingLayoutManager drawGlyphsForGlyphRange:glyphRange atPoint:drawOrigin];
        }
        if (index > NSMaxRange(range))
        {
            break;
        }
    }
}


- (NSUInteger)lineNumberForLocation:(CGFloat)location
{
	NSUInteger		line, count, index, rectCount, i;
	NSRectArray		rects;
	NSRect			visibleRect;
	NSLayoutManager	*layoutManager;
	NSTextContainer	*container;
	NSRange			nullRange;
	NSMutableArray	*lines;
	id				view;
    
	view = [self clientView];
	visibleRect = [[[self scrollView] contentView] bounds];
	
	lines = [self lineIndices];
    
	location += NSMinY(visibleRect);
	
    nullRange = NSMakeRange(NSNotFound, 0);
    layoutManager = [view layoutManager];
    container = [view textContainer];
    count = [lines count];
    
    for (line = 0; line < count; line++)
    {
        index = [[lines objectAtIndex:line] unsignedIntegerValue];
        
        rects = [layoutManager rectArrayForCharacterRange:NSMakeRange(index, 0)
                             withinSelectedCharacterRange:nullRange
                                          inTextContainer:container
                                                rectCount:&rectCount];
        
        for (i = 0; i < rectCount; i++)
        {
            if ((location >= NSMinY(rects[i])) && (location < NSMaxY(rects[i])))
            {
                return line;
            }
        }
    }
	return NSNotFound;
}


- (void)drawMarkerInRect:(NSRect)rect ofLine:(NSNumber*)line
{
    NSRect centeredRect, alignedRect;
    CGFloat height;
    
    height = [imgBreakpoint0 size].height;
    centeredRect = rect;
    centeredRect.origin.y += (rect.size.height - height) / 2.0;
    centeredRect.origin.x += RULER_MARGIN;
    centeredRect.size.height = height;
    centeredRect.size.width -= RULER_MARGIN;
    
    alignedRect = [self backingAlignedRect:centeredRect options:NSAlignAllEdgesOutward];
    
    NSDrawThreePartImage(alignedRect, imgBreakpoint0, imgBreakpoint1, imgBreakpoint2, NO, NSCompositeSourceOver, 1, YES);
}

/*
    @todo: this is not very DRY -- it repeats almost exactly the existing function in
    `SMLSyntaxColoring.m`, which has to be left in place to display errors if the
    line number view isn't being used.
 */
- (void)drawErrorsInRect:(NSRect)rect ofLine:(NSNumber*)line
{
    // Add a button
    NSButton* warningButton = [[NSButton alloc] init];

    [warningButton setButtonType:NSMomentaryChangeButton];
    [warningButton setBezelStyle:NSRegularSquareBezelStyle];
    [warningButton setBordered:NO];
    [warningButton setImagePosition:NSImageOnly];
    [warningButton setTag:[line integerValue]];
    [warningButton setTarget:self];
    [warningButton setAction:@selector(pressedWarningBtn:)];
    [warningButton setTranslatesAutoresizingMaskIntoConstraints:NO];

    // There may be multiple errors for this line, so find the one with the highest warningStyle.
    MGSErrorType style = [[[self.syntaxErrors filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(line == %@) AND (hideWarning == %@)", line, @(NO)]] valueForKeyPath:@"@max.warningStyle"] integerValue];
    [warningButton setImage:[SMLSyntaxError imageForWarningStyle:style]];

    [self addSubview:warningButton];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-4-[warningButton]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(warningButton)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:warningButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:rect.origin.y-3]];
}

- (void)pressedWarningBtn:(id) sender
{
    int line = (int)[sender tag];

    // Fetch errors to display
    NSMutableArray* errorsOnLine = [NSMutableArray array];
    for (SMLSyntaxError* err in self.syntaxErrors)
    {
        if (err.line == line)
        {
            [errorsOnLine addObject:err.description];
        }
    }

    if (errorsOnLine.count == 0) return;

    [SMLErrorPopOver showErrorDescriptions:errorsOnLine relativeToView:sender];
}



- (void)mouseDown:(NSEvent *)theEvent
{
    NSPoint					location;
    NSUInteger				line;

    if (!_breakpointDelegate) return;

    location = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    line = [self lineNumberForLocation:location.y];
    
    if (line != NSNotFound)
    {
        [_breakpointDelegate toggleBreakpointForFile:nil onLine:(int)line+1];
        [self setNeedsDisplay:YES];
    }
}


@end
