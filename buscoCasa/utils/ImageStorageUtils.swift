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
    
    static func saveImage(image: UIImage) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent(AppConstants.UserConstants.userImageNameToSave)!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}
