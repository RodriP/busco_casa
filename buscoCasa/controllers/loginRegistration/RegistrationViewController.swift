//
//  RegistrationViewController.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos on 7/20/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import UIKit
import Lottie
import SwiftKeychainWrapper

class RegistrationViewController: UIViewController {

    @IBOutlet weak var userImage: AnimationView!
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    var imagePicker = UIImagePickerController()
    private var user : User!
    
    @IBOutlet weak var imageToSave: UIImageView!
    @IBOutlet weak var emailTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        playAnimation()
    }
    
    private func playAnimation(){
        let animation = Animation.named("choosePicture")
        userImage.animation = animation
        userImage.loopMode = .loop
        userImage.play()
    }
    
    private func prepareButtons(){
        createBtn.layer.cornerRadius = 5
        createBtn.layer.borderWidth = 1
        createBtn.layer.borderColor = UIColor.white.cgColor
        createBtn.titleEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
        
        userImage.contentMode = .scaleAspectFill
        userImage.layer.cornerRadius = self.userImage.frame.size.width / 2;
        userImage.backgroundColor = UIColor(red: 48, green: 120, blue: 168, alpha: 0)
        userImage.clipsToBounds = true
        
        userImage.isUserInteractionEnabled = true
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        userImage.addGestureRecognizer(singleTap)
        
        let singleAnimatedTap = UITapGestureRecognizer(target: self, action: #selector(animatedTap))
        imageToSave.isHidden = true
        imageToSave.isUserInteractionEnabled = true
        imageToSave.addGestureRecognizer(singleAnimatedTap)

        
        imageToSave.contentMode = .scaleAspectFill
        imageToSave.layer.cornerRadius = self.userImage.frame.size.width / 2;
    }
    
    @IBAction func uploadAction(_ sender: Any) {
        let actions = [UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)]
        
        guard let name = userNameTxt.text, !name.isEmpty else {
            
            self.present(AlertDialogUtils.getAlertDialog(title: AppConstants.UserConstants.userNameEmptyMsg,message:AppConstants.UserConstants.userNameEmptyMsg, action: actions), animated: true, completion: nil)
            return
        }
        guard let email = emailTxt.text, !email.isEmpty else {
            self.present(AlertDialogUtils.getAlertDialog(title: AppConstants.UserConstants.userEmailErrorTitle,message:AppConstants.UserConstants.userEmailErrorMsg, action: actions), animated: true, completion: nil)
            return
        }
        guard let password = passwordTxt.text, !password.isEmpty else {
            self.present(AlertDialogUtils.getAlertDialog(title: AppConstants.UserConstants.userEmptyPassword,message:AppConstants.UserConstants.userEmptyPassMsg, action: actions), animated: true, completion: nil)
            return
        }
        
        if(imageToSave.image == nil ){
            user = User(name: name, mail: email, password: password, photo: "", profilePic: "")
        } else {
           user = User(name: name, mail: email, password: password, photo: AppConstants.UserConstants.userImageNameToSave + name, profilePic: "")
            ImageStorageUtils.saveImage(image: imageToSave.image!, nameToSave: AppConstants.UserConstants.userImageNameToSave + user.name)
        }
        //Save user
        let jsonData = try! JSONEncoder().encode(user)
        let userJsonString = String(data: jsonData, encoding: .utf8)!
        KeychainWrapper.standard.set(userJsonString, forKey: AppConstants.UserConstants.userSaveData)
        NotificationCenter.default.post(name: AppConstants.UserConstants.userValue , object: nil, userInfo: nil)
        
        self.navigationController?.popViewController(animated: true)
    }

    
    @objc func tapDetected() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    @objc func animatedTap(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

extension RegistrationViewController : UINavigationControllerDelegate {
    //Nothing here, only for delegte
}

extension RegistrationViewController : UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: { () -> Void in
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.imageToSave.image = image
                self.imageToSave.isHidden = false
            }
        })
        userImage.isHidden = true
    }
    
}
