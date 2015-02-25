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


@class MGSLineNumberView;


/**
 *  MGSLineNumberDefaultsObserver observes for some basic settings changes, and then
 *  updates the MGSLineNumberView. It also provides the initial appearance
 *  conditions.
 *  @todo: (jsd) Essentially the only thing this class currently does is monitor
 *         changes in defaults. This should eventually be completely replaced with
 *         properties in MGSFragaria.
 **/
@interface MGSLineNumberDefaultsObserver : NSObject


/** Designated initializer. Initializes the class for controlling the specified
 * MGSLineNumberView.
 * @param lnv The MGSLineNumberView instance to be controlled. */
- (instancetype)initWithLineNumberView:(MGSLineNumberView *)lnv;

/** Updates the MGSLineNumberView instance with the new appearance settings. */
- (void)updateGutterView;


/** The controlled line number view. */
@property (readonly) MGSLineNumberView *lineNumberView;


@end

