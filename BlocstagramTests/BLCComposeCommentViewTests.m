//
//  BLCComposeCommentViewTests.m
//  
//
//  Created by Larry Lynn on 11/17/15.
//
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BLCComposeCommentView.h"


@interface BLCComposeCommentViewTests : XCTestCase

@end

@implementation BLCComposeCommentViewTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//- (void)testExample {
//    // This is an example of a functional test case.
//    XCTAssert(YES, @"Pass");
//}

-(void) testThatCommentIsWritingComment {
    
    BLCComposeCommentView *composeComment = [[BLCComposeCommentView alloc] init];
    composeComment.text = @"Something is writing";
    XCTAssertTrue(composeComment.isWritingComment == YES, @"There is an error in the comment section");
}

-(void) testThatCommentIsNotWritingComment {
    
    BLCComposeCommentView *composeComment = [[BLCComposeCommentView alloc] init];
    composeComment.text = nil;
    XCTAssertTrue(composeComment.isWritingComment == NO, @"There is an error in the comment section");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
