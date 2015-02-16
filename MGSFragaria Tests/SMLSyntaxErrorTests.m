//
//  SMLSyntaxErrorTests.m
//  Fragaria
//
//  Created by Jim Derry on 2/16/15.
//
//

#import <Cocoa/Cocoa.h>
#import "SMLSyntaxError.h"
#import <XCTest/XCTest.h>

@interface SMLSyntaxErrorTests : XCTestCase

@property (nonatomic,strong) NSArray *syntaxErrors;

@end

@implementation SMLSyntaxErrorTests

- (void)setUp {
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
																@"warningLevel" : @(601.223) // panic
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
																}],
						  ];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test_defaultImageForWarningLevel
{
	SMLSyntaxError *test1 = self.syntaxErrors[1]; // sample error 2, panic.
	NSString *result1 = [SMLSyntaxError defaultImageForWarningLevel:test1.warningLevel].name;
	NSString *expect1 = @"messagesPanic";
	
	XCTAssert([result1 isEqualToString:expect1]);
}


@end
