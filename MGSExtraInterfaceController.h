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
#import "SMLTextView+MGSTextActions.h"


/** MGSExtraInterfaceController displays and controls the NSPanels used
 *  by SMLTextView's methods which require an interaction with the user. */

@interface MGSExtraInterfaceController : NSObject {
	IBOutlet NSTextField *spacesTextFieldEntabWindow;
	IBOutlet NSTextField *spacesTextFieldDetabWindow;
	IBOutlet NSTextField *lineTextFieldGoToLineWindow;
	IBOutlet NSWindow *entabWindow;
	IBOutlet NSWindow *detabWindow;
	IBOutlet NSWindow *goToLineWindow;
	
	IBOutlet NSView *openPanelAccessoryView;
	IBOutlet NSPopUpButton *openPanelEncodingsPopUp;
	
	IBOutlet NSWindow *commandResultWindow;
	IBOutlet NSTextView *commandResultTextView;
	
	IBOutlet NSPanel *regularExpressionsHelpPanel;
}

/// @name Properties

@property SMLTextView *completionTarget;                              ///< The view which will be sent a perform message to after an entab, detab, goto action is confirmed by dismissing the corresponding dialog.
@property (readonly) IBOutlet NSView *openPanelAccessoryView;         ///< Accessory view for open panel.
@property (readonly) IBOutlet NSPopUpButton *openPanelEncodingsPopUp; ///< Button that will open encodings popup.
@property (readonly) IBOutlet NSWindow *commandResultWindow;          ///< Results window for commands.
@property (readonly) IBOutlet NSTextView *commandResultTextView;      ///< Text view for command results.

/// @name Action Methods

- (IBAction)entabButtonEntabWindowAction:(id)sender;                  ///< @param sender Object sending the action.
- (IBAction)detabButtonDetabWindowAction:(id)sender;                  ///< @param sender Object sending the action.
- (IBAction)cancelButtonEntabDetabGoToLineWindowsAction:(id)sender;   ///< @param sender Object sending the action.
- (IBAction)goButtonGoToLineWindowAction:(id)sender;                  ///< @param sender Object sending the action.

/// @name Implementers

- (void)displayEntab;                                                 ///< Displays the entab sheet.
- (void)displayDetab;                                                 ///< Displays the detab sheet.
- (void)displayGoToLine;                                              ///< Displays the go to line sheet.
- (void)showCommandResultWindow;                                      ///< Displays the command result window.
- (void)showRegularExpressionsHelpPanel;                              ///< Displays the regex help panel.


@end
