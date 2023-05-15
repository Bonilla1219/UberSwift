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
        //parent is used to communicate back to our UberMapViewRepresentable
        let parent: UberMapViewRepresentable
        
        init(parent: UberMapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            parent.mapView.setRegion(region, animated: true)
        }
    }
    
}
