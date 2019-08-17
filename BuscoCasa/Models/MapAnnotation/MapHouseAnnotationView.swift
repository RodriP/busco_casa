//
//  MapHouseAnnotationView.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos Costa on 8/13/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import Foundation
import MapKit
import SwiftKeychainWrapper

class MapHouseAnnotationView : MKAnnotationView{
    private let viewFrame = CGRect(x: 0, y: 0, width: 60, height: 60)
    private var user : User?
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
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
        self.frame = viewFrame
        canShowCallout = true
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        if let annotation = annotation as? MapHouseAnnotation {
                let bookmarksBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                bookmarksBtn.setImage(UIImage(named: "favoriteoff"), for: .highlighted)
                bookmarksBtn.setImage(UIImage(named: "favoriteoff"), for: .normal)
                bookmarksBtn.setImage(UIImage(named: "favoriteon"), for: .selected)
                rightCalloutAccessoryView = bookmarksBtn
                imageView.layer.cornerRadius = imageView.layer.frame.size.width / 2
                imageView.layer.masksToBounds = true
                imageView.layer.borderWidth = 1
                imageView.layer.borderColor = UIColor.black.cgColor
                self.downloadImage(from: URL(string: annotation.image)!, imageView: imageView)
        } else {
            var pin = ImageStorageUtils.getSavedImage(named: AppConstants.UserConstants.userImageNameToSave + user!.name)
            if(pin == nil){
                pin = UIImage(named: "loginuser")
            }
            imageView.image = pin;
            imageView.layer.cornerRadius = imageView.layer.frame.size.width / 2
            imageView.layer.masksToBounds = true
        }
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func select() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6, options: .curveEaseIn, animations: {
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: nil)
    }
    
    func deselect() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6, options: .curveEaseIn, animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
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
