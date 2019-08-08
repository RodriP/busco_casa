//
//  SellerContact.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos on 8/5/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import Foundation
struct SellerContact: Codable {
    let phone : String
    let email : String
    
    enum CodingKeys: String, CodingKey {
        case phone
        case email
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        phone = try values.decode(String.self, forKey: .phone)
        email = try values.decode(String.self, forKey: .email)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(phone, forKey: .phone)
        try container.encode(email, forKey: .email)
    }
}
