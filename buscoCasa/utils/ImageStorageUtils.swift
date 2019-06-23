//
//  ImageStorageUtils.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos on 6/23/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import Foundation
import UIKit

class ImageStorageUtils {
    
    static func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
}
