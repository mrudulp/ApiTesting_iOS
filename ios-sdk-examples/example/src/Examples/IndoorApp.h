//
//  indoorApp.h
//  
//
//  Created by Mrudul Pendharkar on 18/11/15.
//
//

#import <Foundation/Foundation.h>

@protocol IndoorAppProtocol <NSObject>

-(void)locationEntered:(NSString*)identifier;
-(void)statusChanged:(NSString*)status;
-(void)sendFloorPlanIdUrl:(NSString*)identifier imageUrl:(NSString*)url error:(NSError*)err;

@end

@interface IndoorApp : NSObject

@property (atomic)id <IndoorAppProtocol>indoorAppProtocolDelegate;

- (void)authenticateAndRequestLocation :(NSString*)API_Key SECRET:(NSString*)API_Secret FloorIDorNil:(NSString*)Floor_ID ;
- (void)fetchFloorPlanWithId:(NSString*)floorPlanId;

@end
