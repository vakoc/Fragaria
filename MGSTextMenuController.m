/*
 
 MGSFragaria
 Written by Jonathan Mitchell, jonathan@mugginsoft.com
 Find the latest version at https://github.com/mugginsoft/Fragaria
 
Smultron version 3.6b1, 2009-09-12
Written by Peter Borg, pgw3@mac.com
Find the latest version at http://smultron.sourceforge.net

Copyright 2004-2009 Peter Borg
 
Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 
http://www.apache.org/licenses/LICENSE-2.0
 
Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
*/

#import "MGSFragaria.h"
#import "MGSFragariaFramework.h"
#import "SMLTextView+MGSTextActions.h"


@implementation MGSTextMenuController


static id sharedInstance = nil;

#pragma mark -
#pragma mark Class methods

/*
 
 + sharedInstance
 
 */
+ (MGSTextMenuController *)sharedInstance
{ 
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
} 

/*
 
 + allocWithZone:
 
 alloc with zone for singleton
 
 */
+ (id)allocWithZone:(NSZone *)zone
{
#pragma unused(zone)
	return [self sharedInstance];
} 

#pragma mark -
#pragma mark Instance methods

/*
 
 - init
 
 */
- (id)init 
{
    if (sharedInstance == nil) {
        sharedInstance = [super init];
		
    }
    return sharedInstance;
}



#pragma mark -
#pragma mark NSCopying

/*
 
 - copyWithZone:
 
 copy with zone for singleton
 
 */
- (id)copyWithZone:(NSZone *)zone
{
#pragma unused(zone)
    return self;
}

#pragma mark -
#pragma mark Menu handling

/*
 
 - validateMenuItem:
 
 */
- (BOOL)validateMenuItem:(NSMenuItem *)anItem
{
	BOOL enableMenuItem = YES;
	SEL action = [anItem action];
	
	id responder = [[NSApp keyWindow] firstResponder];
	if (![responder isKindOfClass:[SMLTextView class]]) {
		return NO;
	}
	
	// All items who should only be active if something is selected
	if (action == @selector(removeNeedlessWhitespaceAction:) ||
		   action == @selector(removeLineEndingsAction:) ||
		   action == @selector(entabAction:) ||
		   action == @selector(detabAction:) ||
		   action == @selector(capitaliseAction:) ||
		   action == @selector(toUppercaseAction:) ||
		   action == @selector(toLowercaseAction:)
		   ) { 
		if ([responder selectedRange].length < 1) {
			enableMenuItem = NO;
		}
	}
    // Comment Or Uncomment
    else if (action == @selector(commentOrUncommentAction:) ) {
		if ([[[[[responder fragaria] objectForKey:ro_MGSFOSyntaxColouring] syntaxDefinition] firstSingleLineComment] isEqualToString:@""]) {
			enableMenuItem = NO;
		}
	} 
	
	return enableMenuItem;
}

/*
 
 - emptyDummyAction:
 
 */
- (IBAction)emptyDummyAction:(id)sender
{
	// An easy way to enable menu items with submenus without setting an action which actually does something
}


#pragma mark -
#pragma mark Text shifting

/*
 
 - shiftLeftAction:
 
 */
- (IBAction)shiftLeftAction:(id)sender
{	
    [NSApp sendAction:@selector(shiftLeft:) to:nil from:sender];
}

/*
 
 - shiftRightAction:
 
 */
- (IBAction)shiftRightAction:(id)sender
{
	[NSApp sendAction:@selector(shiftRight:) to:nil from:sender];
}

#pragma mark -
#pragma mark Text manipulation

/*
 
 - interchangeAdjacentCharactersAction:
 
 */
- (IBAction)interchangeAdjacentCharactersAction:(id)sender
{
    [NSApp sendAction:@selector(transpose:) to:nil from:sender];
}

/*
 
 - removeNeedlessWhitespaceAction:
 
 */
- (IBAction)removeNeedlessWhitespaceAction:(id)sender
{
	[NSApp sendAction:@selector(removeNeedlessWhitespace:) to:nil from:sender];
}

/*
 
 - toLowercaseAction:
 
 */
- (IBAction)toLowercaseAction:(id)sender
{
	[NSApp sendAction:@selector(lowercaseCharacters:) to:nil from:sender];
}

/*
 
 - toUppercaseAction:
 
 */
- (IBAction)toUppercaseAction:(id)sender
{
	[NSApp sendAction:@selector(uppercaseCharacters:) to:nil from:sender];
}

/*
 
 - capitaliseAction:
 
 */
- (IBAction)capitaliseAction:(id)sender
{
	[NSApp sendAction:@selector(capitalizeWord:) to:nil from:sender];
}

/*
 
 - entabAction:
 
 */
- (IBAction)entabAction:(id)sender
{
	[NSApp sendAction:@selector(entab:) to:nil from:sender];
}

/*
 
 - detabAction
 
 */
- (IBAction)detabAction:(id)sender
{
    [NSApp sendAction:@selector(detab:) to:nil from:sender];
}


- (void)performDetab
{
    NSLog(@"MGSTextMenuController is deprecated. Please send this message directly to the text view instead of using MGSTextMenuController.");
}


- (void)performEntab
{
    NSLog(@"MGSTextMenuController is deprecated. Please send this message directly to the text view instead of using MGSTextMenuController.");
}


#pragma mark -
#pragma mark Goto

/*
 
 - goToLineAction:
 
 */
- (IBAction)goToLineAction:(id)sender
{
	[NSApp sendAction:@selector(goToLine:) to:nil from:sender];
}


- (void)performGoToLine:(NSInteger)lineToGoTo
{
    NSLog(@"MGSTextMenuController is deprecated. Please send this message directly to the text view instead of using MGSTextMenuController.");
}


#pragma mark -
#pragma mark Tag manipulation


/*
 
 - closeTagAction:
 
 */
- (IBAction)closeTagAction:(id)sender
{
	[NSApp sendAction:@selector(closeTag:) to:nil from:sender];
}

/*
 
 - prepareForXMLAction:
 
 */
- (IBAction)prepareForXMLAction:(id)sender
{
    [NSApp sendAction:@selector(prepareForXML:) to:nil from:sender];
}

#pragma mark -
#pragma mark Comment handling

/*
 
 - commentOrUncommentAction:
 
 */
- (IBAction)commentOrUncommentAction:(id)sender
{
	[NSApp sendAction:@selector(commentOrUncomment:) to:nil from:sender];
}

#pragma mark -
#pragma mark Line endings

/*
 
 - removeLineEndingsAction:
 
 */
- (IBAction)removeLineEndingsAction:(id)sender
{
	[NSApp sendAction:@selector(removeLineEndings:) to:nil from:sender];
}

/*
 
 - changeLineEndingsAction:
 
 */
- (IBAction)changeLineEndingsAction:(id)sender
{
    [NSApp sendAction:@selector(changeLineEndings:) to:nil from:sender];
}


@end
