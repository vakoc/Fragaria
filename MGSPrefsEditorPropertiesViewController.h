//
//  MGSPrefsEditorPropertiesViewController.h
//  Fragaria
//
//  Created by Jim Derry on 3/15/15.
//
//

#import "MGSPrefsViewController.h"


/**
 *  MGSPrefsEditorPropertiesViewController provides a basic view controller for
 *  managing and instance of the MGSPrefsEditorProperties nib.
 **/

@interface MGSPrefsEditorPropertiesViewController : MGSPrefsViewController


/** 
 *  Open the system font picker.
 *  @param sender The object which sent the message.
 **/
- (IBAction)setFontAction:(id)sender;

/**
 *  Called as part of the responder chain when the font is changed.
 *  @param sender indicates the send of the action. 
 **/
- (void)changeFont:(id)sender;


@end
