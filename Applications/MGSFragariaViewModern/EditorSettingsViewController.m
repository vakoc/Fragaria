//
//  PrefsTextEditingViewController.m
//  MGSFragariaView Demo
//
//  Created by Jim Derry on 2015/02/22.
//

#import "EditorSettingsViewController.h"


@implementation EditorSettingsViewController

#pragma mark - MASPreferencesViewController

- (NSString *)identifier
{
    return @"MGSPrefsEditorProperties";
}


- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNameAdvanced];
}


- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"Editor", @"Toolbar item name for the Editor preference pane");
}


@end
