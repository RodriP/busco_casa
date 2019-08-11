//
//  HouseLocation.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos on 8/5/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import Foundation
struct HouseLocation: Codable {
    var latitude : Double?
    var longitude : Double?
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
    
    init(from decoder: Decoder) {

        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            latitude = try values.decode(Double.self, forKey: .latitude)
            longitude = try values.decode(Double.self, forKey: .longitude)
        } catch {
            latitude = 0
            longitude = 0
        }

    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
}
