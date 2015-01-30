/*
 
 MGSFragaria
 Written by Jonathan Mitchell, jonathan@mugginsoft.com
 Find the latest version at https://github.com/mugginsoft/Fragaria
 
Smultron version 3.6b1, 2009-09-12
Written by Peter Borg, pgw3@mac.com
Find the latest version at http://smultron.sourceforge.net

Copyright 2004-2009 Peter Borg
 
Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 
http://www.apache.org/licenses/LICENSE-2.0
 
Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
*/

#import "MGSFragaria.h"
#import "MGSFragariaFramework.h"

@interface SMLLineNumbers()
@property (strong) NSDictionary *attributes;
@property (strong) id document;
@property (strong) NSClipView *updatingLineNumbersForClipView;
@property BOOL shouldHandleBoundsChange;

@end

@implementation SMLLineNumbers

@synthesize attributes, document, updatingLineNumbersForClipView;

#pragma mark -
#pragma mark Instance methods
/*
 
 - init
 
 */
- (id)init
{
	self = [self initWithDocument:nil];
	
	return self;
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
}

/*
 
 - initWithDocument:
 
 */
- (id)initWithDocument:(id)theDocument
{
	if ((self = [super init])) {
		
		self.document = theDocument;
    _numberOfVisibleLines = 0;
    
		NSUserDefaultsController *defaultsController = [NSUserDefaultsController sharedUserDefaultsController];
		[defaultsController addObserver:self forKeyPath:@"values.FragariaTextFont" options:NSKeyValueObservingOptionNew context:@"TextFontChanged"];
	}
	
    return self;
}

#pragma mark -
#pragma mark KVO
/*
 
 - observeValueForKeyPath:ofObject:change:context
 
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([(__bridge NSString *)context isEqualToString:@"TextFontChanged"]) {
        [self updateGutterView];
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

#pragma mark -
#pragma mark View updating


- (void) updateGutterView {
    BOOL showGutter;
    
    // get editor views
    NSScrollView *textScrollView = (NSScrollView *)[document valueForKey:ro_MGSFOScrollView];

    MGSLineNumberView *ruler;
    
    showGutter = [[document valueForKey:MGSFOShowLineNumberGutter] boolValue];
    ruler = [document valueForKey:ro_MGSFOGutterView];
    if (showGutter) {
        [ruler setBackgroundColor:[NSColor colorWithCalibratedWhite:0.94f alpha:1.0f]];
        [ruler setTextColor:[NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:MGSFragariaPrefsGutterTextColourWell]]];
        [ruler setFont:[NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:MGSFragariaPrefsTextFont]]];
        [ruler setMinimumWidth:[[SMLDefaults valueForKey:MGSFragariaPrefsGutterWidth] doubleValue]];
        [ruler setNeedsDisplay:YES];
    }
    [textScrollView setRulersVisible:showGutter];
}


/*
 
 - viewBoundsDidChange:
 
 */
- (void)viewBoundsDidChange:(NSNotification *)notification
{
	if (notification != nil && [notification object] != nil && [[notification object] isKindOfClass:[NSClipView class]]) {
		[self updateLineNumbersForClipView:[notification object] checkWidth:YES recolour:YES];
	}
}

/*
 
 - updateLineNumbersCheckWidth:recolour:
 
 */
- (void)updateLineNumbersCheckWidth:(BOOL)checkWidth recolour:(BOOL)recolour
{
	[self updateLineNumbersForClipView:[[document valueForKey:ro_MGSFOScrollView] contentView] checkWidth:checkWidth recolour:recolour];
}

/*
 
 - updateLineNumbersForClipView:checkWidth:recolour:
 
 */
- (void)updateLineNumbersForClipView:(NSClipView *)clipView checkWidth:(BOOL)checkWidth recolour:(BOOL)recolour
{
    NSInteger idx = 0;
	NSInteger lineNumber = 0;
	NSRange range = NSMakeRange(0, 0);
  
	SMLTextView *textView = [clipView documentView];
	NSScrollView *scrollView = (NSScrollView *)[clipView superview];
	
	NSLayoutManager *layoutManager = [textView layoutManager];
	NSRect visibleRect = [[scrollView contentView] documentVisibleRect];
	NSRange visibleRange = [layoutManager glyphRangeForBoundingRect:visibleRect inTextContainer:[textView textContainer]];
	NSString *textString = [textView string];
    
    // wat? Sometimes glyphRangeForBoundingRect: returns NSNotFound, but then in debugger returns a valid range? Let's see if this works around it:
    if (visibleRange.location == NSNotFound)
        visibleRange = [layoutManager glyphRangeForBoundingRect:visibleRect inTextContainer:[textView textContainer]];
    
    if (visibleRange.location == NSNotFound)
    {
        NSLog(@"visibleRange.location still == NSNotFound after second attempt");
        return;
    }
    
    visibleRange = [layoutManager characterRangeForGlyphRange:visibleRange actualGlyphRange:NULL];
    
	NSString *searchString = [textString substringWithRange:NSMakeRange(0,visibleRange.location)];
	
	for (idx = 0, lineNumber = 0; idx < (NSInteger)visibleRange.location; lineNumber++) {
		idx = NSMaxRange([searchString lineRangeForRange:NSMakeRange(idx, 0)]);
	}
	
	NSInteger indexNonWrap = [searchString lineRangeForRange:NSMakeRange(idx, 0)].location;
    // Set it to just after the last character on the last visible line
	NSInteger maxRangeVisibleRange = NSMaxRange([textString lineRangeForRange:NSMakeRange(NSMaxRange(visibleRange), 0)]);
	NSInteger numberOfCharsInTextString = [[layoutManager textStorage] length];
	BOOL oneMoreTime = NO;
	if (numberOfCharsInTextString != 0) {
		unichar lastChar = [textString characterAtIndex:numberOfCharsInTextString - 1];
		if (![[NSCharacterSet newlineCharacterSet] characterIsMember:lastChar]) {
			oneMoreTime = YES; // Continue one more time through the loop if the last glyph isn't newline
		}
	}
    
    // generate line number string
	while (indexNonWrap <= maxRangeVisibleRange) {
        
        // wrap or not
		if (idx == indexNonWrap) {
			lineNumber++;
			_numberOfVisibleLines++;
            
		} else {
			indexNonWrap = idx;
		}
		
		if (idx < maxRangeVisibleRange) {
            NSUInteger glyph = [layoutManager glyphIndexForCharacterAtIndex:idx];
			[layoutManager lineFragmentRectForGlyphAtIndex:glyph effectiveRange:&range];
			idx = NSMaxRange(range);
			indexNonWrap = NSMaxRange([textString lineRangeForRange:NSMakeRange(indexNonWrap, 0)]);
		} else {
			idx++;
			indexNonWrap ++;
		}
		
		if (idx == numberOfCharsInTextString && !oneMoreTime) {
			break;
		}
	}
	
	if (recolour == YES) {
		[[document valueForKey:ro_MGSFOSyntaxColouring] pageRecolourTextView:textView];
	}
}

/*
 
 - numberOfVisibleLines:
 
 */
- (NSUInteger)numberOfVisibleLines {
  return _numberOfVisibleLines;
}

@end
