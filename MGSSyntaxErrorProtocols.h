//
//  MGSSyntaxErrorProtocols.h
//  Fragaria
//
//  Created by Jim Derry on 2/14/15.
//
//

/**
 *   MGSSyntaxErrorProtocols.h defines the protocols for objects
 *   interacting with Fragaria to provide error services.
 **/


// @todo: defaults colors, default properties, incorporate the popup, etc.

#import <Foundation/Foundation.h>


#pragma mark - Typedef MGSSyntaxErrorType
/**
 *   MGSSyntaxErrorType
 *    An enum indicating the type of syntax error. Classes
 *    adhering to this protocol will import this header,
 *    exposing these values to you.
 **/
typedef NS_ENUM(NSInteger, MGSSyntaxErrorType)
{
    kMGSErrorDefault  = 0, ///< Indicates the default error type.
    kMGSErrorAccess   = 1, ///< Indicates an access error.
    kMGSErrorConfig   = 2, ///< Indicates configuration error.
    kMGSErrorDocument = 3, ///< Indicates a document error.
    kMGSErrorInfo     = 4, ///< Indicates an information error (e.g., to show info that may not be an error).
    kMGSErrorWarning  = 5, ///< Indicates a warning.
    kMGSErrorError    = 6, ///< Indicates an error.
    kMGSErrorPanic    = 7  ///< Indicates a panic.
};


#pragma mark - Protocol MGSSyntaxError
/**
 *   MGSSyntaxError
 *    Defines the protocol for individual syntax errors and is expressed
 *    by default in the class `SMLSyntaxError`.
 **/
@protocol MGSSyntaxError

/// @name Class methods

+ (instancetype) errorWithDictionary:(NSDictionary *)dictionary;   ///< Returns a <MGSSyntaxError> objct from the values in an NSDictionary.

+ (NSImage *)imageForWarningStyle:(MGSSyntaxErrorType)style;       ///< A convenience class method that returns an image for a particular error type.


/// @name Instance methods

- (instancetype)initWithDictionary:(NSDictionary *)errorDict;      ///< Intializes a new instance from an NSDictionary with keys being the property name.


/// @name Properties

@property (nonatomic,assign) int line;                             ///< The line in which the error occurs.
@property (nonatomic,assign) int character;                        ///< The character position in the line where the error begins.
@property (nonatomic,assign) int length;                           ///< The length of the error. Used to highlight individual errors.
@property (nonatomic,copy) NSString* description;                  ///< Text to describe the error.
@property (nonatomic,copy) NSString* code;                         ///< Unknown. @todo: This isn't used in source. Perhaps delete it.
@property (nonatomic,assign) BOOL hidden;                          ///< Indicates if this particular error must be hidden.
@property (nonatomic,copy) NSColor *errorLineHighlightColor;       ///< Indicates the color to use to highlight the line when an error occurs.
@property (nonatomic,copy) NSColor *errorBackgroundHighlightColor; ///< Indicates the color to use to highlight error text (background).
@property (nonatomic,copy) NSColor *errorForegroundHilightColor;   ///< Indicates the folor to use to highlight error text (foreground).

/**
 *   Indicates the overall styling of the warning given when the users accesses
 *   syntax errors. See `MGSSyntaxErrorType` for the minimum warning levels expected
 *   by conforming classes.
 *
 *   @discussion Conforming classes may want to provide different appearance for
 *     different types of warnings. `MGSSyntaxErrors`, for example will produce
 *     different images for different values of warningStyle.
 **/
@property (nonatomic,assign) MGSSyntaxErrorType warningStyle;

@property (nonatomic,readonly) NSImage *warningImage;      ///< Returns an image appropriate to the warningStyle.

@end


#pragma mark - Protocol MGSSyntaxErrors
/**
 *   MGSSyntaxErrors
 *    Defines the protocol for a syntax error manager and utility class
 *    that manages multiple syntax errors and provides services to other
 *    components. It is expressed by default in the class `MGSSyntaxErrors`.
 *
 *    Applications that generate errors are still expected to manage all of
 *    their own errors. As such the protocol does not provide methods for
 *    managing syntax errors beyond adding them and clearing them.
 **/
@protocol MGSSyntaxErrors

/// @name Instance Methods - Instantiation

- (instancetype)initWithErrorsFromArray:(NSArray *)errors; ///< Initilizes a new object from a dictionary of id <MGSSyntaxError> objects.


/// @name Instance Methods - Setting and Clearing Errors

- (void)addErrorFromDictionary:(NSDictionary*)error;       ///< Adds a new error from a dictionary where keys are <MGSSyntaxError> properties.

- (void)addError:(id<MGSSyntaxError>)error;                ///< Adds a new error from an id <MGSSyntaxError> object.


/// @name Instance Methods - Accessing error data


- (NSArray *)linesWithErrors;                               ///< Returns an array of NSNumber containing a list of lines that have errors, ignoring hidden errors.

- (NSUInteger)errorCountForLine:(NSInteger)line;                  ///< Returns the number of errors at the given line, ignoring hidden errors.

/**
 * Returns the error at the given line., ignoring hidden errors.
 *   @discussion If there are multiple errors, then the method
 *   will return the first error with the highest severity.
 **/
- (id<MGSSyntaxError>)errorForLine:(NSInteger)line;

- (NSArray *)errorsForLine:(NSInteger)line;                       ///< Returns all of the errors at the given line as an array of <MGSSyntaxError> objects, ignoring hidden errors.

- (NSArray *)nonHiddenErrors;                               ///< Returns an array of all errors which are not set to hidden.


/// @name Properties

@property (nonatomic, strong) NSArray *syntaxErrors;        ///< Exposes id <MGSSyntaxError> objects for application use. Does *not* ignore hidden.


@end


