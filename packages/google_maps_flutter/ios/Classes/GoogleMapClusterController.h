// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <Flutter/Flutter.h>
#import <GoogleMaps/GoogleMaps.h>
#import "GoogleMapController.h"
#import <Google-Maps-iOS-Utils/GMUMarkerClustering.h>


// Point of Interest Item which implements the GMUClusterItem protocol.
@interface FLTGoogleMapClusterController : NSObject<GMUClusterItem>

@property(nonatomic, readonly) CLLocationCoordinate2D position;
@property(nonatomic, readonly) NSString *clusterItemId;
@property(nonatomic, readonly) NSString *title;
@property(nonatomic, readonly) NSString *snippet;
@property(nonatomic, readonly) BOOL consumeTapEvents;
@property(nonatomic, readonly) UIImage *icon;
@property(nonatomic, readwrite) NSString *mapView;

- (instancetype)initClusterItemWithPosition:(CLLocationCoordinate2D)position 
    andName:(NSString *)name 
    andClusterItemId: (NSString *)clusterItemId;

@end

@interface FLTClusterController : NSObject

@property(nonatomic, readwrite) GMUClusterManager *clusterManager;

- (instancetype)init:(FlutterMethodChannel*)methodChannel
             mapView:(GMSMapView*)mapView
           registrar:(NSObject<FlutterPluginRegistrar>*)registrar;
- (void)addClusterItems:(NSArray*)clustersItemToAdd;
- (void)changeClusterItems:(NSArray*)clustersItemToChange;
- (void)changeClusterItem:(NSArray*)clusterItemsToChange;
- (void)removeClusterItemsIds:(NSArray*)clusterItemIdsToRemove;
- (BOOL)onClusterItemTap:(FLTGoogleMapClusterController*)clusterItemController;
- (void)onInfoWindowTap:(NSString*)clusterItemId;
- (BOOL)onClusterTap:(id<GMUCluster>)cluster;
@end