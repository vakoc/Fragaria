//
//  MGSUserDefaultsDefinitionsTests.m
//  Fragaria
//
//  Created by Jim Derry on 3/9/15.
//
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "MGSUserDefaultsDefinitions.h"
#import "MGSFragariaView.h"
#import "MGSUserDefaultsUtilities.h"


/**
 *  Basic tests for MGSUserDefaultsDefinitions.
 **/

@interface MGSUserDefaultsDefinitionsTests : XCTestCase

@end

@implementation MGSUserDefaultsDefinitionsTests

- (void)setUp
{
    [super setUp];
}


- (void)tearDown
{
    [super tearDown];
}


/*
 *  Ensures that name-spacing inline function works correctly.
 */
- (void)test_namespace_function
{
	NSString *expects = @"MGSFragariaDefaultsUseTabStops";
	
	XCTAssert([expects isEqualToString:[[MGSUserDefaultsDefinitions class] fragariaNamespacedKeyForKey:MGSFragariaDefaultsUseTabStops]]);
}


/*
 *  Ensures the manually-managed defaults dictionary works.
 */
- (void)test_fragariaDefaultsDictionaryWithNamespace
{
	NSLog(@"%@", [MGSUserDefaultsDefinitions fragariaDefaultsDictionaryWithNamespace]);
	id object = [[MGSUserDefaultsDefinitions fragariaDefaultsDictionaryWithNamespace] objectForKey:@"MGSFragariaDefaultsAutoCompleteDelay"];
	XCTAssert(object != nil);
}


/*
 *  Ensures all of the properties are still available in MGSFragariaView.
 */
- (void)test_properties_exist
{
	NSDictionary *properties = [MGSUserDefaultsUtilities propertiesOfClass:[MGSFragariaView class]];
	NSDictionary *localDict = [MGSUserDefaultsDefinitions fragariaDefaultsDictionary];
	NSUInteger count = 0;
	
	for (NSString *key in [localDict allKeys])
	{
		
		if (![[properties allKeys] containsObject:key] )
		{
			count++;
			NSLog(@"Property `%@` not recognized.", key);
		}
	}
	XCTAssert(count == 0, @"%lu of %lu properties not recgonized. Consult the log output for results.", count, localDict.count);
}





@end
