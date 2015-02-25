//
//  PrefsTextEditingViewController.m
//  MGSFragariaView Demo
//
//  Created by Jim Derry on 2015/02/22.
//


#import "PrefsTextEditingViewController.h"

@implementation PrefsTextEditingViewController


#pragma mark - MASPreferencesViewController

- (NSString *)identifier
{
    return @"MGSPreferencesTextEditing";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNameAdvanced];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"Text Editing", @"Toolbar item name for the Text Editing preference pane");
}


@end
