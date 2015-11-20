//
//  BLCMediaTableViewCellTests.m
//  
//
//  Created by Larry Lynn on 11/17/15.
//
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "BLCMedia.h"
#import "BLCMediaTableViewCell.h"
#import "BLCComposeCommentView.h"



@interface BLCMediaTableViewCellTests : XCTestCase

@end

@implementation BLCMediaTableViewCellTests

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

-(void) testThatInitialzationWorks {
    BLCComposeCommentView *height = [[BLCComposeCommentView alloc] init];
    BLCMedia *imageItems = [[BLCMedia alloc] init];
    CGFloat newImageSize = [BLCMediaTableViewCell heightForMediaItem:imageItems width:320];
    
    XCTAssertTrue(newImageSize == CGRectGetHeight(height.frame), @"The height is incorrect");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
