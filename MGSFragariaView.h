//
//  MGSFragariaView.h
//  Fragaria
//
//  File created by Jim Derry on 2015/02/07.
//
//  Implements an NSView subsclass that abstracts several characteristics of Fragaria,
//  such as the use of Interface Builder to set delegates and assign key-value pairs.
//  Also provides property abstractions for Fragaria's settings and methods.
//

#import <Cocoa/Cocoa.h>
#import "MGSFragariaFramework.h"


@class MGSFragaria;


@interface MGSFragariaView : NSView


#pragma mark - DELEGATES

@property (assign) IBOutlet id <MGSFragariaTextViewDelegate> delegate;

@property (assign) IBOutlet id <MGSBreakpointDelegate> breakPointDelegate;           

@property (assign) IBOutlet id <SMLSyntaxColouringDelegate> syntaxColoringDelegate;


#pragma mark - KEY FRAGARIA METHOD-TO-PROPERTY PROMOTIONS

@property (assign) NSString *string;

@property (assign) NSAttributedString *attributedString;

@property (assign) BOOL syntaxColoured;

@property (assign) BOOL showsLineNumbers;

@property (assign) BOOL lineWrap;                   

@property (assign) BOOL hasVerticalScroller;        

@property (assign) BOOL scrollElasticityDisabled;   

@property (assign) NSUInteger startingLineNumber;   

@property (assign) NSString *syntaxDefinitionName;  

@property (assign) NSString *documentName;

@property (assign) id <MGSSyntaxErrors> syntaxErrors;

@property (assign) BOOL showsWarningsInGutter;

@property (assign) BOOL showsWarningsInEditor;


#pragma mark - KEY FRAGARIA METHOD PROMOTIONS

- (void)goToLine:(NSInteger)lineToGoTo centered:(BOOL)centered highlight:(BOOL)highlight; // From @bitstadium dcc9bffac7aadb1266e934f11afc570a4071592e


#pragma mark - DIRECT ACCESS

@property (strong, readonly) MGSFragaria *fragaria;

@property (assign) NSTextView *textView;


@end
