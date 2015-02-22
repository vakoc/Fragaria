//
//  MGSSyntaxErrorController.h
//  Fragaria
//
//  Created by Jim Derry on 2/15/15.
//
//

#import <Foundation/Foundation.h>
#import "SMLSyntaxError.h"

/**
 *  MGSSyntaxErrorController provides internal services and methods to Fragaria
 *  for managing syntax errors.
 **/

@interface MGSSyntaxErrorController : NSObject


/// @name Properties

/**
 *  MGSSyntaxErrorController will maintain an owned copy of the array of
 *  SMLSyntaxError objects.
 **/
@property (nonatomic, strong) NSArray *syntaxErrors;


/// @name Instance Methods

/**
 *  Initializes the instance with an NSArray of SMLSyntaxError instances.
 *  @param array is the array of SMLSyntaxError objects to check.
 **/
- (instancetype)initWithArray:(NSArray *)array;


/**
 *  Returns an array of NSNumber indicating unique line numbers that are assigned errors.
 *  Syntax errors that have hidden == true will not be counted.
 **/
- (NSArray *)linesWithErrors;


/**
 *  Returns the number of errors assigned to line `line`.
 *  Syntax errors that have hidden == true will not be counted.
 *  @param line is the line number to check.
 **/
- (NSUInteger)errorCountForLine:(NSInteger)line;


/**
 *  Returns the first error with the highest warningLevel for line `line`.
 *  Syntax errors that have hidden == true will not be counted.
 *  @param line is the line number to check.
 **/
- (SMLSyntaxError *)errorForLine:(NSInteger)line;


/**
 *  Returns an array of all of the errors assigned to line `line`.
 *  Syntax errors that have hidden == true will not be counted.
 *  @param line is the line number to check.
 **/
- (NSArray*)errorsForLine:(NSInteger)line;


/**
 *  Returns an array of all of the non-hidden errors in `errorArray`.
 *  Syntax errors that have hidden == true will not be returned.
 **/
- (NSArray *)nonHiddenErrors;


/**
 *  Returns an NSDictionary of key-value pairs indicating decorations
 *  suitable for each line.
 *  Syntax errors that have hidden == true will not be counted.
 *  @discussion each key represents a unique line number as NSNUmber,
 *  and its value is an NSImage representing the first error with the
 *  highest warningLevel for that line.
 **/
- (NSDictionary *)errorDecorations;


/**
 *  Returns an NSDictionary of key-value pairs indicating decorations
 *  suitable for each line.
 *  Syntax errors that have hidden == true will not be counted.
 *  @discussion each key represents a unique line number as NSNUmber,
 *  and its value is an NSImage representing the first error with the
 *  highest warningLevel for that line, sized per `size`.
 *  @param size indicates the size of the image in the dictionary.
 **/
- (NSDictionary *)errorDecorationsHavingSize:(NSSize)size;


/**
 *  Displays an NSPopover indicating the error(s).
 *  @param line ndicates the line number from which errors should be shown.
 *  @param rect indicates the relative location to display the popover.
 *  @param view indicates the view that the popover is relative to.
 **/
- (void)showErrorsForLine:(NSUInteger)line relativeToRect:(NSRect)rect ofView:(NSView*)view;


@end
