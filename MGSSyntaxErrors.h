//
//  MGSSyntaxErrors.h
//  Fragaria
//
//  Created by Jim Derry on 2/14/15.
//
//

#import <Foundation/Foundation.h>
#import "MGSSyntaxErrorProtocols.h"

/**
 *  MGSSyntaxErrors implements the <MGSSyntaxErrors> protocol for Fragaria.
 *  Refer to the protocol header or documentation for a description of the
 *  methods and properties implemented here.
 **/

@interface MGSSyntaxErrors : NSObject <MGSSyntaxErrors>

/// @name Instance Methods - Instantiaton

- (instancetype)initWithErrorsFromArray:(NSArray *)errors;


/// @name Instance Methods - Setting and clearing errors

- (void)addErrorFromDictionary:(NSDictionary*)error;       

- (void)addError:(id<MGSSyntaxError>)error;                


/// @name Instance Methods - Accessing error data

- (NSArray *)linesWithErrors;

- (NSUInteger)errorCountForLine:(NSInteger)line;

- (id<MGSSyntaxError>)errorForLine:(NSInteger)line;

- (NSArray*)errorsForLine:(NSInteger)line;                       

- (NSArray *)nonHiddenErrors;


/// @name Properties

@property (nonatomic, strong) NSArray* syntaxErrors;

@end
