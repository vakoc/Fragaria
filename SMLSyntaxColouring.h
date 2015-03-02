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
#import "MGSFragaria.h"
#import "SMLTextView.h"
#import "SMLAutoCompleteDelegate.h"
#import "MGSSyntaxDefinition.h"
#import "SMLSyntaxColouringDelegate.h"


@class SMLLayoutManager;


/**
 *  Performs syntax colouring on the text editor document.
 **/
@interface SMLSyntaxColouring : NSObject


/// @name Properties

/** The MGSFragaria instance to be passed to the syntax colouring delegate
 * as the fragaria document parameter. */
@property (weak) MGSFragaria *fragaria;

/** The layout manager to be used for setting temporary attributes. */
@property (readonly) NSLayoutManager *layoutManager;

/** The syntax definition that determines how to color the text. */
@property (nonatomic, strong) MGSSyntaxDefinition *syntaxDefinition;

/** The syntax colouring delegate */
@property (weak) id<SMLSyntaxColouringDelegate> syntaxColouringDelegate;

/** Specifies if the syntax colourer has to be disabled or not. */
@property (nonatomic, getter=isSyntaxColoured) BOOL syntaxColoured;

/** Indicates the character ranges where colouring is valid. */
@property (strong, readonly) NSMutableIndexSet *inspectedCharacterIndexes;


/// @name Instance Methods


/** Initialize a new instance using the specified layout manager.
 * @param lm The layout manager associated with this instance. */
- (id)initWithLayoutManager:(NSLayoutManager *)lm;

/** Recolors the invalid characters in the specified range.
 * @param range A character range where, when this method returns, all syntax
 *              colouring will be guaranteed to be up-to-date. */
- (void)recolourRange:(NSRange)range;

/** Marks as invalid the colouring in the range currently visible (not clipped)
 * in the specified text view.
 * @param textView The text view from which to get a character range. */
- (void)invalidateVisibleRangeOfTextView:(SMLTextView *)textView;

/** Marks the entire colouring attributes as invalid. */
- (void)invalidateAllColouring;

/** Forces a recolouring of the character range specified. The recolouring will
 * be done anew even if the specified range is already valid (wholly or in
 * part).
 * @param rangeToRecolour Indicates the range to be recoloured.
 * @return The range that was effectively coloured. The returned range always
 *         contains entirely the intial range. */
- (NSRange)recolourChangedRange:(NSRange)rangeToRecolour;


@end
