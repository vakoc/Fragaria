//
//  MGSFragariaFontsAndColoursPrefsViewController.h
//  Fragaria
//
//  Created by Jonathan on 14/09/2012.
//
//

#import <Cocoa/Cocoa.h>
#import "MGSFragariaPrefsViewController.h"

/**
 *  MGSFragariaFontsAndColoursPrefsViewController handles the view
 *  provided by MGSPreferencesFontsAndColours.xib.
 **/

@interface MGSFragariaFontsAndColoursPrefsViewController : MGSFragariaPrefsViewController


/** Open the system font picker.
 *  @param sender The object which sent the message. */
- (IBAction)setFontAction:(id)sender;

/** Inform responders of a font change.
 *  @param sender indicates the send of the action. */
- (void)changeFont:(id)sender;


@end
