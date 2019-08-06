//
//  Results.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos on 8/5/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import Foundation
struct Results: Codable{
    let id : String
    let title : String
    let subtitle : String
    let price : Double
    let thumbnail : String
    let sellerContact : SellerContact
    let location : HouseLocation
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case subtitle
        case price
        case thumbnail
        case sellerContact = "seller_contact"
        case location
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        subtitle = try values.decode(String.self, forKey: .subtitle)
        price = try values.decode(Double.self, forKey: .price)
        thumbnail = try values.decode(String.self, forKey: .thumbnail)
        sellerContact = try values.decode(SellerContact.self, forKey: .sellerContact)
        location = try values.decode(HouseLocation.self, forKey: .location)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(subtitle, forKey: .subtitle)
        try container.encode(price, forKey: .price)
        try container.encode(thumbnail, forKey: .thumbnail)
        try container.encode(sellerContact, forKey: .sellerContact)
        try container.encode(location, forKey: .location)
    }
}
