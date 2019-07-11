//
//  EditUserViewController.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos on 6/23/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import UIKit

class EditUserViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var updateBtn: UIButton!
    var delegate: ModalDelegate?
    var user : User!
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareButtons()
        userImage.isUserInteractionEnabled = true
       let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        userImage.addGestureRecognizer(singleTap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    private func prepareButtons(){
        updateBtn.layer.cornerRadius = 5
        updateBtn.layer.borderWidth = 1
        updateBtn.layer.borderColor = UIColor.white.cgColor
        updateBtn.titleEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
        
        userImage.contentMode = .scaleAspectFill
        userImage.layer.cornerRadius = heightConstraint.constant/2
        userImage.layer.borderWidth = 1
        userImage.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func loadData(){
        emailTxt.text = user.mail
        userNameTxt.text = user.name
        passwordTxt.text = user.password
        passwordTxt.isSecureTextEntry = true
        userImage.image = ImageStorageUtils.getSavedImage(named: AppConstants.UserConstants.userImageNameToSave)
    }
    
    @IBAction func uploadAction(_ sender: Any) {
        let actions = [UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)]
    
        guard let name = userNameTxt.text, !name.isEmpty else {
            
            self.present(AlertDialogUtils.getAlertDialog(title: AppConstants.UserConstants.userNameEmptyMsg,message:AppConstants.UserConstants.userNameEmptyMsg, action: actions), animated: true, completion: nil)
            return
        }
        user.name = name
        guard let email = emailTxt.text, !email.isEmpty else {
            self.present(AlertDialogUtils.getAlertDialog(title: AppConstants.UserConstants.userEmailErrorTitle,message:AppConstants.UserConstants.userEmailErrorMsg, action: actions), animated: true, completion: nil)
                return
        }
        user.mail = email
        guard let password = passwordTxt.text, !password.isEmpty else {
            self.present(AlertDialogUtils.getAlertDialog(title: AppConstants.UserConstants.userEmptyPassword,message:AppConstants.UserConstants.userEmptyPassMsg, action: actions), animated: true, completion: nil)
            return
        }
        user.password = password
        ImageStorageUtils.saveImage(image: userImage.image!)
        delegate?.changeUser(user: user)
        dismiss(animated: true, completion: nil)
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
                self.userImage.image = image
            }
        })
        self.user.photo = AppConstants.UserConstants.userImageNameToSave
    }

    @IBAction func cancelButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension EditUserViewController: UINavigationControllerDelegate{
 //nothing here, only for delegate
}

extension EditUserViewController: UIImagePickerControllerDelegate{
 //nothing here, only for delegate
}

