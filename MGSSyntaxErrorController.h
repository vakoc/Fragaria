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
 *  MGSSyntaxErrorController consists primarily of convenience methods and
 *  properties for internal use by Fragaria to handle matters related to
 *  the Fragaria.syntaxErrors array.
 *
 *  All of this class's methods are implemented as class methods, and as such
 *  there is no requirement to implement singleton instances or to maintain
 *  any type of object ownership.
 **/

@interface MGSSyntaxErrorController : NSObject

/// @name Class Methods

/** 
 *  Returns an array of NSNumber indicating unique line numbers that are assigned errors.
 *  Syntax errors that have hidden == true will not be counted.
 *  @param errorArray is the array of SMLSyntaxError objects to check.
 **/
+ (NSArray *)linesWithErrorsInArray:(NSArray *)errorArray;


/**
 *  Returns the number of errors assigned to line `line`.
 *  Syntax errors that have hidden == true will not be counted.
 *  @param line is the line number to check.
 *  @param errorArray is the array of SMLSyntaxError objects to check.
 **/
+ (NSUInteger)errorCountForLine:(NSInteger)line inArray:(NSArray *)errorArray;


/**
 *  Returns the first error with the highest warningLevel for line `line`.
 *  Syntax errors that have hidden == true will not be counted.
 *  @param line is the line number to check.
 *  @param errorArray is the array of SMLSyntaxError objects to check.
 **/
+ (SMLSyntaxError *)errorForLine:(NSInteger)line inArray:(NSArray *)errorArray;


/**
 *  Returns an array of all of the errors assigned to line `line`.
 *  Syntax errors that have hidden == true will not be counted.
 *  @param line is the line number to check.
 *  @param errorArray is the array of SMLSyntaxError objects to check.
 **/
+ (NSArray*)errorsForLine:(NSInteger)line inArray:(NSArray *)errorArray;


/**
 *  Returns an array of all of the non-hidden errors in `errorArray`.
 *  Syntax errors that have hidden == true will not be returned.
 *  @param errorArray is the array of SMLSyntaxError objects to check.
 **/
+ (NSArray *)nonHiddenErrorsInArray:(NSArray*)errorArray;


/**
 *  Returns an array ensuring that all objects in `errorArray` are
 *  of type SMLSyntaxError.
 *  @param errorArray is the array of SMLSyntaxError objects to check.
 **/
+ (NSArray *)sanitizedErrorsInArray:(NSArray*)errorArray;


/**
 *  Returns an NSDictionary of key-value pairs indicating decorations
 *  suitable for each line.
 *  Syntax errors that have hidden == true will not be counted.
 *  @discussion each key represents a unique line number as NSNUmber,
 *  and its value is an NSImage representing the first error with the
 *  highest warningLevel for that line.
 *  @param errorArray is the array of SMLSyntaxError objects to check.
 **/
+ (NSDictionary *)errorDecorationsInArray:(NSArray *)errorArray;


/**
 *  Returns an NSDictionary of key-value pairs indicating decorations
 *  suitable for each line.
 *  Syntax errors that have hidden == true will not be counted.
 *  @discussion each key represents a unique line number as NSNUmber,
 *  and its value is an NSImage representing the first error with the
 *  highest warningLevel for that line, sized per `size`.
 *  @param errorArray is the array of SMLSyntaxError objects to check.
 *  @param size indicates the size of the image in the dictionary.
 **/
+ (NSDictionary *)errorDecorationsInArray:(NSArray *)errorArray size:(NSSize)size;


@end
