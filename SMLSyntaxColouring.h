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
@interface SMLSyntaxColouring : NSObject <SMLAutoCompleteDelegate>


/// @name Properties

/** The owning controller for instances of this class. */
@property (nonatomic, weak, readonly) MGSFragaria *fragaria;

/** The NSUndoManager instance used in this class. */
@property (strong) NSUndoManager *undoManager;

/** The syntax definition that determines how to color the text. */
@property (nonatomic, strong) MGSSyntaxDefinition *syntaxDefinition;

/** The syntax colouring delegate */
@property (weak) id<SMLSyntaxColouringDelegate> syntaxColouringDelegate;

/** Specifies if the syntax colourer has to be disabled or not. */
@property (nonatomic, getter=isSyntaxColoured) BOOL syntaxColoured;


/// @name Instance Methods

/**
 *  Initialize a new instance using a reference to an owning Fragaria..
 *  @param fragaria The instance of fragaria associated with this instance.
 **/
- (id)initWithFragaria:(MGSFragaria *)fragaria;

/**
 *  Recolor the range that is visible.
 **/
- (void)recolourExposedRange;

/**
 *  Invalidates the coloring of the entire document.
 **/
- (void)invalidateAllColouring;

/**
 *  Recolours a view, with the option to color the entire range or only the exposed area.
 *  @param textView The view to color.
 *  @param options A dictionary of options. Currently the only option is `colourAll`, which
 *         may be `YES` or `NO`.
 **/
- (void)pageRecolourTextView:(SMLTextView *)textView options:(NSDictionary *)options;

/**
 *  Recolours on a portion of the document, specified by `rangeToRecolour`.
 *  @param rangeToRecolour Indicates the range to be recoloured.
 **/
- (NSRange)recolourChangedRange:(NSRange)rangeToRecolour;

/**
 *  Indicates whether or not to highlight syntax errors in the document.
 **/
- (void)highlightErrors;

@end
