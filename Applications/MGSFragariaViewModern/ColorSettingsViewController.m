//
//  PrefsFontsAndColorsViewController.m
//  MGSFragariaView Demo
//
//  Created by Jim Derry on 2015/02/22.
//

#import "ColorSettingsViewController.h"


@implementation ColorSettingsViewController

#pragma mark - MASPreferencesViewController

- (NSString *)identifier
{
    return @"MGSPrefsColourProperties";
}


- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNameAdvanced];
}


- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"Colors", @"Toolbar item name for the Colors preference pane");
}


@end
