//
//  indoorApp.m
//  
//
//  Created by Mrudul Pendharkar on 18/11/15.
//
//

#import <IndoorAtlas/IALocationManager.h>
#import <IndoorAtlas/IAResourceManager.h>
#import "IndoorApp.h"

@interface IndoorApp () <IALocationManagerDelegate>

@property (nonatomic, strong) IALocationManager* manager;
@property (nonatomic,strong) IAResourceManager* resourceManager;

@end

@implementation IndoorApp

#pragma mark IALocationManagerDelegate methods
/**
 * Position packet handling from IndoorAtlasPositioner
 */
- (void)indoorLocationManager:(IALocationManager*)manager didUpdateLocations:(NSArray*)locations
{
    //(void)manager;
    CLLocation *l = [(IALocation*)locations.lastObject location];
    
    // The accuracy of coordinate position depends on the placement of floor plan image.
    NSLog(@"position changed to coordinate (lat,lon): %f, %f", l.coordinate.latitude, l.coordinate.longitude);
}

-(void) indoorLocationManager:(IALocationManager *)manager statusChanged:(IAStatus *)status{
    NSLog(@"Status:%@",status);
    [self.indoorAppProtocolDelegate statusChanged:status.description];
}

-(void) indoorLocationManager:(IALocationManager *)manager didEnterRegion:(IARegion *)region {
    NSLog(@"Status:%@",region.identifier);
    [self.indoorAppProtocolDelegate locationEntered:region.identifier];
}

#pragma dummy methods for resourceManager

- (void)fetchFloorPlanWithId:(NSString*)floorPlanId{
    [self.resourceManager fetchFloorPlanWithId:floorPlanId andCompletion:^(IAFloorPlan *floorPlan, NSError *error) {
        if (!error) {
            [self.indoorAppProtocolDelegate sendFloorPlanIdUrl:floorPlan.floorPlanId imageUrl:[floorPlan.imageUrl absoluteString] error:nil];
        } else {
            NSLog(@"Error fetching floorplan");
            [self.indoorAppProtocolDelegate sendFloorPlanIdUrl:nil imageUrl:nil error:error];
        }
    }];
    
}

#pragma mark IndoorAtlas API Usage

/**
 * Authenticate to IndoorAtlas services and request location updates
 */
- (void)authenticateAndRequestLocation :(NSString*)API_Key SECRET:(NSString*)API_Secret FloorIDorNil:(NSString*)Floor_ID
{
    // Create IALocationManager and point delegate to receiver
    self.manager = [IALocationManager new];
    
    // Set IndoorAtlas API key and secret
    [self.manager setApiKey:API_Key andSecret:API_Secret];
    
    // Optionally initial location
    IALocation *location = [IALocation locationWithFloorPlanId:Floor_ID];
    self.manager.location = location;
    
    self.manager.delegate = self;
    // Create floor plan manager
    self.resourceManager = [IAResourceManager resourceManagerWithLocationManager:self.manager];

    // Request location updates
    [self.manager startUpdatingLocation];
}


@end

