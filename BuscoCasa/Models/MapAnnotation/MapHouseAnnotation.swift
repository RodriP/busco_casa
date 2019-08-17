//
//  MapHouseAnnotation.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos Costa on 8/10/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import Foundation
import MapKit

class MapHouseAnnotation : NSObject, NSCoding, MKAnnotation{
    
    @objc dynamic var coordinate = CLLocationCoordinate2D()
    
    // Required if you set the annotation view's `canShowCallout` property to `true`
    var title: String? = NSLocalizedString("CUSTOM_TITLE", comment: "custom annotation")
    var subtitle: String? = ""
    public var image : String
    
    public var price : Double
    
    init(image : String, title: String, subtitle: String, price: Double, latitude: Double, longitude: Double) {
        self.image = image
        self.subtitle = subtitle
        self.price = price
        self.title = title
        self.coordinate.latitude = latitude
        self.coordinate.longitude = longitude
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let image = aDecoder.decodeObject(forKey: "image") as! String
        let subtitle = aDecoder.decodeObject(forKey: "subtitle") as! String
        let price = aDecoder.decodeDouble(forKey: "price")
        let title = aDecoder.decodeObject(forKey: "image") as! String
        let latitude = aDecoder.decodeDouble(forKey: "latitude")
        let longitude = aDecoder.decodeDouble(forKey: "longitude")
        self.init(image: image, title: title, subtitle: subtitle, price: price, latitude: latitude, longitude: longitude)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(image, forKey: "image")
        aCoder.encode(subtitle, forKey: "subtitle")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(coordinate.latitude, forKey: "latitude")
        aCoder.encode(coordinate.longitude, forKey: "longitude")
    }
    
    
}
