//
//  MGSGlyphGenerator.h
//  Fragaria
//
//  Created by Jonathan on 23/09/2012.
//
//

#import <Cocoa/Cocoa.h>

/**
 *  This subclass of NSGlyphGenerator is used to generate glyphs for
 *  invisible characters.
 **/
@interface MGSGlyphGenerator : NSGlyphGenerator <NSGlyphStorage> {
    id <NSGlyphStorage> _destination;
}

@end
