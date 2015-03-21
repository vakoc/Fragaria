//
//  MGSColourSchemeControllerTests.m
//  Fragaria
//
//  Created by Jim Derry on 3/17/15.
//
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "MGSColourSchemeController.h"
#import "MGSColourScheme.h"


/**
 *  Basic tests for MGSColourSchemeController.
 *
 *  @discuss Testing of actual loading of color schemes will have to be done
 *  in the UI, as it's rather inconvenient to coerce the testing framework into
 *  loading resources from alternate locations.
 **/
@interface MGSColourSchemeControllerTests : XCTestCase

@end

@implementation MGSColourSchemeControllerTests


/*
 * - setUp
 */
- (void)setUp
{
    [super setUp];
}


/*
 * - tearDown
 */
- (void)tearDown
{
    [super tearDown];
}


/*
 * - test_colourSchemes
 *   This test requires manually installing `Colour Schemes/` into
 *   `Application Support/MGSFragaria Framework Unit Tests/` to work.
 */
//- (void)test_colourSchemes
//{
//	MGSColourSchemeController *controller = [[MGSColourSchemeController alloc] init];
//
//	 
//	
//	XCTAssert([[controller.colourSchemes valueForKey:@"@count"] integerValue] > 0);
//
//	MGSColourScheme *scheme = controller.selection;
//	MGSColourScheme *scheme = [controller.colourSchemes valueForKey:@"Abba"];
//	[scheme writeToFile:@"/Users/jderry/Desktop/file.plist"];
//}


@end
