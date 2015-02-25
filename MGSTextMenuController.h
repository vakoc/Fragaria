/*
 
 MGSFragaria
 Written by Jonathan Mitchell, jonathan@mugginsoft.com
 Find the latest version at https://github.com/mugginsoft/Fragaria
 
 Smultron version 3.6b1, 2009-09-12
 Written by Peter Borg, pgw3@mac.com
 Find the latest version at http://smultron.sourceforge.net

 Copyright 2004-2009 Peter Borg

 Licensed under the Apache License, Version 2.0 (the "License"); you may not use
 this file except in compliance with the License. You may obtain a copy of the
 License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software distributed
 under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
 CONDITIONS OF ANY KIND, either express or implied. See the License for the
 specific language governing permissions and limitations under the License.
*/

#import <Cocoa/Cocoa.h>


DEPRECATED_MSG_ATTRIBUTE("Please send your messages to first responder or to "
                         "Fragaria's text view instead.")

/**
 *  @discussion This entire class is deprecated. Please send your messages
 *              to the first responder to to Fragaria's text view instead.
 **/
@interface MGSTextMenuController : NSObject

/// @deprecated Do not use
+ (MGSTextMenuController *)sharedInstance;

/// @deprecated Do not use
/// @param sender Do not use
- (IBAction)removeNeedlessWhitespaceAction:(id)sender;

/// @deprecated Do not use
/// @param sender Do not use
- (IBAction)detabAction:(id)sender;

/// @deprecated Do not use
/// @param sender Do not use
- (IBAction)entabAction:(id)sender;

/// @deprecated Do not use
- (void)performDetab;

/// @deprecated Do not use
- (void)performEntab;

/// @deprecated Do not use
/// @param sender Do not use
- (IBAction)shiftLeftAction:(id)sender;

/// @deprecated Do not use
/// @param sender Do not use
- (IBAction)shiftRightAction:(id)sender;

/// @deprecated Do not use
/// @param sender Do not use
- (IBAction)toLowercaseAction:(id)sender;

/// @deprecated Do not use
/// @param sender Do not use
- (IBAction)toUppercaseAction:(id)sender;

/// @deprecated Do not use
/// @param sender Do not use
- (IBAction)capitaliseAction:(id)sender;

/// @deprecated Do not use
/// @param sender Do not use
- (IBAction)goToLineAction:(id)sender;

/// @deprecated Do not use
/// @param lineToGoTo Do not use
- (void)performGoToLine:(NSInteger)lineToGoTo;

/// @deprecated Do not use
/// @param sender Do not use
- (IBAction)closeTagAction:(id)sender;

/// @deprecated Do not use
/// @param sender Do not use
- (IBAction)commentOrUncommentAction:(id)sender;

/// @deprecated Do not use
/// @param sender Do not use
- (IBAction)emptyDummyAction:(id)sender;

/// @deprecated Do not use
/// @param sender Do not use
- (IBAction)removeLineEndingsAction:(id)sender;

/// @deprecated Do not use
/// @param sender Do not use
- (IBAction)changeLineEndingsAction:(id)sender;

/// @deprecated Do not use
/// @param sender Do not use
- (IBAction)interchangeAdjacentCharactersAction:(id)sender;

/// @deprecated Do not use
/// @param sender Do not use
- (IBAction)prepareForXMLAction:(id)sender;

@end
