# Readme_Tests.md

## Introduction

These Tests try to address Integration/API level testing.
IndoorAtlas APIs expect API_KEY, API_SECRET & FLOORPLAN_ID as inputs.
Once the inputs are received indoorAtlas takes care of tracking location on the map.

## Tests

Tests were run on simulator (iPhone 5s).
Following Tests are written --

* testValidInput -- Test to check location data is received when valid values of API_KEY, API_SECRET & FLOORPLAN_ID are given.
* testInvalidKey -- Test to check error status is received when invalid API_KEY is given.
* testInvalidSecret -- Test to check error status is received when invalid API_SECRET is given.
* testInvalidFloorId -- Test to check error status is received when invalid FLOORPLAN_ID is given.
* testNilFloorId -- Test to check no error status is received when "nil" FLOORPLAN_ID is given.
* testValidFloorPlanId -- Test to check valid floorplan identifier & url is received when valid FLOORPLAN_ID is given
* testInvalidFloorPlanId -- Test to check error is thrown when invalid FLOORPLAN_ID is given

## Assumptions

Based on observed behaviour of the system, following assumptions are made --
* For Invalid Key and/or Secret, error is flagged by setting status to **kIAStatusServiceOutOfService**.
* For Invalid FLOORPLAN_ID, error is flagged by setting status to **kIAStatusServiceLimited**.
* For nil FLOORPLAN_ID, success is indicated by setting status to **kIAStatusServiceAvailable**.

## Further Improvements

* One can also think about comparing floor plan images once we get image url from the floor plan.
* We can also think about checking exit region test by faking location on the device.
