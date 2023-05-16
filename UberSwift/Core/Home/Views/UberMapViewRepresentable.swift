//
//  UberMapViewRepresentable.swift
//  UberSwift
//
//  Created by Javier Bonilla on 5/6/23.
//

import Foundation
import SwiftUI
import MapKit


struct UberMapViewRepresentable: UIViewRepresentable {
    let mapView = MKMapView()
    let locationManager = LocationManager()
    @EnvironmentObject var locationViewModel:LocationSearchViewModel
    @Binding var mapState: MapViewState
    
    //setting mapView settings
    //this function shows our map view while the delegate implements the aactuall features
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        //making the mapView = the coordinator that we created at the bottom
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        return mapView
    }
    
    //used to update the view when user chooses where they want to go
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        print("DEBUG: Map state is \(mapState)")
        
        switch mapState {
        case .noInput:
            //if the state is in .noInput, then the map is cleared from polylines and recentered on the user
            context.coordinator.clearMapViewAndRecenterOnUserLocation()
            break
        case .searchingForLocation:
            break
        case .locationSelected:
            if let coordinate = locationViewModel.selectedLocationCoordinate{
                context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
                context.coordinator.configurePolyLine(widthDestinationCoordinate: coordinate)
            }
            break
        }
        
        
//        //if the state is in .noInput, then the map is cleared from polylines and recentered on the user
//        if mapState == .noInput {
//            context.coordinator.clearMapViewAndRecenterOnUserLocation()
//        }
        
    }
    
    
    //this is where we make the coordinator that allows the makeUIView to update depending on what
    //happens in the delegate at the bottom
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}

//this is the coordinator
extension UberMapViewRepresentable{
    //MKMapViewDelegate is used in UIKIT, gives us more ways to manipulate the map that are not
    //available in swiftui but are present in uikit
    class MapCoordinator: NSObject, MKMapViewDelegate{
        // MARK: - Properties
        
        //parent is used to communicate back to our UberMapViewRepresentable
        let parent: UberMapViewRepresentable
        var userLocationCoordinate: CLLocationCoordinate2D?
        var currentRegion:MKCoordinateRegion?
        
        //MARK: - Lifecycle
        
        init(parent: UberMapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        //MARK: - MKMapViewDelegate
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocationCoordinate = userLocation.coordinate
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            
            //setting the region
            self.currentRegion = region
            
            parent.mapView.setRegion(region, animated: true)
        }
        
        //this mapView init gets the polylines to appear on the map
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let over = MKPolylineRenderer(overlay: overlay)
            over.strokeColor = .systemBlue
            over.lineWidth = 6
            return over
        }
        //MARK: - Helpers
        
        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D){
            //remove all the annotations before selecting a new place
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            self.parent.mapView.addAnnotation(anno)
            self.parent.mapView.selectAnnotation(anno, animated: true)
            
            //helps zoom out/move the map to show the pin/annotation
            self.parent.mapView.showAnnotations(parent.mapView.annotations, animated: true)
        }
        
        //creates the polylines and adds them to mapview
        func configurePolyLine(widthDestinationCoordinate coordinate: CLLocationCoordinate2D){
            guard let userLocationCoordinate = self.userLocationCoordinate else {return}
            getDestinationRoute(from: userLocationCoordinate, to: coordinate) { route in
                self.parent.mapView.addOverlay(route.polyline)
            }
        }
        
        //getting the best route to take from and to a location
        func getDestinationRoute(from userLocation: CLLocationCoordinate2D, to destination:CLLocationCoordinate2D, completion: @escaping(MKRoute) -> Void){
            
            let userPlacemark = MKPlacemark(coordinate: userLocation)
            let destPlacemark = MKPlacemark(coordinate: destination)
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: userPlacemark)
            request.destination = MKMapItem(placemark: destPlacemark)
            let directions = MKDirections(request: request)
            
            directions.calculate { response, error in
                if let error = error {
                    print("DEBUG: Failed to get directions error \(error.localizedDescription)")
                    return
                }
                
                guard let route = response?.routes.first else {return}
                completion(route)
            }
            
            
        }
        
        func clearMapViewAndRecenterOnUserLocation(){
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)
            if let currentRegion = currentRegion {
                parent.mapView.setRegion(currentRegion, animated: true)
            }
            
        }
        
    }
    
}
