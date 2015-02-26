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
#import "MGSSyntaxErrorController.h"
#import "MGSFragariaPrivate.h"


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


@implementation MGSLineNumberView {
    NSUInteger _mouseDownLineTracking;
    NSRect     _mouseDownRectTracking;
    NSMutableDictionary *_markerImages;
    NSSize _markerImagesSize;
}

@synthesize markerColor = _markerColor;


- (id)initWithScrollView:(NSScrollView *)aScrollView
{
    return [self initWithScrollView:aScrollView fragaria:nil];
}

- (id)initWithScrollView:(NSScrollView *)aScrollView fragaria:(MGSFragaria *)fragaria
{
    if ((self = [super initWithScrollView:aScrollView orientation:NSVerticalRuler]) != nil)
    {
        _lineIndices = [[NSMutableArray alloc] init];
        _startingLineNumber = 1;
        _markerImagesSize = NSMakeSize(0,0);
        _markerImages = [[NSMutableDictionary alloc] init];
        _fragaria = fragaria;
        _drawsLineNumbers = YES;
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


- (NSColor *)defaultMarkerColor
{
    return [NSColor colorWithCalibratedRed:254.0/255.0 green:199.0/255.0 blue:249.0/255.0 alpha:1];
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

- (void)setDrawsLineNumbers:(BOOL *)drawsLineNumbers {
    _drawsLineNumbers = drawsLineNumbers;
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


- (void)setMarkerColor:(NSColor *)markerColor {
    _markerColor = markerColor;
    [self setNeedsDisplay:YES];
}

- (NSColor *)markerColor
{
    return _markerColor ? _markerColor : [self defaultMarkerColor];
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


// Forces recalculation of line indices starting from the given index
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
    NSRange					range, glyphRange;
    NSString				*labelText;
    NSUInteger				index, line;
    NSRect                  wholeLineRect;
    CGFloat					ypos, yinset;
    NSDictionary			*textAttributes, *currentTextAttributes;
    NSMutableArray			*lines;
    NSAttributedString      *drawingAttributedString;
    CGContextRef            drawingContext;
    NSSet                   *linesWithBreakpoints;

    layoutManager = [view layoutManager];

    yinset = [view textContainerInset].height;

    textAttributes = [self textAttributes];
    drawingContext = [[NSGraphicsContext currentContext] graphicsPort];
    CGAffineTransform flipTransform = {1, 0, 0, -1, 0, 0};
    CGContextSetTextMatrix(drawingContext, flipTransform);
    
    lines = [self lineIndices];
	
	if (_breakpointDelegate) {
		
		if ([_breakpointDelegate respondsToSelector:@selector(breakpointsForView:)]) {
			linesWithBreakpoints = [_breakpointDelegate breakpointsForView:self.fragaria];
		} else if ([_breakpointDelegate respondsToSelector:@selector(breakpointsForFile:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
			linesWithBreakpoints = [_breakpointDelegate breakpointsForFile:nil];
#pragma clang diagnostic pop
		}
	}

    // Find the characters that are currently visible, make a range,  then fudge the range a tad in case
    // there is an extra new line at end. It doesn't show up in the glyphs so would not be accounted for.
    glyphRange = [layoutManager glyphRangeForBoundingRect:visibleRect inTextContainer:[view textContainer]];
    range = [layoutManager characterRangeForGlyphRange:glyphRange actualGlyphRange:NULL];
    range.length++;
    
    for (line = [self lineNumberForCharacterIndex:range.location inText:[view string]]; line < [lines count]; line++)
    {
        index = [[lines objectAtIndex:line] unsignedIntegerValue];
        
        if (NSLocationInRange(index, range))
        {
            NSNumber *lineNum = [NSNumber numberWithInteger:line];    // zero-based line number, Fragaria's count.
            wholeLineRect = [self wholeLineRectForLine:lineNum];

            // Note that the ruler view is only as tall as the visible
            // portion. Need to compensate for the clipview's coordinates.
            ypos = wholeLineRect.origin.y;

            currentTextAttributes = textAttributes;

            if ([linesWithBreakpoints containsObject:@(line + 1)]) {
                [self drawMarkerInRect:wholeLineRect ofLine:lineNum];
                currentTextAttributes = [self markerTextAttributes];
            }

            if (self.drawsLineNumbers)
            {
                // Draw line numbers first so that error images won't be buried underneath long line numbers.
                // Line numbers are internally stored starting at 0
                labelText = [NSString stringWithFormat:@"%jd", (intmax_t)line + _startingLineNumber];
                drawingAttributedString = [[NSAttributedString alloc] initWithString:labelText attributes:currentTextAttributes];

                CGFloat descent, leading;
                CTLineRef line;
                line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)drawingAttributedString);
                CGFloat width = CTLineGetTypographicBounds(line, NULL, &descent, &leading);
                
                CGFloat xpos = NSWidth(bounds) - width - RULER_MARGIN;
                CGFloat baselinepos = ypos + NSHeight(wholeLineRect) - floor(descent + 0.5) - floor(leading+0.5);
                CGContextSetTextPosition(drawingContext, xpos, baselinepos);
                CTLineDraw(line, drawingContext);
            }

            if (_showsWarnings) {
                [self drawErrorsInRect:wholeLineRect ofLine:lineNum];
            }
        }
        if (index > NSMaxRange(range))
        {
            break;
        }
    }
}

/// @param line uses zero-based indexing.
- (NSRect)wholeLineRectForLine:(NSNumber*)line
{
    id			      view;
    NSRect            visibleRect;
    NSLayoutManager	  *layoutManager;
    NSTextContainer	  *container;
    NSRange           range, glyphRange;
    NSUInteger        index, stringLength;
    NSRect            rect;
    NSMutableArray    *lines;
    NSRect            wholeLineRect = NSMakeRect(0.0,0.0,0.0,0.0);

    view = [self clientView];
    layoutManager = [view layoutManager];
    container = [view textContainer];

    visibleRect = [[[self scrollView] contentView] bounds];
    stringLength = [[view string] length];

    lines = [self lineIndices];

    // Find the characters that are currently visible
    glyphRange = [layoutManager glyphRangeForBoundingRect:visibleRect inTextContainer:container];
    range = [layoutManager characterRangeForGlyphRange:glyphRange actualGlyphRange:NULL];

    // Fudge the range a tad in case there is an extra new line at end.
    // It doesn't show up in the glyphs so would not be accounted for.
    range.length++;

    index = [[lines objectAtIndex:[line unsignedIntegerValue]] unsignedIntegerValue];

    if (NSLocationInRange(index, range))
    {
        NSUInteger glyphIdx = [layoutManager glyphIndexForCharacterAtIndex:index];
        if (index < stringLength)
            rect = [layoutManager lineFragmentRectForGlyphAtIndex:glyphIdx effectiveRange:NULL];
        else
            rect = [layoutManager boundingRectForGlyphRange:NSMakeRange(glyphIdx, 0) inTextContainer:container];

        // Note that the ruler view is only as tall as the visible
        // portion. Need to compensate for the clipview's coordinates.
        CGFloat ypos = [view textContainerInset].height + NSMinY(rect) - NSMinY(visibleRect);

        wholeLineRect.size.width = self.bounds.size.width;
        wholeLineRect.size.height = rect.size.height;
        wholeLineRect.origin.x = 0;
        wholeLineRect.origin.y = ypos;
    }
    return wholeLineRect;
}


/// @returns zero-based indexing.
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
            if (location < NSMinY(rects[i]) && line)
                return line-1;
            else if (location < NSMaxY(rects[i]))
                return line;
        }
    }
	return NSNotFound;
}


/// @param line uses zero-based indexing.
- (void)drawMarkerInRect:(NSRect)rect ofLine:(NSNumber*)line
{
    NSRect centeredRect, alignedRect;
    CGFloat height;
    
    height = rect.size.height;
    centeredRect = rect;
    centeredRect.origin.y += (rect.size.height - height) / 2.0;
    centeredRect.origin.x += RULER_MARGIN;
    centeredRect.size.height = height;
    centeredRect.size.width -= RULER_MARGIN;
    
    alignedRect = [self backingAlignedRect:centeredRect options:NSAlignAllEdgesOutward];

    NSImage *defaultImage = [self defaultMarkerImageWithSize:centeredRect.size color:self.markerColor];
    [defaultImage drawInRect:alignedRect fromRect:NSZeroRect operation:NSCompositeSourceAtop fraction:1.0 respectFlipped:YES hints:nil];
}


/// @param line uses zero-based indexing.
- (void)drawErrorsInRect:(NSRect)rect ofLine:(NSNumber*)line
{
    SMLSyntaxError *error = [self.fragaria.syntaxErrorController errorForLine:[line integerValue] + 1]; // errors are one-based indexes.

    [error.warningImage drawInRect:[self errorImageRectOfRect:rect ofLine:line] fromRect:NSZeroRect operation:NSCompositeSourceAtop fraction:1.0 respectFlipped:YES hints:nil];
}


/// @param line uses zero-based indexing.
- (NSRect)errorImageRectOfRect:(NSRect)rect ofLine:(NSNumber*)line
{
    NSRect centeredRect;
    CGFloat height;

    SMLSyntaxError *error = [self.fragaria.syntaxErrorController errorForLine:[line integerValue] + 1]; // errors are one-based indexes.
    NSImage *sourceImage = error.warningImage;

    height = rect.size.height;
    centeredRect = rect;
    centeredRect.origin.y += (rect.size.height - height) / 2.0;
    centeredRect.origin.x += RULER_MARGIN;
    centeredRect.size.height = height;
    centeredRect.size.width = sourceImage.size.width / (sourceImage.size.height / height);

    return [self backingAlignedRect:centeredRect options:NSAlignAllEdgesOutward];
}


- (void)mouseDown:(NSEvent *)theEvent
{
    NSPoint location = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    NSUInteger line = [self lineNumberForLocation:location.y];
    NSRect imageRect;
    BOOL errorHit = NO;

    if (line != NSNotFound)
    {
        _mouseDownLineTracking = line + 1; // now has 1-based index.
        _mouseDownRectTracking = NSMakeRect(0.0, 0.0, 0.0, 0.0);

        if (self.showsWarnings && [self.fragaria.syntaxErrorController.linesWithErrors containsObject:@(_mouseDownLineTracking)])
        {
            imageRect = [self errorImageRectOfRect:[self wholeLineRectForLine:@(line)] ofLine:@(line)];

            if (CGRectContainsPoint(imageRect, location))//(location.x <= imageRect.origin.x + imageRect.size.width)
            {
                errorHit = YES;
            }
        }

        if (errorHit)
        {
            _mouseDownRectTracking = imageRect;
        }
        else
        {
            [self handleBreakpoint];
        }
    }
}

- (void)mouseUp:(NSEvent *)theEvent
{
    NSPoint location = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    NSUInteger line = [self lineNumberForLocation:location.y]; // method returns 0-based index.

    if ( (line != _mouseDownLineTracking -1) || (location.x > self.frame.size.width) )
    {
        [self handleBreakpoint];
    }
    else
    {
        if (self.showsWarnings && [self.fragaria.syntaxErrorController.linesWithErrors containsObject:@(_mouseDownLineTracking)])
        {
            if (CGRectContainsPoint(_mouseDownRectTracking, location))
            {
                [self.fragaria.syntaxErrorController showErrorsForLine:_mouseDownLineTracking relativeToRect:_mouseDownRectTracking ofView:self];
            }
        }
    }
}

- (void)handleBreakpoint
{
    if ([_breakpointDelegate respondsToSelector:@selector(toggleBreakpointForView:onLine:)])
    {
        [_breakpointDelegate toggleBreakpointForView:self.fragaria onLine:(int)_mouseDownLineTracking];
    }
    else if ([_breakpointDelegate respondsToSelector:@selector(toggleBreakpointForFile:onLine:)])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [_breakpointDelegate toggleBreakpointForFile:nil onLine:(int)_mouseDownLineTracking];
#pragma clang diagnostic pop
    }

    [self setNeedsDisplay:YES];
}


/* Adapted from Noodlekit (github.com/MrNoodle/NoodleKit) by Paul Kim. */
- (NSImage*) defaultMarkerImageWithSize:(NSSize)size color:(NSColor*)colorBase  {
    NSImage *markerImage;
    
    if (NSEqualSizes(size, _markerImagesSize)) {
        markerImage = _markerImages[[colorBase description]];
        if (markerImage) {
            return markerImage;
        }
    } else {
        [_markerImages removeAllObjects];
    }

    markerImage = [NSImage.alloc initWithSize:size];
    NSCustomImageRep *rep = [NSCustomImageRep.alloc initWithSize:size flipped:NO drawingHandler:^BOOL(NSRect dstRect) {
        NSRect rect;
        NSBezierPath *path;
        CGFloat lineWidth = (dstRect.size.height < 12.0 ? 1 : (dstRect.size.height / 12.0));
        CGFloat cornerRadius = 3.0;
        
        rect = NSMakeRect(lineWidth/2.0, lineWidth/2.0, dstRect.size.width-lineWidth, dstRect.size.height-lineWidth);
        NSPoint tip = NSMakePoint(NSMaxX(rect), NSMinY(rect) + NSHeight(rect)/2);
        CGFloat arrowEndX = NSMaxX(rect)-NSHeight(rect)/2.6;
        
        path = [NSBezierPath bezierPath];
        [path moveToPoint:tip];
        [path lineToPoint:NSMakePoint(arrowEndX, NSMaxY(rect))];
        [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(rect) + cornerRadius, NSMaxY(rect) - cornerRadius) radius:cornerRadius startAngle:90 endAngle:180];
        [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(rect) + cornerRadius, NSMinY(rect) + cornerRadius) radius:cornerRadius startAngle:180 endAngle:270];
        [path lineToPoint:NSMakePoint(arrowEndX, NSMinY(rect))];
        [path closePath];
        
        NSColor *colorFill1 = [colorBase colorUsingColorSpaceName:NSDeviceRGBColorSpace];
        CGFloat gradientTo = colorFill1.brightnessComponent - 0.1;
        NSColor *colorFill2 = [NSColor colorWithCalibratedHue:colorBase.hueComponent saturation:colorBase.saturationComponent brightness:gradientTo alpha:1];
        
        CGFloat strokeTo = colorFill2.brightnessComponent - 0.35;
        NSColor *colorStroke = [NSColor colorWithCalibratedHue:colorBase.hueComponent saturation:colorBase.saturationComponent brightness:strokeTo alpha:1];
        
        NSGradient *fill = [[NSGradient alloc] initWithColors:@[colorFill1, colorFill2]];
        [fill drawInBezierPath:path angle:-90.0];
        
        [colorStroke set];
        [path setLineWidth:lineWidth];
        [path stroke];
        return YES;
    }];
    
    [rep setSize:size];
    [markerImage addRepresentation:rep];
    [markerImage setName:[colorBase description]];
    [_markerImages setValue:markerImage forKey:[colorBase description]];
    _markerImagesSize = size;
    return markerImage;
}


@end
