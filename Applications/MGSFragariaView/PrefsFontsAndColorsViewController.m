//
//  PrefsFontsAndColorsViewController.m
//  MGSFragariaView Demo
//
//  Created by Jim Derry on 2015/02/22.
//

#import "PrefsFontsAndColorsViewController.h"


@implementation PrefsFontsAndColorsViewController

#pragma mark - MASPreferencesViewController

- (NSString *)identifier
{
    return @"MGSPreferencesFontsAndColours";
}


- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNameAdvanced];
}


- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"Fonts and Colors", @"Toolbar item name for the Fonts and Colors preference pane");
}


@end
