//
//  SMLSyntaxError.h
//  Fragaria
//
//  Created by Viktor Lidholt on 4/9/13.
//
//


#import <Foundation/Foundation.h>

/**
 *  MGSErrorType describes the warning level for an error, ranging from least severe to most severe.
 *  This can be used to automatically provide an appropriate image for error displays.
 *
 *  @discussion Components using this class are not currently KVO compliant and do not observe changes
 *  to instances of this class. They expect an NSArray of this class for which they will respond to
 *  changes. Do not modify instances of this class once assigned to your instance of Fragaria; instead
 *  assign a new copy of your syntaxErrors array.
 **/
typedef NS_ENUM(NSInteger, MGSErrorType)
{
    kMGSErrorDefault  = 0,
    kMGSErrorAccess   = 1,
    kMGSErrorConfig   = 2,
    kMGSErrorDocument = 3,
    kMGSErrorInfo     = 4,
    kMGSErrorWarning  = 5,
    kMGSErrorError    = 6,
    kMGSErrorPanic    = 7
};


/**
 *  SMLSyntaxError describes a class that stores syntaxErrors to be handled by Fragaria.
 **/

@interface SMLSyntaxError : NSObject


/// @name Class Methods

/**
 *  This class method will return an image that represents the property `warningLevel`.
 *  The default images are stored in and loaded from the framework bundle automatically.
 *  @param level indicates the level of this error.
 **/
+ (NSImage *)defaultImageForWarningLevel:(MGSErrorType)level;


/**
 *  This class method is a convenience for creating new SMLSyntaxError instances.
 *  @param dictionary indicates a dictionary where each key is the property name.
 **/
+ (instancetype)errorWithDictionary:(NSDictionary *)dictionary;


/// @name Instance Methods

/**
 *  This initializer receives a dictionary of keys and values, where the dictionary
 *  keys correspond to property names of this class.
 *  @param dictionary indicates the dictionary from which to initialize this class.
 **/
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

/// @name Deprecated Class Methods

/**
 *  This class method is a synonym for imageForWarningLevel.
 *  @deprecated Use defaultImageForWarningLevel: instead.
 *  @param style indicates the level of this error.
 **/
+ (NSImage *)imageForWarningStyle:(MGSErrorType)style __deprecated_msg("Use defaultImageForWarningLevel: instead.");


/// @name Properties

@property (nonatomic,assign) int line;                             ///< The line at which this error occurrs.
@property (nonatomic,assign) int character;                        ///< The character position at which this error begins.
@property (nonatomic,assign) int length;                           ///< The character length of this error.
@property (nonatomic,copy) NSString* description;                  ///< A description of this error.
@property (nonatomic,assign) BOOL hidden;                          ///< Indicates whether or not this error is hidden from display.

@property (nonatomic,copy) NSColor *errorLineHighlightColor;       ///< The color to use to highlight lines that have syntax errors.
@property (nonatomic,copy) NSColor *errorBackgroundHighlightColor; ///< The color to use to highlight the background of specific errors.
@property (nonatomic,copy) NSColor *errorForegroundHilightColor;   ///< The color to use to highlight the foreground of specific errors.
@property (nonatomic,assign) MGSErrorType warningLevel;            ///< The warning level or severity of this syntax error.

/**
 *  Specifies an image that should be associated with this syntax error.
 *  @discussion By default this property will return one of the built-in
 *  images that represent the warningLevel. However you can assign your
 *  own image to this property regardless of warningLevel. This property
 *  cannot be nil. Attempts to set it to nil will revert it to the
 *  built-in default.
 **/
@property (nonatomic,strong) NSImage *warningImage;


/**
 * @name Deprecated Properties
 * @todo AppleDoc currently chokes on these; it doesn't like the attributes.
 **/

/// @deprecated This property is not used.
@property (nonatomic,copy) NSString* code __deprecated_msg("This property is not used.");

/// @deprecated Use the warningLevel property instead.
@property (nonatomic,assign) MGSErrorType warningStyle __deprecated_msg("Use the warningLevel property instead.");

/// @deprecated Use the hidden property instead.
@property (nonatomic,assign) BOOL hideWarning __deprecated_msg("Use the hidden property instead.");

/// @deprecated Use the errorLineHighlightColor property.
@property (nonatomic,copy) NSColor *customBackgroundColor __deprecated_msg("Use the errorLineHighlightColor property.");


@end
