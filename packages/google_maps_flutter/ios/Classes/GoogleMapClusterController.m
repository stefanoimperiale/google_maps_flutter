#import "GoogleMapClusterController.h"
#import "JsonConversions.h"
#import "GoogleMapMarkerController.h"

static CLLocationCoordinate2D ToLocation(NSArray* data) {
  return [FLTGoogleMapJsonConversions toLocation:data];
}

@implementation FLTGoogleMapClusterController

- (instancetype)initClusterItemWithId: clusterItemId
                                       andOptions:markerOptions;{
  if ((self = [super init])) {
    _position = markerOptions.position;
    _name = markerOptions.title;
    _snippet = markerOptions.snippet;
    _clusterItemId = clusterItemId;
    _consumeTapEvents = markerOptions.consumeTapEvents;
    _icon = markerOptions.icon;
  } 
  return self;
}

@end

@implementation FLTClusterController {
  NSMutableDictionary* _clusterIdToController;
  FlutterMethodChannel* _methodChannel;
  NSObject<FlutterPluginRegistrar>* _registrar;
  GMSMapView* _mapView;
}
- (instancetype)init:(FlutterMethodChannel*)methodChannel
             mapView:(GMSMapView*)mapView
           registrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  self = [super init];
  if (self) {
    _methodChannel = methodChannel;
    _mapView = mapView;
    _clusterIdToController = [NSMutableDictionary dictionaryWithCapacity:1];
    _registrar = registrar;
  }
  return self;
}
- (void)addClusterItems:(NSArray*)clustersItemToAdd {
  for (NSDictionary* clusterItem in clustersItemToAdd) {
    FLTMakerOptions* markerOptions = [[FLTMarkerOptions alloc] init];
    NSString* clusterItemId = [markerOptions build:clusterItem registrar:_registrar];
    [self addClusterItem:clusterItemId withOptions:markerOptions];
  }
  // Call cluster() after items have been added to perform the clustering and rendering on map.
  [_clusterManager cluster];
}
- (void)addClusterItem:(NSString*)clusterItemId withOptions:(FLTMarkerOptions*) markerOptions{
  FLTGoogleMapClusterController* clusterItem = [[FLTGoogleMapClusterController alloc] initClusterItemWithId: clusterItemId
                                                andOptions:markerOptions];
  [_clusterManager addItem:clusterItem];
  _clusterIdToController[markerId] = clusterItem; 
}

- (void)changeClusterItems:(NSArray*)clustersItemToChange {
  for (NSDictionary* clusterItem in clustersItemToChange) {
    [self changeClusterItem:clusterItem];
  }
}

- (void)changeClusterItem:(NSDictionary*)clusterItem {
   NSString* clusterItemId = [FLTMarkersController getMarkerId:clusterItem];
   FLTGoogleMapClusterController* clusterItemController =  _clusterIdToController[clusterItemId];
    // TODO: to be done
      /*  if (clusterItemController != null) {
        Convert.interpretMarkerOptions(clusterItem, controller);
        }*/
}

- (BOOL)onClusterItemTap:(FLTGoogleMapClusterController*)clusterItemController {
   NSString *clusterItemId = clusterItemController.clusterItemId;
   if (!clusterItemId) {
       return NO;
   }
   [_methodChannel invokeMethod:@"clusterItem#onTap" arguments:@{@"markerId" : clusterItemId}];
   FLTGoogleMapMarkerController* controller = _clusterIdToController[clusterItemId];
   if (!controller) {
     return NO;
   }
   return NO;//controller.consumeTapEvents;
}

-(BOOL)onClusterTap:(id<GMUCluster>)cluster {
   [CATransaction begin];
   [CATransaction setValue:[NSNumber numberWithFloat: 1.0f] forKey:kCATransactionAnimationDuration];
  GMSCameraPosition *newCamera =
      [GMSCameraPosition cameraWithTarget:cluster.position zoom:_mapView.camera.zoom + 1];
  GMSCameraUpdate *update = [GMSCameraUpdate setCamera:newCamera];
  [_mapView animateWithCameraUpdate:update];
  [CATransaction commit];
  return YES;
}
@end
