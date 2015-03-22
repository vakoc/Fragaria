//
//  PrefsFontsAndColorsViewController.h
//  MGSFragariaView Demo
//
//  Created by Jim Derry on 2015/02/22.
//

#import "MASPreferencesViewController.h"
#import "MGSPrefsColourPropertiesViewController.h"

/**
 *  ColorSettingsViewController is simply a subclass of the Fragaria
 *  MGSPrefsColourPropertiesViewController with a couple of methods added
 *  in order to work using MASPreferences.
 **/
@interface ColorSettingsViewController : MGSPrefsColourPropertiesViewController <MASPreferencesViewController>

@end
