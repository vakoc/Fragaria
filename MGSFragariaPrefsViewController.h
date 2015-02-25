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
 *  @see MGSFragariaFontsAndColoursPrefsViewController
 *  @see MGSFragariaTextEditingPrefsViewController
 **/

@interface MGSFragariaPrefsViewController : NSViewController <NSTabViewDelegate>

/**
 *  Commit edits, discarding changes on error.
 *  @param discard indicates whether or not to discard current uncommitted changes.
 **/
- (BOOL)commitEditingAndDiscard:(BOOL)discard;

@end
