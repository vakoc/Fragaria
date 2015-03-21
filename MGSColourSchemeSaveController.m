//
//  MGSColourSchemeSaveController.m
//  Fragaria
//
//  Created by Jim Derry on 3/21/15.
//
//

#import "MGSColourSchemeSaveController.h"


@interface MGSColourSchemeSaveController ()

@property (nonatomic, strong) IBOutlet NSTextField *schemeNameField;

@property (nonatomic, strong) IBOutlet NSButton *bCancel;
@property (nonatomic, strong) IBOutlet NSButton *bSave;

@property (nonatomic, assign) BOOL saveButtonEnabled;

@end

@implementation MGSColourSchemeSaveController {

    void (^completionBlock)();
    void (^deleteCompletion)(BOOL);
}

/*
 * - init
 */
- (instancetype)init
{
    [NSBundle bundleForClass:[MGSColourSchemeSaveController class]];
    if ((self = [self initWithWindowNibName:@"MGSColourSchemeSave" owner:self]))
    {
    }

    return self;
}


/*
 * - awakeFromNib
 */
- (void)awakeFromNib
{
    [self.window setDefaultButtonCell:[self.bSave cell]];
}


#pragma mark - File Naming Sheet


/*
 * - showSchemeNameGetter:completion:
 */
- (void)showSchemeNameGetter:(NSWindow *)window completion:(void (^)(void))aCompletionBlock
{
    completionBlock = aCompletionBlock;
    [NSApp beginSheet:self.window
       modalForWindow:window
        modalDelegate:self
       didEndSelector:@selector(didEndSheet:returnCode:contextInfo:)
          contextInfo:nil];
}


/*
 * - closeSheet
 */
- (IBAction)closeSheet:(id)sender
{
    [NSApp endSheet:self.window];
    if (sender == self.bCancel)
    {
        self.schemeName = nil;
    }
    completionBlock();
}


/*
 * - didEndSheet:returnCode:contextInfo:
 */
- (void)didEndSheet:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    [self.window orderOut:self];
}


/*
 * @property saveButtonEnabled
 */
+ (NSSet *)keyPathsForValuesAffectingSaveButtonEnabled
{
    return [NSSet setWithObject:@"schemeName"];
}

- (BOOL)saveButtonEnabled
{
    return (self.schemeName && [self.schemeName length] > 0);
}


#pragma mark - Delete Dialogue


/*
 * - showDeleteConfirmation:completion:
 */
- (void)showDeleteConfirmation:(NSWindow *)window completion:(void (^)(BOOL))aCompletionBlock
{
    deleteCompletion = aCompletionBlock;

    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:NSLocalizedString(@"Delete", @"String for delete button.")];
    [alert addButtonWithTitle:NSLocalizedString(@"Cancel", @"String for cancel button.")];
    [alert setMessageText:NSLocalizedString(@"Delete the scheme?", @"String to alert.")];
    [alert setInformativeText:NSLocalizedString(@"Deleted schemes cannot be restored.", @"String for alert information.")];
    [alert setAlertStyle:NSWarningAlertStyle];


    [alert beginSheetModalForWindow:window
                      modalDelegate:self
                     didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:)
                        contextInfo:nil];
}


/*
 * - alertDidEnd:contextInfo:
 */
- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    BOOL result = returnCode == NSAlertFirstButtonReturn;
    deleteCompletion(!result);
}

@end
