//
//  SMLSyntaxError.m
//  Fragaria
//
//  Created by Viktor Lidholt on 4/9/13.
//
//

#import "SMLSyntaxError.h"

@implementation SMLSyntaxError

@synthesize line, character, code, length, description, hideWarning, customBackgroundColor, warningStyle;


#pragma mark - Class Methods

+ (NSImage *)imageForWarningStyle:(MGSErrorType)style
{
    // Note these are in order by MGSErrorType.
    NSArray *imageNames = @[@"messagesWarning", @"messagesAccess", @"messagesConfig", @"messagesDocument", @"messagesInfo", @"messagesWarning",@"messagesError", @"messagesPanic"];
    NSImage *warningImage = [[NSBundle bundleForClass:[self class]] imageForResource:imageNames[style]];
    [warningImage setSize:NSMakeSize(16.0, 16.0)];
    return warningImage;
}


#pragma mark - Property Accessors

- (NSImage *)warningImage
{
    return [[self class] imageForWarningStyle:self.warningStyle];
}

@end
