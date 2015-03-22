//
//  PrefsTextEditingViewController.h
//  MGSFragariaView Demo
//
//  Created by Jim Derry on 2015/02/22.
//

#import "MASPreferencesViewController.h"
#import "MGSPrefsEditorPropertiesViewController.h"

/**
 *  EditorSettingsViewController is simply a subclass of the Fragaria
 *  MGSPrefsEditorPropertiesViewController with a couple of methods added
 *  in order to work using MASPreferences.
 **/
@interface EditorSettingsViewController : MGSPrefsEditorPropertiesViewController <MASPreferencesViewController>

@end
