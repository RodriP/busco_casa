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
    private var bookmarks : [MapHouseAnnotation] = []
    private var modelHousePresenter : ModelHousePresenter?

    private let locationManager :CustomLocationManager = CustomLocationManager.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = AppConstants.MapConstants.MapTitle
        locationManager.delegate = self
        map.showsUserLocation = true
        map.delegate = self
        map.mapType = .standard
        map.isZoomEnabled = true
        map.isScrollEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if locationManager.locationServicesEnabled() {
            locationManager.startUpdatingAlwaysLocation()
        } else {
            showLocationServicesAlert()
        }
        let userDefaults = UserDefaults.standard

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
        
        let decoded  = userDefaults.data(forKey: AppConstants.UserConstants.userSaveBookmarks + user.name)
        if(decoded != nil){
            bookmarks = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! [MapHouseAnnotation]
        }

        
        if(locationManager.location != nil){
            map.center(on: locationManager.location!, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
            modelHousePresenter = ModelHousePresenter(apiClient: APIClient(latitude: String(locationManager.location!.latitude), longitude: String(locationManager.location!.longitude)))
            modelHousePresenter?.setViewDelegate(houseDelegate: self)
            modelHousePresenter!.getHouseModels()
        
        }
        
        
    }
}


extension MapViewController: HouseModelDelegate {
    
    func displayHouseResults(resultList: [Results], networkError: NetworkError?) {
        if(resultList.isEmpty){
            let actions = [UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)]
            self.present(AlertDialogUtils.getAlertDialog(title: AppConstants.UserConstants.userMapError,message:AppConstants.UserConstants.userMapLocationErrorMsg, action: actions), animated: true, completion: nil)
        } else{
            for place in resultList {
                if(place.location != nil && place.location?.latitude != nil
                    && place.location?.longitude != nil) {
                    let price = place.price as NSNumber
                    
                    let formatter = NumberFormatter()
                    formatter.numberStyle = .currency
                    formatter.string(from: price)
                    formatter.locale = Locale(identifier: "es_AR")
                    
                    let mapAnnotation = MapHouseAnnotation(id: place.id, image: place.thumbnail, title: place.title, subtitle: "Precio: " +                           formatter.string(from: price)!, price: place.price, latitude: place.location!.latitude!, longitude: place.location!.longitude!)
                    self.map.addAnnotation(mapAnnotation)
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
        
        modelHousePresenter = ModelHousePresenter(apiClient: APIClient(latitude: String(locataionManager.location!.latitude), longitude: String(locataionManager.location!.longitude)))
        modelHousePresenter?.setViewDelegate(houseDelegate: self)
        modelHousePresenter!.getHouseModels()
    
        map.mapType = MKMapType.standard
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        map.setRegion(region, animated: true)
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if (control == view.rightCalloutAccessoryView && ((view.annotation as? MapHouseAnnotation) != nil)) {
            if let button = view.rightCalloutAccessoryView as? UIButton {
                if button.isSelected{
                    button.isSelected = false
                    bookmarks = bookmarks.filter(){$0.id != (view.annotation as! MapHouseAnnotation).id}
                } else {
                    bookmarks.append(view.annotation as! MapHouseAnnotation)
                    button.isSelected = true
                }
                let userDefaults = UserDefaults.standard
                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: bookmarks)
                userDefaults.set(encodedData, forKey: AppConstants.UserConstants.userSaveBookmarks + user.name)
                userDefaults.synchronize()
            }
        }
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
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL, imageView : UIImageView) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() {
                imageView.image = UIImage(data: data)
            }
        }
    }
}



extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MapHouseAnnotationView(annotation: annotation, reuseIdentifier: user.name)
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let view = view as? MapHouseAnnotationView else {
            return
        }
        
        view.select()
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 6, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard let view = view as? MapHouseAnnotationView else {
            return
        }
        
        view.deselect()
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 6, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 2
        return renderer 
    }
}
