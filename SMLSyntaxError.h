//
//  SMLSyntaxError.h
//  Fragaria
//
//  Created by Viktor Lidholt on 4/9/13.
//
//

#import <Foundation/Foundation.h>
#import "MGSSyntaxErrorProtocols.h"

/**
 *  SMLSyntax error implements the <MGSSyntaxError> protocol for Fragaria.
 *  Refer to the protocol header or documentation for a description of the
 *  methods and properties implemented here.
 **/
@interface SMLSyntaxError : NSObject <MGSSyntaxError>

/// @name Methods to implement for <MGSSyntaxError>

+ (instancetype) errorWithDictionary:(NSDictionary *)dictionary;

+ (NSImage *)imageForWarningStyle:(MGSSyntaxErrorType)style;

- (instancetype)initWithDictionary:(NSDictionary *)errorDict;

/// @name Properties for <MGSSyntaxError>

@property (nonatomic,assign) int line;
@property (nonatomic,assign) int character;
@property (nonatomic,assign) int length;
@property (nonatomic,copy) NSString* description;
@property (nonatomic,copy) NSString* code;
@property (nonatomic,assign) BOOL hidden;
@property (nonatomic,copy) NSColor *errorLineHighlightColor;
@property (nonatomic,copy) NSColor *errorBackgroundHighlightColor;
@property (nonatomic,copy) NSColor *errorForegroundHilightColor;
@property (nonatomic,assign) MGSSyntaxErrorType warningStyle;
@property (nonatomic,readonly) NSImage *warningImage;

@end
