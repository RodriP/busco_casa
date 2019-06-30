//
//  UserViewController.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos on 6/22/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import UIKit

protocol ModalDelegate {
    func changeUser(user: User)
}

class UserViewController: UIViewController, ModalDelegate {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet weak var hightConstraint: NSLayoutConstraint!
    @IBOutlet weak var editUserInfoBtn: UIButton!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    var user : User!
    override func viewDidLoad() {
        super.viewDidLoad()
        userPicture.contentMode = .scaleAspectFill
        registerForNotifications()
        if user != nil {
            setButtonIcon()
        } else {
            setupLoginState()
            return
        }
    }
    
    private func setupLoginState(){
        let storyboard = UIStoryboard(name: "login", bundle: nil)
        let loginNC = storyboard.instantiateViewController(withIdentifier: "loginNavigationController") as! UINavigationController
        self.present(loginNC, animated: true, completion: nil)
    }
    
    private func registerForNotifications() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(currentUser),
                                               name: AppConstants.UserConstants.userValue,
                                               object: nil)
        
    }
    
    @objc private func currentUser(notification: NSNotification) {
        if let user = notification.userInfo?[AppConstants.UserConstants.userObject] as? User {
            self.user = user
            setButtonIcon()
            setUserData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUserData()
    }
    
    private func setUserData(){
        if user != nil {
            userName.text = user.name
            userEmail.text = user.mail
            if let image = ImageStorageUtils.getSavedImage(named: AppConstants.UserConstants.userImageNameToSave) {
                // From new registration flow
                userPicture.image = image
            } else {
                // From FB login
                userPicture.downloaded(from: user.photo)
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        userPicture.layer.cornerRadius = hightConstraint.constant/2
        userPicture.layer.borderWidth = 1
        userPicture.layer.borderColor = UIColor.lightGray.cgColor
    }

    func changeUser(user: User) {
        self.user = user
    }
    
    private func setButtonIcon(){
        let icon = UIImage(named: "ball_point_pen")!
        
        logoutBtn.layer.cornerRadius = 5
        logoutBtn.layer.borderWidth = 1
        logoutBtn.layer.borderColor = UIColor.blue.cgColor
        logoutBtn.titleEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
        
        editUserInfoBtn.layer.cornerRadius = 5
        editUserInfoBtn.layer.borderWidth = 1
        editUserInfoBtn.layer.borderColor = UIColor.blue.cgColor
        editUserInfoBtn.setImage(icon, for: .normal)
        editUserInfoBtn.imageView?.contentMode = .scaleAspectFit
        editUserInfoBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: -20, bottom: 5, right: 5)
    }
    
    @IBAction func logout(_ sender: Any) {
        ImageStorageUtils.deleteDirectory()
        self.user = nil
        setupLoginState()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let editController = segue.destination as? EditUserViewController else{
            fatalError()
        }
        editController.delegate = self
        editController.user = self.user
    }
}



extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix(AppConstants.UserConstants.userImage),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
                ImageStorageUtils.saveImage(image: image)
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFill) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
    
}
