//
//  PictureViewController.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos on 5/21/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class PictureViewController: UIViewController {
    @IBOutlet weak var hightConstraint: NSLayoutConstraint!
    var user : User!
    @IBOutlet weak var userImageView: UIImageView!
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        userImageView.isUserInteractionEnabled = true
        userImageView.addGestureRecognizer(singleTap)
    }
    
    @IBAction func skipAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        userImageView.contentMode = .scaleAspectFill
        userImageView.layer.cornerRadius = hightConstraint.constant/2
        userImageView.layer.borderWidth = 1
        userImageView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @objc func tapDetected() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: { () -> Void in
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.userImageView.image = image
                ImageStorageUtils.saveImage(image: image)

            }
        })
        self.user.photo = AppConstants.UserConstants.userImageNameToSave
    }
    
    @IBAction func nextFlow(_ sender: Any) {
        guard ImageStorageUtils.getSavedImage(named: AppConstants.UserConstants.userImageNameToSave) != nil else {
            let actions = [UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)]
            self.present(AlertDialogUtils.getAlertDialog(title: AppConstants.UserConstants.userChoosePictureError, message: AppConstants.UserConstants.userChoosePicMsg, action: actions), animated: true, completion: nil)
            return
        }
        NotificationCenter.default.post(name: AppConstants.UserConstants.userValue , object: nil, userInfo: nil)
        
        //Save user
        let jsonData = try! JSONEncoder().encode(user)
        let userJsonString = String(data: jsonData, encoding: .utf8)!
        KeychainWrapper.standard.set(userJsonString, forKey: AppConstants.UserConstants.userSaveData)
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension PictureViewController: UINavigationControllerDelegate {
    //Nothing here, only for delegate
    
}

extension PictureViewController: UIImagePickerControllerDelegate {
    //Nothing here, only for delegate
}
