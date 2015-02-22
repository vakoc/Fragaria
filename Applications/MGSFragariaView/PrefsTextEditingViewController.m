//
//  PrefsTextEditingViewController.m
//  MGSFragariaView Demo
//
//  Created by Jim Derry on 2015/02/22.
//


#import "PrefsTextEditingViewController.h"

@implementation PrefsTextEditingViewController


#pragma mark - Initialization

//- (id)init
//{
////    return [super initWithNibName:@"AdvancedPreferencesView" bundle:nil];
//    return [super initWithNibName:@"MGSPreferencesTextEditing" bundle:[NSBundle bundleForClass:[MGSFragariaTextEditingPrefsViewController class]]];
//}

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

//- (NSView *)initialKeyView
//{
////    NSInteger focusedControlIndex = [[NSApp valueForKeyPath:@"delegate.focusedAdvancedControlIndex"] integerValue];
////    return (focusedControlIndex == 0 ? self.textField : self.tableView);
//}

@end
