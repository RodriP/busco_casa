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

    @IBOutlet weak var bookmarksTable: UITableView!
    
    @IBOutlet weak var emptyBookmarksView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Bookmarks"
        bookmarksTable.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        playAnimation()
    }
    
    private func playAnimation(){
        let animation = Animation.named("bookmarksPlaceholder")
        emptyBookmarksView.animation = animation
        emptyBookmarksView.clipsToBounds = true
        emptyBookmarksView.loopMode = .loop
        emptyBookmarksView.play()
    }

}
