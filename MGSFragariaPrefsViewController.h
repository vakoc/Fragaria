//
//  MGSFragariaPrefsViewController.h
//  Fragaria
//
//  Created by Jonathan on 22/10/2012.
//
//

#import <Cocoa/Cocoa.h>

/**
 *  MGSFragariaPrefsViewController provides a base class for other Fragaria
 *  preferences controllers. It is not implemented directly anywhere.
 *  @see MGSFragariaFontsAndColorsPrefsViewController.h
 *  @see MGSFragariaTextEditingPrefsViewController.h
 **/

@interface MGSFragariaPrefsViewController : NSViewController <NSTabViewDelegate>

/**
 *  Commit edits, discarding changes on error.
 **/
- (BOOL)commitEditingAndDiscard:(BOOL)discard;

@end
