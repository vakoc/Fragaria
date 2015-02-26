//
//  MyDocument.h
//  Fragaria Document
//
//  Created by Jonathan on 24/07/2010.
//  Copyright 2010 mugginsoft.com. All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import <MGSFragaria/MGSFragariaTextViewDelegate.h>

@class MGSFragaria;

@interface MyDocument : NSDocument <MGSFragariaTextViewDelegate> {
	IBOutlet NSView *editView;
	MGSFragaria *fragaria;
	BOOL isEdited;
}

@property (nonatomic,assign) NSString *syntaxDefinition;

@end
