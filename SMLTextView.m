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

#import "MGSFragaria.h"
#import "MGSFragariaFramework.h"
#import "SMLAutoCompleteDelegate.h"
#import "SMLTextView+MGSTextActions.h"


static BOOL CharacterIsBrace(unichar c)
{
    NSCharacterSet *braces = [NSCharacterSet characterSetWithCharactersInString:@"()[]{}<>"];
    return [braces characterIsMember:c];
}


static BOOL CharacterIsClosingBrace(unichar c)
{
    NSCharacterSet *braces = [NSCharacterSet characterSetWithCharactersInString:@")]}>"];
    return [braces characterIsMember:c];
}


static unichar OpeningBraceForClosingBrace(unichar c)
{
    switch (c) {
        case ')': return '(';
        case ']': return '[';
        case '}': return '{';
        case '>': return '<';
    }
    return 0;
}


static unichar ClosingBraceForOpeningBrace(unichar c)
{
    switch (c) {
        case '(': return ')';
        case '[': return ']';
        case '{': return '}';
        case '<': return '>';
    }
    return 0;
}


// class extension
@interface SMLTextView()

@property (strong) NSColor *pageGuideColour;

@end


static void *LineHighlightingPrefChanged = &LineHighlightingPrefChanged;


@implementation SMLTextView

@synthesize fragaria, pageGuideColour, lineWrap;

#pragma mark -
#pragma mark Instance methods
/*
 
 - initWithFrame:
 
 */
- (id)initWithFrame:(NSRect)frame
{
	if ((self = [super initWithFrame:frame])) {
		SMLLayoutManager *layoutManager = [[SMLLayoutManager alloc] init];
		[[self textContainer] replaceLayoutManager:layoutManager];
		
		[self setDefaults];
        
        _inspectedCharacterIndexes = [[NSMutableIndexSet alloc] initWithIndexesInRange:NSMakeRange(0,0)];
        
        // set initial line wrapping
        lineWrap = YES;
        isDragging = NO;
        [self updateLineWrap];
	}
	return self;
}


#pragma mark -
#pragma mark Accessors
/*
 
 - lineHeight
 
 */
- (NSInteger)lineHeight
{
    return lineHeight;
}


/*
 
 - setDefaults
 
 */
- (void)setDefaults
{

	[self setTabWidth];
	
	[self setVerticallyResizable:YES];
	[self setMaxSize:NSMakeSize(FLT_MAX, FLT_MAX)];
	[self setAutoresizingMask:NSViewWidthSizable];
	[self setAllowsUndo:YES];
    if ([self respondsToSelector:@selector(setUsesFindBar:)]) {
        [self setUsesFindBar:YES];
        [self setIncrementalSearchingEnabled:NO];
    } else {
        [self setUsesFindPanel:YES];
    }
	[self setAllowsDocumentBackgroundColorChange:NO];
	[self setRichText:NO];
	[self setImportsGraphics:NO];
	[self setUsesFontPanel:NO];
	
	[self setContinuousSpellCheckingEnabled:[[SMLDefaults valueForKey:MGSFragariaPrefsAutoSpellCheck] boolValue]];
	[self setGrammarCheckingEnabled:[[SMLDefaults valueForKey:MGSFragariaPrefsAutoGrammarCheck] boolValue]];
	
	[self setSmartInsertDeleteEnabled:[[SMLDefaults valueForKey:MGSFragariaPrefsSmartInsertDelete] boolValue]];
	[self setAutomaticLinkDetectionEnabled:[[SMLDefaults valueForKey:MGSFragariaPrefsAutomaticLinkDetection] boolValue]];
	[self setAutomaticQuoteSubstitutionEnabled:[[SMLDefaults valueForKey:MGSFragariaPrefsAutomaticQuoteSubstitution] boolValue]];
	
	[self setTextDefaults];
	
	[self setAutomaticDataDetectionEnabled:YES];
	[self setAutomaticTextReplacementEnabled:YES];
	
	[self setPageGuideValues];
	
	NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:[self frame] options:(NSTrackingMouseEnteredAndExited | NSTrackingActiveWhenFirstResponder) owner:self userInfo:nil];
	[self addTrackingArea:trackingArea];
  
	NSUserDefaultsController *defaultsController = [NSUserDefaultsController sharedUserDefaultsController];
	[defaultsController addObserver:self forKeyPath:@"values.FragariaTextFont" options:NSKeyValueObservingOptionNew context:@"TextFontChanged"];
	[defaultsController addObserver:self forKeyPath:@"values.FragariaTextColourWell" options:NSKeyValueObservingOptionNew context:@"TextColourChanged"];
	[defaultsController addObserver:self forKeyPath:@"values.FragariaBackgroundColourWell" options:NSKeyValueObservingOptionNew context:@"BackgroundColourChanged"];
	[defaultsController addObserver:self forKeyPath:@"values.FragariaSmartInsertDelete" options:NSKeyValueObservingOptionNew context:@"SmartInsertDeleteChanged"];
	[defaultsController addObserver:self forKeyPath:@"values.FragariaTabWidth" options:NSKeyValueObservingOptionNew context:@"TabWidthChanged"];
	[defaultsController addObserver:self forKeyPath:@"values.FragariaShowPageGuide" options:NSKeyValueObservingOptionNew context:@"PageGuideChanged"];
	[defaultsController addObserver:self forKeyPath:@"values.FragariaShowPageGuideAtColumn" options:NSKeyValueObservingOptionNew context:@"PageGuideChanged"];
	[defaultsController addObserver:self forKeyPath:@"values.FragariaSmartInsertDelete" options:NSKeyValueObservingOptionNew context:@"SmartInsertDeleteChanged"];
    [defaultsController addObserver:self forKeyPath:@"values.FragariaHighlightCurrentLine" options:0 context:LineHighlightingPrefChanged];
    [defaultsController addObserver:self forKeyPath:@"values.FragariaHighlightLineColourWell" options:NSKeyValueObservingOptionInitial context:LineHighlightingPrefChanged];
	
	lineHeight = [[[self textContainer] layoutManager] defaultLineHeightForFont:[NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:MGSFragariaPrefsTextFont]]];
}

/*
 
 - setTextDefaults
 
 */
- (void)setTextDefaults
{
	[self setFont:[NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:MGSFragariaPrefsTextFont]]];
	[self setTextColor:[NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:MGSFragariaPrefsTextColourWell]]];
	[self setInsertionPointColor:[NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:MGSFragariaPrefsTextColourWell]]];
	[self setBackgroundColor:[NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:MGSFragariaPrefsBackgroundColourWell]]];
}


#pragma mark -
#pragma mark Copy and paste

/*
 
 - paste
 
 */
-(void)paste:(id)sender
{
    // let super paste
    [super paste:sender];

    // add the NSTextView  to the info dict
    NSDictionary *info = @{@"NSTextView": self};

    // send paste notification
    NSNotification *note = [NSNotification notificationWithName:@"MGSTextDidPasteNotification" object:self userInfo:info];
    [[NSNotificationCenter defaultCenter] postNotification:note];
    
    // inform delegate of Fragaria paste
    if ([self.delegate respondsToSelector:@selector(mgsTextDidPaste:)]) {
        [(id)self.delegate mgsTextDidPaste:note];
    }
}

#pragma mark -
#pragma mark KVO

/*
 
 - observeValueForKeyPath:ofObject:change:context:
 
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    BOOL boolValue = NO;
    NSColor *colorVal;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (context == LineHighlightingPrefChanged) {
        boolValue = [defaults boolForKey:MGSFragariaPrefsHighlightCurrentLine];
        [self setHighlightCurrentLine:boolValue];
        colorVal = [NSUnarchiver unarchiveObjectWithData:[defaults objectForKey:MGSFragariaPrefsHighlightLineColourWell]];
        [self setCurrentLineHighlightColor:colorVal];
    } else if ([(__bridge NSString *)context isEqualToString:@"TextFontChanged"]) {
		[self setFont:[NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:MGSFragariaPrefsTextFont]]];
		lineHeight = [[[self textContainer] layoutManager] defaultLineHeightForFont:[NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:MGSFragariaPrefsTextFont]]];
		[self setPageGuideValues];
	} else if ([(__bridge NSString *)context isEqualToString:@"TextColourChanged"]) {
		[self setTextColor:[NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:MGSFragariaPrefsTextColourWell]]];
		[self setInsertionPointColor:[NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:MGSFragariaPrefsTextColourWell]]];
		[self setPageGuideValues];
	} else if ([(__bridge NSString *)context isEqualToString:@"BackgroundColourChanged"]) {
		[self setBackgroundColor:[NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:MGSFragariaPrefsBackgroundColourWell]]];
	} else if ([(__bridge NSString *)context isEqualToString:@"SmartInsertDeleteChanged"]) {
		[self setSmartInsertDeleteEnabled:[[SMLDefaults valueForKey:MGSFragariaPrefsSmartInsertDelete] boolValue]];
	} else if ([(__bridge NSString *)context isEqualToString:@"TabWidthChanged"]) {
		[self setTabWidth];
	} else if ([(__bridge NSString *)context isEqualToString:@"PageGuideChanged"]) {
		[self setPageGuideValues];
    } else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}


#pragma mark -
#pragma mark Drawing
/*
 
 - isOpaque
 
 */
- (BOOL)isOpaque
{
	return YES;
}

/*
 
 - drawRect:
 
 */
- (void)drawRect:(NSRect)rect
{
	[super drawRect:rect];
	
	if (showPageGuide == YES) {
		NSRect bounds = [self bounds]; 
		if ([self needsToDrawRect:NSMakeRect(pageGuideX, 0, 1, bounds.size.height)] == YES) { // So that it doesn't draw the line if only e.g. the cursor updates
			[self.pageGuideColour set];
			[NSBezierPath strokeRect:NSMakeRect(pageGuideX, 0, 0, bounds.size.height)];
		}
	}
}


#pragma mark - Line Highlighting


- (void)setHighlightCurrentLine:(BOOL)highlightCurrentLine
{
    [self setNeedsDisplayInRect:currentLineRect];
    _highlightCurrentLine = highlightCurrentLine;
    currentLineRect = [self lineHighlightingRect];
    [self setNeedsDisplayInRect:currentLineRect];
}


- (void)drawViewBackgroundInRect:(NSRect)rect
{
    [super drawViewBackgroundInRect:rect];
    if ([self needsToDrawRect:currentLineRect]) {
        [_currentLineHighlightColor set];
        [NSBezierPath fillRect:currentLineRect];
    }
}


- (NSRect)lineHighlightingRect
{
    NSMutableString *ms;
    NSRange selRange, lineRange, multipleLineRange;
    NSRect lineRect;
    
    if (!_highlightCurrentLine) return NSZeroRect;
    
    selRange = [self selectedRange];
    ms = [[self textStorage] mutableString];
    multipleLineRange = [ms lineRangeForRange:selRange];
    lineRange = [ms lineRangeForRange:NSMakeRange(selRange.location, 0)];
    if (NSEqualRanges(lineRange, multipleLineRange)) {
        lineRange = [[self layoutManager] glyphRangeForCharacterRange:lineRange actualCharacterRange:NULL];
        lineRect = [[self layoutManager] boundingRectForGlyphRange:lineRange inTextContainer:[self textContainer]];
        lineRect.origin.x = 0;
        lineRect.size.width = [self bounds].size.width;
        return lineRect;
    }
    return NSZeroRect;
}


- (void)setSelectedRanges:(NSArray *)selectedRanges
{
    [self setNeedsDisplayInRect:currentLineRect];
    [super setSelectedRanges:selectedRanges];
    currentLineRect = [self lineHighlightingRect];
    [self setNeedsDisplayInRect:currentLineRect];
}


- (void)setSelectedRange:(NSRange)selectedRange
{
    [self setNeedsDisplayInRect:currentLineRect];
    [super setSelectedRange:selectedRange];
    currentLineRect = [self lineHighlightingRect];
    [self setNeedsDisplayInRect:currentLineRect];
}


- (void)setSelectedRange:(NSRange)charRange affinity:(NSSelectionAffinity)affinity stillSelecting:(BOOL)stillSelectingFlag
{
    [self setNeedsDisplayInRect:currentLineRect];
    [super setSelectedRange:charRange affinity:affinity stillSelecting:stillSelectingFlag];
    currentLineRect = [self lineHighlightingRect];
    [self setNeedsDisplayInRect:currentLineRect];
}


- (void)setSelectedRanges:(NSArray *)ranges affinity:(NSSelectionAffinity)affinity stillSelecting:(BOOL)stillSelectingFlag
{
    [self setNeedsDisplayInRect:currentLineRect];
    [super setSelectedRanges:ranges affinity:affinity stillSelecting:stillSelectingFlag];
    currentLineRect = [self lineHighlightingRect];
    [self setNeedsDisplayInRect:currentLineRect];
}


- (void)setFrame:(NSRect)bounds
{
    [self setNeedsDisplayInRect:currentLineRect];
    [super setFrame:bounds];
    currentLineRect = [self lineHighlightingRect];
    [self setNeedsDisplayInRect:currentLineRect];
}


#pragma mark -
#pragma mark Mouse event handling


- (void)flagsChanged:(NSEvent *)theEvent
{
    [super flagsChanged:theEvent];
    
    if (([theEvent modifierFlags] & NSAlternateKeyMask) && ([theEvent modifierFlags] & NSCommandKeyMask)) {
        isDragging = YES;
        [[NSCursor openHandCursor] set];
    } else {
        isDragging = NO;
        [[NSCursor IBeamCursor] set];
    }
}


/*
 
 - mouseDown:
 
 */
- (void)mouseDown:(NSEvent *)theEvent
{
	if (([theEvent modifierFlags] & NSAlternateKeyMask) && ([theEvent modifierFlags] & NSCommandKeyMask)) { // If the option and command keys are pressed, change the cursor to grab-cursor
		startPoint = [theEvent locationInWindow];
		startOrigin = [[[self enclosingScrollView] contentView] documentVisibleRect].origin;
        isDragging = YES;
	} else {
		[super mouseDown:theEvent];
	}
}


/*
 
 - mouseDragged:
 
 */
- (void)mouseDragged:(NSEvent *)theEvent
{
    if (isDragging) {
		[self scrollPoint:NSMakePoint(startOrigin.x - ([theEvent locationInWindow].x - startPoint.x) * 3, startOrigin.y + ([theEvent locationInWindow].y - startPoint.y) * 3)];
	} else {
		[super mouseDragged:theEvent];
	}
}

/*
 
 - mouseMoved:
 
 */
- (void)mouseMoved:(NSEvent *)theEvent
{
    [super mouseMoved:theEvent];
    if (isDragging)
        [[NSCursor openHandCursor] set];
}

/*
 
 - menuForEvent:
 
 */
- (NSMenu *)menuForEvent:(NSEvent *)theEvent
{
	
	NSMenu *menu = [super menuForEvent:theEvent];
	
	return menu;
	
	// TODO: consider what menu behaviour is appropriate
	/*
	 NSArray *array = [menu itemArray];
	 for (id oldMenuItem in array) {
	 if ([oldMenuItem tag] == -123457) {
	 [menu removeItem:oldMenuItem];
	 }		
	 }
	 
	 [menu insertItem:[NSMenuItem separatorItem] atIndex:0];
	 
	 NSEnumerator *collectionEnumerator = [[SMLBasic fetchAll:@"SnippetCollectionSortKeyName"] reverseObjectEnumerator];
	 for (id collection in collectionEnumerator) {
	 if ([collection valueForKey:@"name"] == nil) {
	 continue;
	 }
	 NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:[collection valueForKey:@"name"] action:nil keyEquivalent:@""];
	 [menuItem setTag:-123457];
	 NSMenu *subMenu = [[NSMenu alloc] init];
	 
	 NSMutableArray *array = [NSMutableArray arrayWithArray:[[collection mutableSetValueForKey:@"snippets"] allObjects]];
	 [array sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
	 for (id snippet in array) {
	 if ([snippet valueForKey:@"name"] == nil) {
	 continue;
	 }
	 NSString *keyString;
	 if ([snippet valueForKey:@"shortcutMenuItemKeyString"] != nil) {
	 keyString = [snippet valueForKey:@"shortcutMenuItemKeyString"];
	 } else {
	 keyString = @"";
	 }
	 NSMenuItem *subMenuItem = [[NSMenuItem alloc] initWithTitle:[snippet valueForKey:@"name"] action:@selector(snippetShortcutFired:) keyEquivalent:@""];
	 [subMenuItem setTarget:[SMLToolsMenuController sharedInstance]];			
	 [subMenuItem setRepresentedObject:snippet];
	 [subMenu insertItem:subMenuItem atIndex:0];
	 }
	 
	 [menuItem setSubmenu:subMenu];
	 [menu insertItem:menuItem atIndex:0];
	 }
	 
	 return menu;
	 */
}


#pragma mark -
#pragma mark Tab and page guide handling
/*
 
 - insertTab:
 
 */
- (void)insertTab:(id)sender
{	
	BOOL shouldShiftText = NO;
	
	if ([self selectedRange].length > 0) { // Check to see if the selection is in the text or if it's at the beginning of a line or in whitespace; if one doesn't do this one shifts the line if there's only one suggestion in the auto-complete
		NSRange rangeOfFirstLine = [[self string] lineRangeForRange:NSMakeRange([self selectedRange].location, 0)];
		NSUInteger firstCharacterOfFirstLine = rangeOfFirstLine.location;
		while ([[self string] characterAtIndex:firstCharacterOfFirstLine] == ' ' || [[self string] characterAtIndex:firstCharacterOfFirstLine] == '\t') {
			firstCharacterOfFirstLine++;
		}
		if ([self selectedRange].location <= firstCharacterOfFirstLine) {
			shouldShiftText = YES;
		}
	}
	
	if (shouldShiftText) {
		[self shiftRight:nil];
	} else if ([[SMLDefaults valueForKey:MGSFragariaPrefsIndentWithSpaces] boolValue] == YES) {
		NSMutableString *spacesString = [NSMutableString string];
		NSInteger numberOfSpacesPerTab = [[SMLDefaults valueForKey:MGSFragariaPrefsTabWidth] integerValue];
		if ([[SMLDefaults valueForKey:MGSFragariaPrefsUseTabStops] boolValue] == YES) {
			NSInteger locationOnLine = [self selectedRange].location - [[self string] lineRangeForRange:[self selectedRange]].location;
			if (numberOfSpacesPerTab != 0) {
				NSInteger numberOfSpacesLess = locationOnLine % numberOfSpacesPerTab;
				numberOfSpacesPerTab = numberOfSpacesPerTab - numberOfSpacesLess;
			}
		}
		while (numberOfSpacesPerTab--) {
			[spacesString appendString:@" "];
		}
		
		[self insertText:spacesString];
	} else if ([self selectedRange].length > 0) { // If there's only one word matching in auto-complete there's no list but just the rest of the word inserted and selected; and if you do a normal tab then the text is removed so this will put the cursor at the end of that word
		[self setSelectedRange:NSMakeRange(NSMaxRange([self selectedRange]), 0)];
	} else {
		[super insertTab:sender];
	}
}

/*
 
 - setTabWidth
 
 */
- (void)setTabWidth
{
	// Set the width of every tab by first checking the size of the tab in spaces in the current font and then remove all tabs that sets automatically and then set the default tab stop distance
	NSMutableString *sizeString = [NSMutableString string];
	NSInteger numberOfSpaces = [[SMLDefaults valueForKey:MGSFragariaPrefsTabWidth] integerValue];
	while (numberOfSpaces--) {
		[sizeString appendString:@" "];
	}
	NSDictionary *sizeAttribute = [[NSDictionary alloc] initWithObjectsAndKeys:[NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:MGSFragariaPrefsTextFont]], NSFontAttributeName, nil];
	CGFloat sizeOfTab = [sizeString sizeWithAttributes:sizeAttribute].width;
	
	NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	
	NSArray *array = [style tabStops];
	for (id item in array) {
		[style removeTabStop:item];
	}
	[style setDefaultTabInterval:sizeOfTab];
	NSDictionary *attributes = [[NSDictionary alloc] initWithObjectsAndKeys:style, NSParagraphStyleAttributeName, nil];
	[self setTypingAttributes:attributes];
    [[self textStorage] addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0,[[self textStorage] length])];
}

/*
 
 - setPageGuideValues
 
 */
- (void)setPageGuideValues
{
	NSDictionary *sizeAttribute = [[NSDictionary alloc] initWithObjectsAndKeys:[NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:MGSFragariaPrefsTextFont]], NSFontAttributeName, nil];
	NSString *sizeString = @" ";
	CGFloat sizeOfCharacter = [sizeString sizeWithAttributes:sizeAttribute].width;
	pageGuideX = floor(sizeOfCharacter * ([[SMLDefaults valueForKey:MGSFragariaPrefsShowPageGuideAtColumn] integerValue] + 1)) - 1.5f; // -1.5 to put it between the two characters and draw only on one pixel and not two (as the system draws it in a special way), and that's also why the width above is set to zero
	
	NSColor *color = [NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:MGSFragariaPrefsTextColourWell]];
	self.pageGuideColour = [color colorWithAlphaComponent:([color alphaComponent] / 4)]; // Use the same colour as the text but with more transparency
	
	showPageGuide = [[SMLDefaults valueForKey:MGSFragariaPrefsShowPageGuide] boolValue];
	
	[self display]; // To reflect the new values in the view
}

#pragma mark -
#pragma mark Text handling

- (BOOL)shouldChangeTextInRanges:(NSArray *)affectedRanges replacementStrings:(NSArray *)replacementStrings
{
    BOOL res;
    NSArray *sortedRanges;
    NSValue *rangeVal;
    NSRange range;
    NSInteger i, newLen;
    
    res = [super shouldChangeTextInRanges:affectedRanges replacementStrings:replacementStrings];
    
    if (!affectedRanges)
        [_inspectedCharacterIndexes removeAllIndexes];
    else {
        sortedRanges = [affectedRanges sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
            {
                NSRange r1, r2;
                r1 = [obj1 rangeValue];
                r2 = [obj2 rangeValue];
                /* reverse sorting */
                if (r1.location > r2.location)
                    return NSOrderedAscending;
                if (r1.location == r2.location)
                    return NSOrderedSame;
                return NSOrderedDescending;
            }];
        for (rangeVal in sortedRanges) {
            i = [affectedRanges indexOfObject:rangeVal];
            newLen = [[replacementStrings objectAtIndex:i] length];
            /* This is not really needed, but it allows for better edit coalescing */
            range = [[self string] lineRangeForRange:[rangeVal rangeValue]];
            [_inspectedCharacterIndexes removeIndexesInRange:range];
            [_inspectedCharacterIndexes shiftIndexesStartingAtIndex:range.location by:(newLen - range.length)];
        }
    }
    return res;
}


/*
 
 - insertText:
 
 */
- (void)insertText:(NSString *)aString
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    /* AppKit Bug: when inserting an emoji (for example by double-clicking it
     * in the character set panel) an NSMutableAttributedString is passed to
     * insertText instead of an NSString. This works around this by making the
     * attributed string an NSString again. */
    if ([aString isKindOfClass:[NSAttributedString class]]){
        aString = [(NSAttributedString *)aString string];
    }
    
	if ([aString isEqualToString:@"}"] && [ud boolForKey:MGSFragariaPrefsIndentNewLinesAutomatically] && [ud boolForKey:MGSFragariaPrefsAutomaticallyIndentBraces]) {
        [self shiftBackToLastOpenBrace];
	}
    
    [super insertText:aString];
    
    if ([aString isEqualToString:@"("] && [ud boolForKey:MGSFragariaPrefsAutoInsertAClosingParenthesis]) {
		[self insertStringAfterInsertionPoint:@")"];
	} else if ([aString isEqualToString:@"{"] && [ud boolForKey:MGSFragariaPrefsAutoInsertAClosingBrace]) {
        [self insertStringAfterInsertionPoint:@"}"];
	}
    
    if ([aString length] == 1 && [ud boolForKey:MGSFragariaPrefsShowMatchingBraces]) {
        if (CharacterIsClosingBrace([aString characterAtIndex:0])) {
            [self showBraceMatchingBrace:[aString characterAtIndex:0]];
        }
    }
}


- (void)insertStringAfterInsertionPoint:(NSString*)string
{
    NSRange selectedRange = [self selectedRange];
    if ([self shouldChangeTextInRange:selectedRange replacementString:string]) {
        [self replaceCharactersInRange:selectedRange withString:string];
        [self didChangeText];
        [self setSelectedRange:NSMakeRange(selectedRange.location, 0)];
    }
}


- (NSInteger)findBeginningOfNestedBlock:(NSInteger)charIdx openedByCharacter:(unichar)open closedByCharacter:(unichar)close
{
    NSInteger skipMatchingBrace = 0;
    NSString *completeString = [self string];
    unichar characterToCheck;
    
    while (charIdx--) {
        characterToCheck = [completeString characterAtIndex:charIdx];
        if (characterToCheck == open) {
            if (!skipMatchingBrace) {
                return charIdx;
            } else {
                skipMatchingBrace--;
            }
        } else if (characterToCheck == close) {
            skipMatchingBrace++;
        }
    }
    return NSNotFound;
}


- (NSInteger)findEndOfNestedBlock:(NSInteger)charIdx openedByCharacter:(unichar)open closedByCharacter:(unichar)close
{
    NSInteger skipMatchingBrace = 0;
    NSString *completeString = [self string];
    NSInteger lengthOfString = [completeString length];
    unichar characterToCheck;
    
    while (++charIdx < lengthOfString) {
        characterToCheck = [completeString characterAtIndex:charIdx];
        if (characterToCheck == close) {
            if (!skipMatchingBrace) {
                return charIdx;
            } else {
                skipMatchingBrace--;
            }
        } else if (characterToCheck == open) {
            skipMatchingBrace++;
        }
    }
    return NSNotFound;
}


- (void)showBraceMatchingBrace:(unichar)characterToCheck;
{
    NSInteger cursorLocation;
    unichar matchingBrace;
    
    matchingBrace = OpeningBraceForClosingBrace(characterToCheck);
    
    cursorLocation = [self selectedRange].location - 1;
    if (cursorLocation < 0) return;
    
    cursorLocation = [self findBeginningOfNestedBlock:cursorLocation
      openedByCharacter:matchingBrace closedByCharacter:characterToCheck];
    if (cursorLocation != NSNotFound)
        [self showFindIndicatorForRange:NSMakeRange(cursorLocation, 1)];
    else
        NSBeep();
}


- (void)shiftBackToLastOpenBrace
{
    NSString *completeString = [self string];
    NSInteger lineLocation = [self selectedRange].location;
    NSCharacterSet *whitespaceCharacterSet = [NSCharacterSet whitespaceCharacterSet];
    NSRange currentLineRange = [completeString lineRangeForRange:NSMakeRange(lineLocation, 0)];
    NSInteger lineStart = currentLineRange.location;
    
    // If there are any characters before } on the line, don't indent
    NSInteger i = lineLocation;
    while (--i >= lineStart) {
        if (![whitespaceCharacterSet characterIsMember:[completeString characterAtIndex:i]])
            return;
    }
    
    // Find the matching closing brace
    NSInteger location;
    location = [self findBeginningOfNestedBlock:lineLocation openedByCharacter:'{' closedByCharacter:'}'];
    if (location == NSNotFound) return;
    
    // If we have found the opening brace check first how much
    // space is in front of that line so the same amount can be
    // inserted in front of the new line.
    // If we found that space, replace the indenting of our line with the indenting from the opening brace line.
    // Otherwise just remove all the whitespace before the closing brace.
    NSString *openingBraceLineWhitespaceString;
    NSRange openingBraceLineRange = [completeString lineRangeForRange:NSMakeRange(location, 0)];
    NSString *openingBraceLine = [completeString substringWithRange:openingBraceLineRange];
    NSScanner *openingLineScanner = [[NSScanner alloc] initWithString:openingBraceLine];
    [openingLineScanner setCharactersToBeSkipped:nil];
    
    BOOL found = [openingLineScanner scanCharactersFromSet:whitespaceCharacterSet intoString:&openingBraceLineWhitespaceString];
    if (!found) {
        openingBraceLineWhitespaceString = @"";
    }
    
    // Replace the beginning of the line with the new indenting
    NSRange startInsertLineRange;
    startInsertLineRange = NSMakeRange(currentLineRange.location, lineLocation - currentLineRange.location);
    if ([self shouldChangeTextInRange:startInsertLineRange replacementString:openingBraceLineWhitespaceString]) {
        [self replaceCharactersInRange:startInsertLineRange withString:openingBraceLineWhitespaceString];
        [self didChangeText];
        [self setSelectedRange:NSMakeRange(currentLineRange.location + [openingBraceLineWhitespaceString length], 0)];
    }
}


/*
 
 - insertNewline:
 
 */
- (void)insertNewline:(id)sender
{
	[super insertNewline:sender];
	
	// If we should indent automatically, check the previous line and scan all the whitespace at the beginning of the line into a string and insert that string into the new line
	NSString *lastLineString = [[self string] substringWithRange:[[self string] lineRangeForRange:NSMakeRange([self selectedRange].location - 1, 0)]];
	if ([[SMLDefaults valueForKey:MGSFragariaPrefsIndentNewLinesAutomatically] boolValue] == YES) {
		NSString *previousLineWhitespaceString;
		NSScanner *previousLineScanner = [[NSScanner alloc] initWithString:[[self string] substringWithRange:[[self string] lineRangeForRange:NSMakeRange([self selectedRange].location - 1, 0)]]];
		[previousLineScanner setCharactersToBeSkipped:nil];		
		if ([previousLineScanner scanCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&previousLineWhitespaceString]) {
			[self insertText:previousLineWhitespaceString];
		}
		
		if ([[SMLDefaults valueForKey:MGSFragariaPrefsAutomaticallyIndentBraces] boolValue] == YES) {
			NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
			NSInteger idx = [lastLineString length];
			while (idx--) {
				if ([characterSet characterIsMember:[lastLineString characterAtIndex:idx]]) {
					continue;
				}
				if ([lastLineString characterAtIndex:idx] == '{') {
					[self insertTab:nil];
				}
				break;
			}
		}
	}
}

/*
 
 - setString:
 
 */
- (void)setString:(NSString *)aString
{
	[super setString:aString];
    [[NSNotificationCenter defaultCenter] postNotificationName:NSTextDidChangeNotification object:self];
}

/*
 
 - setString:options:
 
 */
- (void)setString:(NSString *)text options:(NSDictionary *)options
{
    NSRange all = NSMakeRange(0, [self.textStorage length]);
    [self replaceCharactersInRange:all withString:text options:options];
}
/*
 
 - replaceCharactersInRange:withString:options
 
 */
- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)text options:(NSDictionary *)options
{
	BOOL undo = [[options objectForKey:@"undo"] boolValue];
    BOOL textViewWasEmpty = ([self.textStorage length] == 0 ? YES : NO);

	if ([self isEditable] && undo) {
        
        // this sequence will be registered with the undo manager
		if ([self shouldChangeTextInRange:range replacementString:text]) {
            
            // modify he text storage
			[self.textStorage beginEditing];
			[self.textStorage replaceCharactersInRange:range withString:text];
			[self.textStorage endEditing];
            
            // reset the default font if text was empty as the font gets reset to system default.
            if (textViewWasEmpty) {
                [self setFont:[NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:MGSFragariaPrefsTextFont]]];
            }

			// TODO: this doesn't seem to be having the desired effect
            NSUndoManager *undoManager = [self undoManager];
			[undoManager setActionName:NSLocalizedString(@"Content Change", @"undo content change")];

            // complete the text change operation
			[self didChangeText];
		}
	} else if (textViewWasEmpty) {
        // this operation will not be registered with the undo manager
        [self setString:text];
    } else {
        // this operation will not be registered with the undo manager
		[self.textStorage replaceCharactersInRange:range withString:text];;
	}	
}

/*
 
 - setAttributedString:
 
 */
- (void)setAttributedString:(NSAttributedString *)text
{
    NSTextStorage *textStorage = [self textStorage];
    [textStorage setAttributedString:text];
}

/*
 
 - setAttributedString:options:
 
 */
- (void)setAttributedString:(NSAttributedString *)text options:(NSDictionary *)options
{
	BOOL undo = [[options objectForKey:@"undo"] boolValue];

    NSTextStorage *textStorage = [self textStorage];

	if ([self isEditable] && undo) {
		
        /*
		 
		 see http://www.cocoabuilder.com/archive/cocoa/179875-exponent-action-in-nstextview-subclass.html
		 entitled: Re: "exponent" action in NSTextView subclass (SOLVED)
		 
		 This details how to make programmatic changes to the textStorage object.
		 
		 */
        
        /*
         
         code here reflects what occurs in - setString:options:
         
         may be over complicated
         
         */
		NSRange all = NSMakeRange(0, [textStorage length]);
        BOOL textIsEmpty = ([textStorage length] == 0 ? YES : NO);
        
		if ([self shouldChangeTextInRange:all replacementString:[text string]]) {
			[textStorage beginEditing];
			[textStorage setAttributedString:text];
			[textStorage endEditing];
            
            // reset the default font if text was empty as the font gets reset to system default.
            if (textIsEmpty) {
                [self setFont:[NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:MGSFragariaPrefsTextFont]]];
            }
            
			[self didChangeText];
            
			NSUndoManager *undoManager = [self undoManager];
			
			// TODO: this doesn't seem to be having the desired effect
			[undoManager setActionName:NSLocalizedString(@"Content Change", @"undo content change")];
			
		}
	} else {
        [self setAttributedString:text];
	}
	
}

/*

 - appendString:
 
 */
- (void)appendString:(NSString *)aString
{
    NSMutableString * string = [NSMutableString stringWithString:[super string]];
    [string appendString:aString];
    [self setString:string];
}

#pragma mark -
#pragma mark Selection handling
/*
 
 - selectionRangeForProposedRange:granularity:
 
 */
- (NSRange)selectionRangeForProposedRange:(NSRange)proposedSelRange granularity:(NSSelectionGranularity)granularity
{
	// If it's not a mouse event return unchanged
	NSEventType eventType = [[NSApp currentEvent] type];
	if (eventType != NSLeftMouseDown && eventType != NSLeftMouseUp) {
		return [super selectionRangeForProposedRange:proposedSelRange granularity:granularity];
	}
	
	if (granularity != NSSelectByWord || [[self string] length] == proposedSelRange.location || [[NSApp currentEvent] clickCount] != 2) { // If it's not a double-click return unchanged
		return [super selectionRangeForProposedRange:proposedSelRange granularity:granularity];
	}
	
	NSUInteger location = [super selectionRangeForProposedRange:proposedSelRange granularity:NSSelectByCharacter].location;
	NSInteger originalLocation = location;
	
	NSString *completeString = [self string];
	unichar characterToCheck = [completeString characterAtIndex:location];
	NSUInteger lengthOfString = [completeString length];
	if (lengthOfString == proposedSelRange.location) { // To avoid crash if a double-click occurs after any text
		return [super selectionRangeForProposedRange:proposedSelRange granularity:granularity];
	}
	
    
	BOOL triedToMatchBrace = NO;
    unichar matchingBrace;
    
    if (CharacterIsBrace(characterToCheck)) {
        triedToMatchBrace = YES;
        if (CharacterIsClosingBrace(characterToCheck)) {
            matchingBrace = OpeningBraceForClosingBrace(characterToCheck);
            location = [self findBeginningOfNestedBlock:location openedByCharacter:matchingBrace closedByCharacter:characterToCheck];
            if (location != NSNotFound)
                return NSMakeRange(location, originalLocation - location + 1);
            NSBeep();
        } else {
            matchingBrace = ClosingBraceForOpeningBrace(characterToCheck);
            location = [self findEndOfNestedBlock:location openedByCharacter:characterToCheck closedByCharacter:matchingBrace];
            if (location != NSNotFound)
                return NSMakeRange(originalLocation, location - originalLocation + 1);
            NSBeep();
        }
    }
	
	// If it has a found a "starting" brace but not found a match, a double-click should only select the "starting" brace and not what it usually would select at a double-click
	if (triedToMatchBrace) {
		return [super selectionRangeForProposedRange:NSMakeRange(proposedSelRange.location, 1) granularity:NSSelectByCharacter];
	} else {
		
		NSInteger startLocation = originalLocation;
		NSInteger stopLocation = originalLocation;
		NSInteger minLocation = [super selectionRangeForProposedRange:proposedSelRange granularity:NSSelectByWord].location;
		NSInteger maxLocation = NSMaxRange([super selectionRangeForProposedRange:proposedSelRange granularity:NSSelectByWord]);
		
		BOOL hasFoundSomething = NO;
		while (--startLocation >= minLocation) {
			if ([completeString characterAtIndex:startLocation] == '.' || [completeString characterAtIndex:startLocation] == ':') {
				hasFoundSomething = YES;
				break;
			}
		}
		
		while (++stopLocation < maxLocation) {
			if ([completeString characterAtIndex:stopLocation] == '.' || [completeString characterAtIndex:stopLocation] == ':') {
				hasFoundSomething = YES;
				break;
			}
		}
		
		if (hasFoundSomething == YES) {
			return NSMakeRange(startLocation + 1, stopLocation - startLocation - 1);
		} else {
			return [super selectionRangeForProposedRange:proposedSelRange granularity:granularity];
		}
	}
}


#pragma mark -
#pragma mark Auto Completion


/*
 
 - rangeForUserCompletion
 */
- (NSRange)rangeForUserCompletion
{
    NSRange cursor = [self selectedRange];
    NSUInteger loc = cursor.location;
    
    // Check for selections (can only autocomplete when nothing is selected)
    if (cursor.length > 0)
    {
        return NSMakeRange(NSNotFound, 0);
    }
    
    // Cannot autocomplete on first character
    if (loc == 0)
    {
        return NSMakeRange(NSNotFound, 0);
    }
    
    // Create char set with characters valid for variables
    NSCharacterSet* variableChars = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVXYZ0123456789_\\"];
    
    NSString* text = [self string];
    
    // Can only autocomplete on variable names
    if (![variableChars characterIsMember:[text characterAtIndex:loc-1]])
    {
        return NSMakeRange(NSNotFound, 0);
    }
    
    // TODO: Check if we are in a string
    
    // Search backwards in string until we hit a non-variable char
    NSUInteger numChars = 1;
    NSUInteger searchLoc = loc - 1;
    while (searchLoc > 0)
    {
        if ([variableChars characterIsMember:[text characterAtIndex:searchLoc-1]])
        {
            numChars += 1;
            searchLoc -= 1;
        }
        else
        {
            break;
        }
    }
    
    return NSMakeRange(loc-numChars, numChars);
}

/*
 
 - completionsForPartialWordRange:indexOfSelectedItem;
 
 */
- (NSArray*)completionsForPartialWordRange:(NSRange)charRange indexOfSelectedItem:(NSInteger *)index
{
#pragma unused(index, charRange)

    // get completion handler
    NSMutableArray* matchArray = [NSMutableArray array];
    id<SMLAutoCompleteDelegate> completeHandler = [fragaria.docSpec valueForKey:MGSFOAutoCompleteDelegate];

    // use handler
    if (completeHandler) {
        
        // get all completions
        NSArray* allCompletions = [completeHandler completions];
        
        // get string to match
        NSString *matchString = [[self string] substringWithRange:charRange];
        
        // build array of suitable suggestions
        for (NSString* completeWord in allCompletions)
        {
            if ([completeWord rangeOfString:matchString options:NSCaseInsensitiveSearch range:NSMakeRange(0, [completeWord length])].location == 0)
            {
                [matchArray addObject:completeWord];
            }
        }
    }
    
    return matchArray;
}


#pragma mark -
#pragma mark Line Wrap

/*
 
 - setLineWrap:
 
 see /developer/examples/appkit/TextSizingExample
 
 */
- (void)setLineWrap:(BOOL)value
{
    lineWrap = value;
    [self updateLineWrap];
}

/*
 
 - updateLineWrap
 
 see http://developer.apple.com/library/mac/#samplecode/TextSizingExample
 
 The readme file in the above example has very good info on how to configure NSTextView instances.
 */
- (void)updateLineWrap {
    NSSize contentSize;
    
    // get control properties
	NSScrollView *textScrollView = [self enclosingScrollView];
	NSTextContainer *textContainer = [self textContainer];
    
    if (textScrollView) {
        // content view is clipview
        contentSize = [textScrollView contentSize];
    } else {
        /* scroll view may not be already there */
        contentSize = [self frame].size;
    }
    
    if (self.lineWrap) {
        
        // setup text container
        [textContainer setContainerSize:NSMakeSize(contentSize.width, CGFLOAT_MAX)];
        [textContainer setWidthTracksTextView:YES];
        [textContainer setHeightTracksTextView:NO];
        
        // setup text view
        [self setFrameSize:contentSize];
        [self setHorizontallyResizable: NO];
        [self setVerticallyResizable: YES];
        [self setMinSize:NSMakeSize(10, contentSize.height)];
        [self setMaxSize:NSMakeSize(10, CGFLOAT_MAX)];

        // setup scroll view
        [textScrollView setHasHorizontalScroller:NO];
        [textScrollView setHasVerticalScroller:YES];
    } else {

        // setup text container
        [textContainer setWidthTracksTextView:NO];
        [textContainer setHeightTracksTextView:NO];
        [textContainer setContainerSize:NSMakeSize(CGFLOAT_MAX, CGFLOAT_MAX)];

        // setup text view
        [self setFrameSize:contentSize];
        [self setHorizontallyResizable: YES];
        [self setVerticallyResizable: YES];
        [self setMinSize:contentSize];
        [self setMaxSize:NSMakeSize(CGFLOAT_MAX, CGFLOAT_MAX)];
        
        // setup scroll view
        [textScrollView setHasHorizontalScroller:YES];
        [textScrollView setHasVerticalScroller:YES];
    }
        
    
    // invalidate the glyph layout
	[[self layoutManager] textContainerChangedGeometry:textContainer];

    // redraw the display and reposition scrollers
    NSDisableScreenUpdates();
    [textScrollView display];
    [textScrollView reflectScrolledClipView:textScrollView.contentView];
    [textScrollView display];
    NSEnableScreenUpdates();
    
}

@end
