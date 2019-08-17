//
//  CustomLocationManager.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos on 7/16/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate : AnyObject{
    func locationManager(_ locataionManager: CustomLocationManager, didUpdateLocation location: Location)
    func locationManager(_ locationManager: CustomLocationManager, didChangeAuthorizationStatus status: LocationAuthStatus)
}

typealias Location = (latitude: Double, longitude: Double)
enum LocationAuthStatus{
    case authorized
    case notAuthorized
    case notDetermined
}
class CustomLocationManager : NSObject {
    static let shared: CustomLocationManager = CustomLocationManager()
    weak var delegate: LocationManagerDelegate?
    private let locationManager = CLLocationManager()
    var location : Location? {
        guard let location = locationManager.location else {
            return nil
        }
        return (location.coordinate.latitude, location.coordinate.longitude)
    }
    
    public func startUpdatingAlwaysLocation() {
        setupLocationManager()
        checkLocationAuthorization()
    }
    
    public func locationServicesEnabled() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    private func checkLocationAuthorization() {
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            break
        case .denied:
            print("Usuario no dio permisos")
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
        case .restricted:
            print("Usuario no puede dar permisos de ubicación")
            break
        @unknown default:
            fatalError("Caso no contemplado")
        }
        
    }
    
    private func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    private func checkLocationAutorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            break
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .denied:
            print ("permission denied")
            break
        default:
            fatalError("Unknown permission status")
        }
    }
}

extension CustomLocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {
            return
        }
        
        let location = (lastLocation.coordinate.latitude, lastLocation.coordinate.longitude)
        delegate?.locationManager(self, didUpdateLocation: location)
    }
        
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            delegate?.locationManager(self, didChangeAuthorizationStatus: .authorized)
        case .denied:
            delegate?.locationManager(self, didChangeAuthorizationStatus: .notAuthorized)
        case .restricted:
            delegate?.locationManager(self, didChangeAuthorizationStatus: .notAuthorized)
        case .notDetermined:
            delegate?.locationManager(self, didChangeAuthorizationStatus: .notDetermined)
        @unknown default:
            fatalError("Auth status unknown")
        }
    }
}
