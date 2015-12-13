//
//  NSTextStorage+Fragaria.h
//  Fragaria
//
//  Created by Daniele Cattaneo on 12/12/15.
//
//

#import <Cocoa/Cocoa.h>


/** A private category of NSTextStorage, used for globally caching line
 *  numbers. */

@interface NSTextStorage (Fragaria)


/** The row (line number) where the specified character index is located.
 *  @param c A character index in the string. 
 *  @result If c is a valid character index, the index of a non-empty row
 *    is returned. Otherwise, if c points to one character past the end of the
 *    string, the function returns the row where that character will be when it
 *    is inserted. In all other cases, NSNotFound is returned. */
- (NSUInteger)mgs_rowOfCharacter:(NSUInteger)c;

/** The character index where the first character of the specified row (line
 *  number) is located.
 *  @param l A line number.
 *  @discussion Any line number returned by mgs_rowOfCharacter: is a valid line
 *    number for this function.
 *  @result l may point to a line that contains no characters; in this case,
 *    this method returns the index where its first character will be placed
 *    when it is inserted. If this index can't be determined, NSNotFound is
 *    returned. */
- (NSUInteger)mgs_firstCharacterInRow:(NSUInteger)l;

/** The character index corresponding to the offset of a character in its row
 *  (line).
 *  @param i A character index, relative to the beginning of a line.
 *  @param l A line number.
 *  @discussion Any line number returned by mgs_rowOfCharacter: is a valid
 *    line number for this function.
 *  @result If the specified line exists (mgs_rowOfCharacter: does not return
 *    NSNotFound), this function will always return a valid character index
 *    in that line, even if the index parameter specifies a character outside
 *    the bounds of the line.*/
- (NSUInteger)mgs_characterAtIndex:(NSUInteger)i withinRow:(NSUInteger)l;


@end
