//
//  MapViewController.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos on 6/22/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SwiftKeychainWrapper

class MapViewController: UIViewController{

    @IBOutlet weak var map: MKMapView!
    var user : User!
    private let regionMeters: Double = 1000
    private var houses : HouseModel!
    private let apiClient = APIClient()

    private let locationManager :CustomLocationManager = CustomLocationManager.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = AppConstants.MapConstants.MapTitle
        locationManager.delegate = self
        if locationManager.locationServicesEnabled() {
            locationManager.startUpdatingAlwaysLocation()
        } else {
            showLocationServicesAlert()
        }
        map.showsUserLocation = true
        map.delegate = self
        map.mapType = .standard
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        apiClient.fetchPlaces { result in
            switch result {
            case .success(let places):
                DispatchQueue.main.async {
                    self.houses = places
                    /*for house in houses {
                        let annotation = RestaurantAnnotation(restaurant: restaurant)
                        self.mapView.addAnnotation(annotation)
                    }*/
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let retrievedUser: String? = KeychainWrapper.standard.string(forKey: AppConstants.UserConstants.userSaveData)
        if retrievedUser != nil {
            if let jsonData = retrievedUser!.data(using: .utf8)
            {
                let decoder = JSONDecoder()
                
                do {
                    self.user = try decoder.decode(User.self, from: jsonData)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}



extension MapViewController: LocationManagerDelegate {
    
    func locationManager(_ locataionManager: CustomLocationManager, didUpdateLocation location: Location) {
        map.center(on: location, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
        
        var locValue:CLLocationCoordinate2D = CLLocationCoordinate2D()
        locValue.latitude = locataionManager.location!.latitude
        locValue.longitude = locataionManager.location!.longitude
        
        map.mapType = MKMapType.standard
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        map.setRegion(region, animated: true)
        
    }
    
    func locationManager(_ locationManager: CustomLocationManager, didChangeAuthorizationStatus status: LocationAuthStatus) {
        switch status {
        case .authorized:
            map.showsUserLocation = true
            centerMapOnUserLocation()
        case .notAuthorized:
            showLocationServicesAlert()
        case .notDetermined:
            break
        }
    }
    
    private func centerMapOnUserLocation() {
        guard let lastLocation = locationManager.location else {
            return
        }
        
        map.center(on: lastLocation,
                       latitudinalMeters: regionMeters,
                       longitudinalMeters: regionMeters)
    }
    
    private func showLocationServicesAlert() {
        let actions = [UIAlertAction(title: AppConstants.MapConstants.AskLocationConfigAction, style: UIAlertAction.Style.default, handler: nil), UIAlertAction(title: AppConstants.MapConstants.AskLocationCancelAction, style: UIAlertAction.Style.cancel, handler: nil)]
        
        self.present(AlertDialogUtils.getAlertDialog(title: AppConstants.MapConstants.AskLocationTitle,message:AppConstants.MapConstants.AskLocationMsg, action: actions), animated: true, completion: nil)
    }
}



extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = user.name
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        
        map.addAnnotation(annotation);
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            let pin = ImageStorageUtils.getSavedImage(named: AppConstants.UserConstants.userImageNameToSave + user.name)
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            imageView.image = pin;
            imageView.layer.cornerRadius = imageView.layer.frame.size.width / 2
            imageView.layer.masksToBounds = true
            annotationView?.addSubview(imageView)
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {

    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 2
        return renderer 
    }
}
