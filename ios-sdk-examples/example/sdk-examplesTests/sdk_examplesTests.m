//
//  sdk_examplesTests.m
//  sdk-examplesTests
//
//  Created by Mrudul Pendharkar on 18/11/15.
//  Copyright © 2015 IndoorAtlas. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IndoorApp.h"
#import "TestApiKeys.h"

@interface sdk_examplesTests : XCTestCase <IndoorAppProtocol>

@property int i;
@property (atomic) IndoorApp *app;
@property (atomic) XCTestExpectation* expect;
@end

@implementation sdk_examplesTests

const int TIMEOUT = 25;

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.app = [[IndoorApp alloc]init];
    [self.app setIndoorAppProtocolDelegate:self];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testValidInput {
    // This is an example of a Valid Inputs test case.
    self.expect = [self expectationWithDescription:@"TestValidInput"];
    [self.app authenticateAndRequestLocation :kValid_APIKey SECRET:kValid_APISecret FloorIDorNil:kValid_FloorplanId];
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: No Location Update Received");
        }
    }];
}

- (void)testInvalidKey {
    // This is an example of a Invalid Key test case.
    self.expect = [self expectationWithDescription:@"TestInvalidKey"];
    [self.app authenticateAndRequestLocation :kInvalid_APIKey SECRET:kValid_APISecret FloorIDorNil:kValid_FloorplanId];
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: Expected Error Message Not Received");
        }
    }];
//    [self skeletonThreadMain];
}

- (void)testInvalidSecret {
    // This is an example of a Invalid Secret test case.
    self.expect = [self expectationWithDescription:@"TestInvalidSecret"];
    [self.app authenticateAndRequestLocation :kValid_APIKey SECRET:kInvalid_APISecret FloorIDorNil:kValid_FloorplanId];
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error:Expected Error Message Not Received");
        }
    }];
}

- (void)testInvalidFloorId {
    // This is an example of a Invalid FloorId test case.
    self.expect = [self expectationWithDescription:@"TestInvalidFloorId"];
    [self.app authenticateAndRequestLocation :kValid_APIKey SECRET:kValid_APISecret FloorIDorNil:kInvalid_FloorplanId];
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: Expected Error Message Not Received");
        }
    }];
}

- (void)testNilFloorId {
    // This is an example of a Nil FloorId test case.
    self.expect = [self expectationWithDescription:@"TestNilFloorId"];
    [self.app authenticateAndRequestLocation :kValid_APIKey SECRET:kValid_APISecret FloorIDorNil:nil];
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: Expected Error Message Not Received");
        }
    }];
}

- (void)testValidFloorPlanId {
    // This is an example of a ValidFloorPlanId test case.
    self.expect = [self expectationWithDescription:@"TestValidFloorPlanId"];
    [self.app authenticateAndRequestLocation :kValid_APIKey SECRET:kValid_APISecret FloorIDorNil:nil];
    [self.app fetchFloorPlanWithId:kValid_FloorplanId];
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: Resource Not Received");
        }
    }];
}

- (void)testInvalidFloorPlanId {
    // This is an example of a InvalidFloorPlanId test case.
    self.expect = [self expectationWithDescription:@"TestInvalidFloorPlanId"];
    [self.app authenticateAndRequestLocation :kValid_APIKey SECRET:kValid_APISecret FloorIDorNil:nil];
    [self.app fetchFloorPlanWithId:kInvalid_FloorplanId];
    [self waitForExpectationsWithTimeout:TIMEOUT handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: Resource Not Received");
        }
    }];
}

#pragma IndoorAppProtocol
-(void) locationEntered:(NSString*)identifier{
    NSString* test = [self.expect description];
    if ( [test isEqualToString:@"TestValidInput"]){
        if ([identifier isEqualToString:kValid_FloorplanId]) {
            [self.expect fulfill];
        }
    }

}

-(void) sendFloorPlanIdUrl:(NSString *)identifier imageUrl:(NSString *)url error:(NSError*)err{
    NSString* test = [self.expect description];
    if (!err) {
        
        if( [test isEqualToString:@"TestValidFloorPlanId"]){
            NSLog(@"identifier:%@ :: imageUrl:%@",identifier,url);
            XCTAssertEqualObjects(identifier, kValid_FloorplanId);
            XCTAssertEqualObjects(url, kValid_FloorplanId_URL);
            [self.expect fulfill];
        }
    }else{
        if ([test isEqualToString:@"TestInvalidFloorPlanId"]) {
            XCTAssertEqual(err.code, -1008);
            [self.expect fulfill];
        }
    }
}
-(void) statusChanged:(NSString *)status
{
    NSString* test = [self.expect description];
    if( [test isEqualToString:@"TestInvalidKey"]||[test isEqualToString:@"TestInvalidSecret"] ){
        XCTAssertEqualObjects(status, @"kIAStatusServiceOutOfService");
        NSLog(@"*****Exiting with Status***");
        [self.expect fulfill];
    }else if ([test isEqualToString:@"TestInvalidFloorId"]){
        XCTAssertEqualObjects(status, @"kIAStatusServiceLimited");
        NSLog(@"*** Exiting InvalidFloorId ***");
        [self.expect fulfill];
    } else if ([test isEqualToString:@"TestNilFloorId"]){
        XCTAssertEqualObjects(status, @"kIAStatusServiceAvailable");
        NSLog(@"*** Exiting NilFloorId ***");
        [self.expect fulfill];
    }
}
@end
