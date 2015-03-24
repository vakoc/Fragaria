//
//  MGSColourToPlainTextTransformer.m
//  Fragaria
//
//  Created by Jim Derry on 3/23/15.
//
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "MGSColourToPlainTextTransformer.h"


@interface MGSColourToPlainTextTransformerTests : XCTestCase

@end


@implementation MGSColourToPlainTextTransformerTests


/*
 * - setUp
 */
- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}


/*
 * - tearDown
 */
- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


/*
 * - test_transform_color_back_and_forth
 */
- (void)test_transform_color_back_and_forth
{
	NSValueTransformer *xformer = [NSValueTransformer valueTransformerForName:@"MGSColourToPlainTextTransformer"];
	
	NSColor *color = [NSColor colorWithCalibratedRed:0.1f green:0.35f blue:1.0f alpha:1.0f];
	
	NSDictionary *result = [xformer transformedValue:color];
	
	NSString *red = [result objectForKey:@"red"];
	NSString *green = [result objectForKey:@"green"];
	NSString *blue = [result objectForKey:@"blue"];
	NSString *alpha = [result objectForKey:@"alpha"];
	
	XCTAssert([red isEqualToString:@"19"]);
	XCTAssert([green isEqualToString:@"59"]);
	XCTAssert([blue isEqualToString:@"ff"]);
	XCTAssert([alpha isEqualToString:@"ff"]);
	
	[result setValue:@"00" forKey:@"red"];
	[result setValue:@"80" forKey:@"green"];
	[result setValue:@"80" forKey:@"blue"];
	[result setValue:@"fF" forKey:@"alpha"];
	
	color = [xformer reverseTransformedValue:result];
	
	XCTAssert([color.description isEqual:@"NSCalibratedRGBColorSpace 0 0.501961 0.501961 1"]);
	
    XCTAssert(YES, @"Pass");
}



@end
