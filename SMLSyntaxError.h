//
//  SMLSyntaxError.h
//  Fragaria
//
//  Created by Viktor Lidholt on 4/9/13.
//
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger
{
    kMGSErrorDefault  = 0,
    kMGSErrorAccess   = 1,
    kMGSErrorConfig   = 2,
    kMGSErrorDocument = 3,
    kMGSErrorInfo     = 4,
    kMGSErrorWarning  = 5,
    kMGSErrorError    = 6,
    kMGSErrorPanic    = 7
} MGSErrorType;

@interface SMLSyntaxError : NSObject
{
    NSString* description;
    int line;
    int character;
    NSString* code;
    int length;
    BOOL hideWarning;
    NSColor *customBackgroundColor;
    MGSErrorType warningStyle;
}

+ (NSImage *)imageForWarningStyle:(MGSErrorType)style;

@property (nonatomic,copy) NSString* description;
@property (nonatomic,assign) int line;
@property (nonatomic,assign) int character;
@property (nonatomic,copy) NSString* code;
@property (nonatomic,assign) int length;
@property (nonatomic,assign) BOOL hideWarning;
@property (nonatomic,copy) NSColor *customBackgroundColor;
@property (nonatomic,assign) MGSErrorType warningStyle;
@property (nonatomic,readonly) NSImage *warningImage;

@end
