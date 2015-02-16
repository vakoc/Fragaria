//
//  MGSSyntaxErrorControllerTests.m
//  Fragaria
//
//  Created by Jim Derry on 2/15/15.
//
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

#import "MGSSyntaxErrorController.h"
#import "SMLSyntaxError.h"

@interface MGSSyntaxErrorControllerTests : XCTestCase

@property (nonatomic,strong) NSArray *syntaxErrors;

@end

@implementation MGSSyntaxErrorControllerTests

- (void)setUp
{
    [super setUp];

    self.syntaxErrors = @[
                          [SMLSyntaxError errorWithDictionary:@{
                                                                @"description" : @"Sample error 1.",
                                                                @"line" : @(4),
                                                                @"hidden" : @(NO),
                                                                @"warningLevel" : @(kMGSErrorCategoryAccess)
                                                                }],

                          [SMLSyntaxError errorWithDictionary:@{
                                                                @"description" : @"Sample error 2.",
                                                                @"line" : @(4),
                                                                @"hidden" : @(YES),
                                                                @"warningLevel" : @(kMGSErrorCategoryPanic)
                                                                }],
                          [SMLSyntaxError errorWithDictionary:@{
                                                                @"description" : @"Sample error 3.",
                                                                @"line" : @(37),
                                                                @"hidden" : @(NO),
                                                                @"warningLevel" : @(kMGSErrorCategoryDocument)
                                                                }],
                          [SMLSyntaxError errorWithDictionary:@{
                                                                @"description" : @"Sample error 4.",
                                                                @"line" : @(37),
                                                                @"hidden" : @(NO),
                                                                @"warningLevel" : @(kMGSErrorCategoryDocument)
                                                                }],
                          [NSString stringWithFormat:@"%@", @"I don't belong here."],
                          [SMLSyntaxError errorWithDictionary:@{
                                                                @"description" : @"Sample error 5.",
                                                                @"line" : @(189),
                                                                @"hidden" : @(NO),
                                                                @"warningLevel" : @(kMGSErrorCategoryError)
                                                                }],
                          [SMLSyntaxError errorWithDictionary:@{
                                                                @"description" : @"Sample error 6.",
                                                                @"line" : @(212),
                                                                @"hidden" : @(YES),
                                                                @"warningLevel" : @(kMGSErrorCategoryPanic)
                                                                }],
                          ];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)test_linesWithErrorsInArray
{
    NSArray *result = [[MGSSyntaxErrorController linesWithErrorsInArray:self.syntaxErrors] sortedArrayUsingSelector:@selector(compare:)];
    NSArray *expects = @[@(4), @(37), @(189)];

    XCTAssertEqualObjects(result, expects);
}



- (void)test_errorCountForLine
{
    NSInteger result4 = [MGSSyntaxErrorController errorCountForLine:4 inArray:self.syntaxErrors];
    NSInteger result37 = [MGSSyntaxErrorController errorCountForLine:37 inArray:self.syntaxErrors];
    NSInteger result189 = [MGSSyntaxErrorController errorCountForLine:189 inArray:self.syntaxErrors];
    NSInteger result212 = [MGSSyntaxErrorController errorCountForLine:212 inArray:self.syntaxErrors];

    XCTAssert(result4 == 1 && result37 == 2 && result189 == 1 && result212 == 0);
}


- (void)test_errorForLine
{
    // We should get kMGSErrorAccess, because the other error is hidden.
    float result4 = [[MGSSyntaxErrorController errorForLine:4 inArray:self.syntaxErrors] warningLevel];

    // We should get @"Sample error 3." because error level is the same, and this is the first one.
    NSString *result37 = [[MGSSyntaxErrorController errorForLine:37 inArray:self.syntaxErrors] description];

    XCTAssert(result4 == kMGSErrorCategoryAccess && [result37 isEqualToString:@"Sample error 3."]);

}


- (void)test_errorsForLine
{
    SMLSyntaxError *testContent = [[MGSSyntaxErrorController errorsForLine:4 inArray:self.syntaxErrors] objectAtIndex:0];
    NSInteger testQuantity = [[MGSSyntaxErrorController errorsForLine:37 inArray:self.syntaxErrors] count];

    XCTAssert([testContent.description isEqualToString:@"Sample error 1."] && testQuantity == 2);
}


- (void)test_nonHiddenErrorsInArray
{
    NSInteger testQuantity = [[MGSSyntaxErrorController nonHiddenErrorsInArray:self.syntaxErrors] count];

    XCTAssert(testQuantity == 4);
}


- (void)test_sanitizedErrorsInArray
{
    BOOL pass = YES;
    for (id object in [MGSSyntaxErrorController sanitizedErrorsInArray:self.syntaxErrors])
    {
        if (![object isMemberOfClass:[SMLSyntaxError class]])
        {
            pass = NO;
        }
    }

    XCTAssert(pass == YES);
}


- (void)test_errorDecorationsInArray
{
    NSDictionary *resultDict = [MGSSyntaxErrorController errorDecorationsInArray:self.syntaxErrors];
    NSImage *image = [resultDict objectForKey:@(189)];

    // kMGSErrorError is line 189's image, and that is in the bundle messagesError.icns.
    NSImage *compare = [[NSBundle bundleForClass:[SMLSyntaxError class]] imageForResource:@"messagesError"];

    XCTAssert([[image TIFFRepresentation] isEqualToData:[compare TIFFRepresentation]]);

}


- (void)test_errorDecorationsInArraySize
{
    NSDictionary *resultDict = [MGSSyntaxErrorController errorDecorationsInArray:self.syntaxErrors size:NSMakeSize(123.0, 119.4)];
    NSImage *image = [resultDict objectForKey:@(4)];

    // kMGSErrorAccess is line 4's image, and that is in the bundle messagesError.icns.
    NSImage *compare = [[NSBundle bundleForClass:[SMLSyntaxError class]] imageForResource:@"messagesAccess"];

    XCTAssert([[image TIFFRepresentation] isEqualToData:[compare TIFFRepresentation]] && image.size.width == 123.0 && image.size.height == 119.4 );
}


@end
