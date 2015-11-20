//
//  BLCCommentTests.m
//  
//
//  Created by Larry Lynn on 11/17/15.
//
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

<<<<<<< HEAD
#import "BLCComment.h"

=======
>>>>>>> 7cb5c1d7aa28c6480db1608271c09cc6e3f8a10d
@interface BLCCommentTests : XCTestCase

@end

@implementation BLCCommentTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

<<<<<<< HEAD
//- (void)testExample {
//    // This is an example of a functional test case.
//    XCTAssert(YES, @"Pass");
//}

- (void)testThatInitializationWorks
{
    NSDictionary *sourceDictionary = @{@"id": @"8675309",
                                       @"text" : @"Sample Comment"};
    
    BLCComment *testComment = [[BLCComment alloc] initWithDictionary:sourceDictionary];
    
    XCTAssertEqualObjects(testComment.idNumber, sourceDictionary[@"id"], @"The ID number should be equal");
    XCTAssertEqualObjects(testComment.text, sourceDictionary[@"text"], @"The text should be equal");
=======
- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
>>>>>>> 7cb5c1d7aa28c6480db1608271c09cc6e3f8a10d
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
