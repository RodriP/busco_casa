//
//  HouseModel.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos on 8/5/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import Foundation
struct HouseModel : Codable{
    let results : [Results]
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        results = try values.decode([Results].self, forKey: .results)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(results, forKey: .results)
    }
}
