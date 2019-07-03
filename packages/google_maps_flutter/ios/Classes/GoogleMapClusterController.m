#import "GoogleMapClusterController.h"
#import "JsonConversions.h"

static CLLocationCoordinate2D ToLocation(NSArray* data) {
  return [FLTGoogleMapJsonConversions toLocation:data];
}

@implementation FLTGoogleMapClusterController

- (instancetype)initClusterItemWithMarker:(GMSMarker*)marker
                                           andMarkerId:(NSString*)markerId
                                           consumeTapEvents:(BOOL)consumeTapEvents
                                           mapView: (GMSMapView*)mapView {
  if ((self = [super init])) {
    _position = marker.position;
    _title = marker.title;
    _snippet = marker.snippet;
    _clusterItemId = markerId;
    _consumeTapEvents = consumeTapEvents; 
    _icon = marker.icon;
    _mapView = mapView;
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
    CLLocationCoordinate2D position = [FLTMarkersController getPosition:clusterItem];
    NSString* clusterItemId = [FLTMarkersController getMarkerId:clusterItem];
    
    FLTGoogleMapMarkerController* controller =
        [[FLTGoogleMapMarkerController alloc] initMarkerWithPosition:position
                                                            markerId:clusterItemId
                                                             mapView:_mapView];
    InterpretMarkerOptions(clusterItem, controller, _registrar);
    [self addClusterItem:clusterItemId withController:controller];
  }

  // Call cluster() after items have been added to perform the clustering and rendering on map.
  [_clusterManager cluster];
}
- (void)addClusterItem:(NSString*)markerId withController:(FLTGoogleMapMarkerController*) controller {
  GMSMarker* marker = [controller getMarker];
  FLTGoogleMapClusterController* clusterItem = [[FLTGoogleMapClusterController alloc] initClusterItemWithMarker: marker
                                                andMarkerId:markerId consumeTapEvents:[controller consumeTapEvents]
                                                mapView:_mapView];
  [_clusterManager addItem:clusterItem];
  _clusterIdToController[markerId] = clusterItem; 
} 
@end