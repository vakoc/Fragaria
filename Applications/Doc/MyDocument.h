//
//  MyDocument.h
//  Fragaria Document
//
//  Created by Jonathan on 24/07/2010.
//  Copyright 2010 mugginsoft.com. All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import <MGSFragaria/MGSFragariaTextViewDelegate.h>
#import <MGSFragaria/SMLSyntaxColouringDelegate.h>
#import <MGSFragaria/MGSDragOperationDelegate.h>


@class MGSFragaria;

@interface MyDocument : NSDocument <MGSFragariaTextViewDelegate, SMLSyntaxColouringDelegate, MGSDragOperationDelegate>

@property (assign) IBOutlet NSView *editView;

@property (nonatomic,assign) NSString *syntaxDefinition;

@end
