//
//  UserViewController.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos on 6/22/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Lottie

protocol ModalDelegate {
    func changeUser(user: User)
}

class UserViewController: UIViewController, ModalDelegate {
    
    @IBOutlet weak var portraitBtn: UIImageView!
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var portraitPicture: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet weak var hightConstraint: NSLayoutConstraint!
    @IBOutlet weak var editUserInfoBtn: UIButton!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    
    @IBOutlet weak var animationPic: AnimationView!
    
    var user : User!
    override func viewDidLoad() {
        super.viewDidLoad()
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        portraitBtn.addGestureRecognizer(singleTap)
        setButtonIcon()
    }
    @objc private func tapDetected(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            portraitBtn.tintColor = UIColor.white
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func playAnimation(){
        let animation = Animation.named("profile")
        animationPic.animation = animation
        animationPic.layer.cornerRadius = self.animationPic.frame.size.width / 2;
        animationPic.backgroundColor = UIColor(red: 48, green: 120, blue: 168, alpha: 0)
        animationPic.clipsToBounds = true
        animationPic.layer.borderWidth = 4
        animationPic.layer.borderColor = UIColor.white.cgColor
        animationPic.loopMode = .loop
        animationPic.play()
    }
    
    private func setupLoginState(){
        //TODO VER cambiar el root
        let storyboard = UIStoryboard(name: "login", bundle: nil)
        ImageStorageUtils.deleteDirectory(deleteName: AppConstants.UserConstants.userPortraitPicture + user.name)
        let loginNC = storyboard.instantiateViewController(withIdentifier: "loginNavigationController") as! UINavigationController
        self.present(loginNC, animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        portraitPicture.contentMode = UIView.ContentMode.scaleAspectFill
        
        userPicture.contentMode = .scaleAspectFill
        userPicture.layer.cornerRadius = hightConstraint.constant/2
        userPicture.layer.borderWidth = 4
        userPicture.layer.borderColor = UIColor.white.cgColor
        
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
        setUserData()
    }
    
    private func setUserData(){
        if user != nil {
            userName.text = user.name
            if(user.mail.isEmpty){
                userEmail.isHidden = true
            } else{
                userEmail.isHidden = false
                userEmail.text = user.mail
            }
            animationPic.isHidden = true
            if let portraitImage = ImageStorageUtils.getSavedImage(named: AppConstants.UserConstants.userPortraitPicture + user.name){
                portraitPicture.image = portraitImage
            }
            if let image = ImageStorageUtils.getSavedImage(named: AppConstants.UserConstants.userImageNameToSave + user.name) {
                // From new registration flow
                userPicture.isHidden = false
                userPicture.image = image
            } else {
                if(user.photo.elementsEqual("")){
                    //User not selected a profile photo, use custome one
                    userPicture.isHidden = true
                    animationPic.isHidden = false
                    playAnimation()
                } else{
                    // From FB login
                    userPicture.isHidden = false
                    userPicture.downloaded(from: user.photo, user: user, userImage: userPicture, picImage: animationPic)
                }
            }
        } else{
            fatalError("Not user found")
        }
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
    func downloaded(from url: URL, user: User,userImage: UIImageView, picImage: AnimationView, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix(AppConstants.UserConstants.userImage),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { userImage.isHidden = true
                    picImage.isHidden = false
                    return}
            DispatchQueue.main.async() {
                self.image = image
                ImageStorageUtils.saveImage(image: image, nameToSave: AppConstants.UserConstants.userImageNameToSave + user.name)
            }
            }.resume()
    }
    
    func downloaded(from link: String, user: User, userImage: UIImageView, picImage : AnimationView, contentMode mode: UIView.ContentMode = .scaleAspectFill) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, user: user, userImage: userImage, picImage: picImage)
    }
    
}

extension UserViewController: UINavigationControllerDelegate{
    //nothing here, only for delegate
}

extension UserViewController: UIImagePickerControllerDelegate{
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: { () -> Void in
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.portraitPicture.image = image
                ImageStorageUtils.saveImage(image: image, nameToSave: AppConstants.UserConstants.userPortraitPicture + self.user.name)
            }
        })
        self.user.profilePic = AppConstants.UserConstants.userPortraitPicture
    }
}
