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

/**
 *  setFontAction: responds to the "Set Font" button in order to open the
 *  standard OS font picker.
 *  @param sender indicates the send of the action.
 **/
- (IBAction)setFontAction:(id)sender;

/**
 *  changeFont: is sent up the responder chain by the fontManager so we have
 *  to call this method from, e.g., the preferences window controller which has
 *  been configured as the window delegate.
 *  @param sender indicates the send of the action.
**/
- (void)changeFont:(id)sender;
@end
