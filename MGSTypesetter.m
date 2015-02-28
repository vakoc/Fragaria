//
//  MGSTypesetter.m
//  Fragaria
//
//  Created by Daniele Cattaneo on 28/02/15.
//
//

#import "MGSTypesetter.h"


static unichar VisibleCharacterForInvisibleCharacter(unichar invis) {
    switch (invis) {
        case '\n':
        case '\r':
            return 0xAC;  /* 0x00B6 */
        case '\t':
            return 0x21E2; /* 0x00AC */
    }
    return 0x22C5; /* '.' */
}


@implementation MGSTypesetter


/* How it works: we let NSATSTypesetter lay out unmodified glyphs, then, after
 * every glyph is placed in its proper position, we replace the invisible
 * control glyphs for special characters with visible glyphs. Since each glyph
 * position has been already set, these visible glyph will substitute the
 * invisible glyphs without changing how the text flows. */
- (NSUInteger)layoutParagraphAtPoint:(NSPoint *)lineFragmentOrigin
{
    NSUInteger characterIdx;
    unichar character, repl;
    NSGlyph temp;
    NSString *str;
    NSUInteger start, end, i;
    NSLayoutManager *lm = [self layoutManager];
    NSCharacterSet *invisibles = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    start = [self paragraphGlyphRange].location;
    end = [super layoutParagraphAtPoint:lineFragmentOrigin];
    str = [[lm textStorage] string];
    
    for (i = start; i<end; i++) {
        characterIdx = [lm characterIndexForGlyphAtIndex:i];
        character = [str characterAtIndex:characterIdx];
        if ([invisibles characterIsMember:character]) {
            repl = VisibleCharacterForInvisibleCharacter(character);
            temp = [self glyphForCharacter:repl replacingGlyphOfCharacterAtIndex:characterIdx];
            [self substituteGlyphsInRange:NSMakeRange(i,1) withGlyphs:&temp];
        }
    }
    return end;
}


- (NSGlyph)glyphForCharacter:(unichar)c replacingGlyphOfCharacterAtIndex:(NSUInteger)charIdx
{
    NSDictionary *attrib;
    NSTextStorage *ts;
    CTFontRef font;
    CGGlyph glyph = 0;
    
    ts = [self.layoutManager textStorage];
    attrib = [ts attributesAtIndex:charIdx effectiveRange:NULL];
    font = (__bridge CTFontRef)[attrib objectForKey:NSFontAttributeName];
    CTFontGetGlyphsForCharacters(font, &c, &glyph, 1);
    return glyph;
}


@end
