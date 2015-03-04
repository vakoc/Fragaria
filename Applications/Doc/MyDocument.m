//
//  MyDocument.m
//  Fragaria Document
//
//  Created by Jonathan on 24/07/2010.
//  Copyright 2010 mugginsoft.com. All rights reserved.
//

#import "MyDocument.h"
#import <MGSFragaria/MGSFragaria.h>

@implementation MyDocument{
    MGSFragaria *fragaria;
}


/*
 * - init
 */
- (id)init
{
    if ((self = [super init]))
    {
        // Add your subclass-specific initialization here.
    }
    return self;
}


#pragma mark - Nib loading

/*
 * - windowNibName
 */
- (NSString *)windowNibName
{
    // Override returning the nib file name of the document.
    // If you need to use a subclass of NSWindowController or if your document supports multiple
    // NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MyDocument";
}


/*
 * - windowControllerDidLoadNib:
 */
- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];

	// create an instance
	fragaria = [[MGSFragaria alloc] initWithView:self.editView useStandardPreferences:NO];
	
    fragaria.textViewDelegate = self;
	
	// set our syntax definition
	[self setSyntaxDefinition:@"Objective-C"];
	
    //
	// assign user defaults.
	// a number of properties are currently derived from the user defaults system.
	//
	// see MGSFragariaPreferences.h for details
	//
#if 0
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:MGSFragariaPrefsAutocompleteSuggestAutomatically];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:MGSFragariaPrefsLineWrapNewDocuments];
#endif
	
	// define initial document configuration
	//
	// see MGSFragaria.h for details
	//
    if (YES) {
        fragaria.isSyntaxColoured = YES;
        fragaria.showsLineNumbers = YES;
    }

    // set text
	[fragaria setString:@"// We Don't need the future"];
	
    // Set the undo manager. This is fundamental and allows NSDocument to perform its magic.
    [self setUndoManager:[fragaria.textView undoManager]];
}


#pragma mark - NSDocument data

/*
 * - dataOfType:error:
 */
- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
#pragma unused(typeName)
	
    // Insert code here to write your document to data of the specified type. If the given outError != NULL,
    // ensure that you set *outError when returning nil.

    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:,
    // or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.

    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
	return nil;
}


/*
 * - readFromData:ofType:error:
 */
- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
#pragma unused(data)
#pragma unused(typeName)
	
    // Insert code here to read your document from the given data of the specified type.
    // If the given outError != NULL, ensure that you set *outError when returning NO.

    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead. 

    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
    return YES;
}


#pragma mark - Property Accessors

/*
 * - setSyntaxDefinition:
 */
- (void)setSyntaxDefinition:(NSString *)name
{
    fragaria.syntaxDefinitionName = name;
}


/*
 * - syntaxDefinition
 */
- (NSString *)syntaxDefinition
{
    return fragaria.syntaxDefinitionName;
}


@end
