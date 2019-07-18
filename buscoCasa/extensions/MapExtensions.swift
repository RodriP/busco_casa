//
//  MapExtensions.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos on 7/18/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {
    
    func center(on location: CLLocation, latitudinalMeters: Double, longitudinalMeters: Double) {
        let region = MKCoordinateRegion(center: location.coordinate,
                                        latitudinalMeters: latitudinalMeters,
                                        longitudinalMeters: longitudinalMeters)
        self.setRegion(region, animated: true)
    }
    
    func center(on location: Location, latitudinalMeters: Double, longitudinalMeters: Double) {
        
        let location = CLLocation(latitude: location.latitude, longitude: location.longitude)
        center(on: location, latitudinalMeters: latitudinalMeters, longitudinalMeters: longitudinalMeters)
    }
    
    func addAnnotation(withTitle title: String, atLocation location: Location) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(location: location)
        annotation.title = title
        addAnnotation(annotation)
    }
    
}

extension MKAnnotation {
    
    var location: Location {
        return (self.coordinate.latitude, self.coordinate.longitude)
    }
    
}

extension MKMapItem {
    
    convenience init(location: Location) {
        self.init(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(location: location)))
    }
}

extension CLLocationCoordinate2D {
    
    init(location: Location) {
        self.init(latitude: location.latitude, longitude: location.longitude)
    }
    
}

extension CLLocation {
    
    convenience init(location: Location) {
        self.init(latitude: location.latitude, longitude: location.longitude)
    }
    
}
