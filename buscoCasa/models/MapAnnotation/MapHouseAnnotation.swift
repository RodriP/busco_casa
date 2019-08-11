//
//  MapHouseAnnotation.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos Costa on 8/10/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import Foundation
import MapKit

class MapHouseAnnotation : NSObject, MKAnnotation{
    
    @objc dynamic var coordinate = CLLocationCoordinate2D()
    
    // Required if you set the annotation view's `canShowCallout` property to `true`
    var title: String? = NSLocalizedString("SAN_FRANCISCO_TITLE", comment: "SF annotation")
    
    public var image : String
    
    public var price : Double
    
    init(image : String, title: String, price: Double, latitude: Double, longitude: Double) {
        self.image = image
        self.price = price
        self.title = title
        self.coordinate.latitude = latitude
        self.coordinate.longitude = longitude
    }
    
}