//
//  BookmarksViewController.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos Costa on 8/14/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import UIKit
import Lottie
import SwiftKeychainWrapper

class BookmarksViewController: UIViewController {

    @IBOutlet weak var emptyBookmarksLbl: UILabel!
    @IBOutlet weak var bookmarksTable: UITableView!
    
    @IBOutlet weak var emptyBookmarksView: AnimationView!
    
    private var user : User!
    
    var bookmarks : [MapHouseAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Bookmarks"
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if(!bookmarks.isEmpty){
            bookmarksTable.isHidden = false
            emptyBookmarksLbl.isHidden = true
        } else{
            playAnimation()
            bookmarksTable.isHidden = true
            emptyBookmarksLbl.isHidden = false
        }
    }
    
    private func playAnimation(){
        let animation = Animation.named("bookmarksPlaceholder")
        emptyBookmarksView.animation = animation
        emptyBookmarksView.clipsToBounds = true
        emptyBookmarksView.loopMode = .loop
        emptyBookmarksView.play()
    }

}
