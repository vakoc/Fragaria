//
//  PrefsFontsAndColorsViewController.m
//  MGSFragariaView Demo
//
//  Created by Jim Derry on 2015/02/22.
//

#import "PrefsFontsAndColorsViewController.h"


@implementation PrefsFontsAndColorsViewController


#pragma mark - Initialization

//- (id)init
//{
//    return [super init];
//    //return [super initWithNibName:@"AdvancedPreferencesView" bundle:nil];
//    //return [super initWithNibName:@"MGSPreferencesFontsAndColours" bundle:[NSBundle bundleForClass:[MGSFragariaFontsAndColoursPrefsViewController class]]];
//}


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


//- (NSView *)initialKeyView
//{
//    NSInteger focusedControlIndex = [[NSApp valueForKeyPath:@"delegate.focusedAdvancedControlIndex"] integerValue];
//    return (focusedControlIndex == 0 ? self.textField : self.tableView);
//}

@end
