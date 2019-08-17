//
//  BookmarksViewController.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos Costa on 8/14/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import UIKit
import Lottie

class BookmarksViewController: UIViewController {

    @IBOutlet weak var emptyBookmarksLbl: UILabel!
    @IBOutlet weak var bookmarksTable: UITableView!
    
    @IBOutlet weak var emptyBookmarksView: AnimationView!
    
    var bookmarks : [MapHouseAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Bookmarks"
        
        let userDefaults = UserDefaults.standard

        let decoded  = userDefaults.data(forKey: AppConstants.UserConstants.userSaveBookmarks)
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
