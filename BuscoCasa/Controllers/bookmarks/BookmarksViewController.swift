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
    private let titles = ["🏡 Apartamentos"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Bookmarks"
        
        self.user = GetLoggedUser.getLoggedUser()

        bookmarksTable.dataSource = self
        bookmarksTable.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        let decoded  = userDefaults.data(forKey: AppConstants.UserConstants.userSaveBookmarks + user.name)
        if(decoded != nil){
            bookmarks = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! [MapHouseAnnotation]
        }
        
        if(!bookmarks.isEmpty){
            bookmarksTable.isHidden = false
            emptyBookmarksView.isHidden = true
            emptyBookmarksLbl.isHidden = true
            bookmarksTable.reloadData()
        } else{
            emptyScreen()
        }
    }
    
    private func emptyScreen(){
        emptyBookmarksView.isHidden = false
        playAnimation()
        bookmarksTable.isHidden = true
        emptyBookmarksLbl.isHidden = false
    }
    
    private func playAnimation(){
        let animation = Animation.named("bookmarksPlaceholder")
        emptyBookmarksView.animation = animation
        emptyBookmarksView.clipsToBounds = true
        emptyBookmarksView.loopMode = .loop
        emptyBookmarksView.play()
    }

}

class HeadlineCell : UITableViewCell{
    
    @IBOutlet weak var cellImage: UIImageView!
    
    @IBOutlet weak var cellLabel: UILabel!
}

extension  BookmarksViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HeadlineCell
        
        let task = bookmarks[indexPath.row]
        
        cell.cellLabel.text = task.title
        downloadImage(from: URL(string: task.image)!, imageView: cell.cellImage!)
        
        return cell
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard bookmarks.count > 0 else {
            return nil
        }
        
        return titles[0]
    }
}

extension BookmarksViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            bookmarks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .middle)
            let userDefaults = UserDefaults.standard
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: bookmarks)
            userDefaults.set(encodedData, forKey: AppConstants.UserConstants.userSaveBookmarks + user.name)
            userDefaults.synchronize()
            if(bookmarks.isEmpty){
                emptyScreen()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section > 0
    }
    
}
