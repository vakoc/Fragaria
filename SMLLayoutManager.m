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

#import "MGSFragariaFramework.h"
#import "SMLLayoutManager.h"

typedef enum : NSUInteger
{
    kTabLine = 0,
    kSpaceLine = 1,
    kNewLineLine = 2
} MGSLineCacheIndex;

@interface SMLLayoutManager()
- (void)resetAttributesAndGlyphs;
@end

@implementation SMLLayoutManager {

    NSDictionary *defAttributes;
    NSString *tabCharacter;
    NSString *newLineCharacter;
    NSString *spaceCharacter;
    NSGlyph *invisibleGlyphs;
    BOOL useGlyphSubstitutionForInvisibleGlyphs;
    BOOL drawInvisibleGlyphsUsingCoreText;
    NSMutableArray *lineRefs;
}

@synthesize showsInvisibleCharacters = _showsInvisibleCharacters;
@synthesize textFont = _textFont;
@synthesize textInvisibleCharactersColour = _textInvisibleCharactersColour;

#pragma mark - Instance methods

/*
 * - init
 */
- (id)init
{
    self = [super init];
	if (self) {
		
        invisibleGlyphs = NULL;
        
        [self resetAttributesAndGlyphs];
        
		[self setAllowsNonContiguousLayout:YES]; // Setting this to YES sometimes causes "an extra toolbar" and other graphical glitches to sometimes appear in the text view when one sets a temporary attribute, reported as ID #5832329 to Apple
	}
	return self;
}


#pragma mark - Drawing

/*
 * - drawGlyphsForGlyphRange:atPoint:
 */
- (void)drawGlyphsForGlyphRange:(NSRange)glyphRange atPoint:(NSPoint)containerOrigin
{

    if (self.showsInvisibleCharacters) {
        
		NSPoint pointToDrawAt;
		NSRect glyphFragment;
		NSString *completeString = [[self textStorage] string];
		NSInteger lengthToRedraw = NSMaxRange(glyphRange);
        
        void *gcContext = [[NSGraphicsContext currentContext] graphicsPort];
        
        // see http://www.cocoabuilder.com/archive/cocoa/242724-ctlinecreatewithattributedstring-ignoring-font-size.html
        
        // if our context is flipped then we need to flip our drawn text too
        CGAffineTransform t = {1.0, 0.0, 0.0, -1.0, 0.0, 0.0};
        if (![[NSGraphicsContext currentContext] isFlipped]) {
            t = CGAffineTransformIdentity;
        }
        CGContextSetTextMatrix (gcContext, t);
    
        // we may not have any glyphs generated at this stage
		for (NSInteger idx = glyphRange.location; idx < lengthToRedraw; idx++) {
			unichar characterToCheck = [completeString characterAtIndex:idx];
            NSUInteger lineRefIndex = 0;
            
			if (characterToCheck == '\t') {
                lineRefIndex = kTabLine;
            } else if (characterToCheck == ' ') {
                lineRefIndex = kSpaceLine;
			} else if (characterToCheck == '\n' || characterToCheck == '\r') {
                lineRefIndex = kNewLineLine;
			} else {
                continue;
            }
            
            pointToDrawAt = [self locationForGlyphAtIndex:idx];
            glyphFragment = [self lineFragmentRectForGlyphAtIndex:idx effectiveRange:NULL];
            
            
            // for some fonts the invisible characters are lower on the line than expected
            // when drawing with  -drawAtPoint:withAttributes:
            //
            // experimental glyph substitution is available with useGlyphSubstitutionForInvisibleGlyphs = YES;
            //[outputChar drawAtPoint:pointToDrawAt withAttributes:defAttributes];
            //
            // see thread
            //
            // http://lists.apple.com/archives/cocoa-dev/2012/Sep/msg00531.html
            //
            // Draw profiling indicated that the CoreText approach on 10.8 is an order of magnitude
            // faster that using the NSStringDrawing methods.
                
            // draw with cached core text line ref
            pointToDrawAt.x += glyphFragment.origin.x;
            pointToDrawAt.y += glyphFragment.origin.y;
            
            // get our text line object
            CTLineRef line = (__bridge CTLineRef)[lineRefs objectAtIndex:lineRefIndex];
            
            CGContextSetTextPosition(gcContext, pointToDrawAt.x, pointToDrawAt.y);
            CTLineDraw(line, gcContext);
		}
    }
    
    
    // the following causes glyph generation to occur if required
    [super drawGlyphsForGlyphRange:glyphRange atPoint:containerOrigin];
}


#pragma mark - Accessors

/*
 * - attributedStringWithTemporaryAttributesApplied
 */
- (NSAttributedString *)attributedStringWithTemporaryAttributesApplied
{
	/*
	 
	 temporary attributes have been applied by the layout manager to
	 syntax colour the text.
	 
	 to retain these we duplicate the text and apply the temporary attributes as normal attributes
	 
	 */
	
	NSMutableAttributedString *attributedString = [[self attributedString] mutableCopy];
	NSInteger lastCharacter = [attributedString length];
	[self removeTemporaryAttribute:NSBackgroundColorAttributeName forCharacterRange:NSMakeRange(0, lastCharacter)];
	
	NSInteger idx = 0;
	while (idx < lastCharacter) {
		NSRange range = NSMakeRange(0, 0);
		NSDictionary *tempAttributes = [self temporaryAttributesAtCharacterIndex:idx effectiveRange:&range];
		if ([tempAttributes count] != 0) {
			[attributedString setAttributes:tempAttributes range:range];
		}
		NSInteger rangeLength = range.length;
		if (rangeLength != 0) {
			idx = idx + rangeLength;
		} else {
			idx++;
		}
	}
	
	return attributedString;	
}


#pragma mark - Property Accessors


/*
 * @property textFont
 */
-(void)setTextFont:(NSFont *)textFont
{
    _textFont = textFont;
    [self resetAttributesAndGlyphs];
    [[self firstTextView] setNeedsDisplay:YES];

}

-(NSFont *)textFont
{
    return _textFont;
}


/*
 * @property textInvisibleCharactersColor
 */
- (void)setTextInvisibleCharactersColour:(NSColor *)textInvisibleCharactersColour
{
    _textInvisibleCharactersColour = textInvisibleCharactersColour;
    [self resetAttributesAndGlyphs];
    [[self firstTextView] setNeedsDisplay:YES];
}

- (NSColor *)textInvisibleCharactersColour
{
    return _textInvisibleCharactersColour;
}


/*
 * @property showInvisibleCharacters
 */
- (void)setShowsInvisibleCharacters:(BOOL)showsInvisibleCharacters
{
    _showsInvisibleCharacters = showsInvisibleCharacters;
    if (useGlyphSubstitutionForInvisibleGlyphs)
    {
        // we need to regenerate the glyph cache
        [self replaceTextStorage:[self textStorage]];
    }
    [[self firstTextView] setNeedsDisplay:YES];
}

- (BOOL)showsInvisibleCharacters
{
    return _showsInvisibleCharacters;
}


#pragma mark - Class extension

/*
 * - resetAttributesAndGlyphs
 */
- (void)resetAttributesAndGlyphs
{
    // assemble our default attributes
    defAttributes = [[NSDictionary alloc] initWithObjectsAndKeys: self.textFont, NSFontAttributeName, self.textInvisibleCharactersColour, NSForegroundColorAttributeName, nil];

    // define substitute characters for whitespace chars
    unichar tabUnichar = 0x00AC;
    tabCharacter = [[NSString alloc] initWithCharacters:&tabUnichar length:1];
    unichar newLineUnichar = 0x00B6;
    newLineCharacter = [[NSString alloc] initWithCharacters:&newLineUnichar length:1];
    spaceCharacter = @".";
    
    // all CFTypes can be added to NS collections
    // http://www.mikeash.com/pyblog/friday-qa-2010-01-22-toll-free-bridging-internals.html
    lineRefs = [NSMutableArray arrayWithCapacity:kNewLineLine+1];
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:tabCharacter attributes:defAttributes];
    CTLineRef textLine = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)attrString);
    [lineRefs addObject:(__bridge id)textLine]; // kTabLine
    CFRelease(textLine);
    
    attrString = [[NSAttributedString alloc] initWithString:spaceCharacter attributes:defAttributes];
    textLine = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)attrString);
    [lineRefs addObject:(__bridge id)textLine]; // kSpaceLine
    CFRelease(textLine);
    
    attrString = [[NSAttributedString alloc] initWithString:newLineCharacter attributes:defAttributes];
    textLine = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)attrString);
    [lineRefs addObject:(__bridge id)textLine]; // kNewLineLine
    CFRelease(textLine);
}


@end
