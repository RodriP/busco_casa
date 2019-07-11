//
//  ViewController.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos on 5/20/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class LoginWithMailViewController: UIViewController {
    @IBOutlet weak var houseImage: UIImageView!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var user : User!
    
    @IBOutlet weak var loginbtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadButtonData()
   }

    @IBAction func userChange(_ sender: Any) {
    }
    @IBAction func skipAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func passwordChange(_ sender: Any) {
    }
    
    private func loadButtonData (){
        loginbtn.layer.cornerRadius = 5
        loginbtn.layer.borderWidth = 1
        loginbtn.layer.borderColor = UIColor.white.cgColor
        loginbtn.titleEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
    }
    @IBAction func loginButtonClick(_ sender: Any) {
        let retrievedUser: String? = KeychainWrapper.standard.string(forKey: AppConstants.UserConstants.userSaveData)
        var savedUser : User? = nil
        if retrievedUser != nil {
            if let jsonData = retrievedUser!.data(using: .utf8)
            {
                let decoder = JSONDecoder()
                
                do {
                    savedUser = try decoder.decode(User.self, from: jsonData)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }

        
        guard let userName = userTextField.text,
            let password = passwordTextField.text, !userName.isEmpty && !password.isEmpty else{
                let actions = [UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)]
                self.present(AlertDialogUtils.getAlertDialog(title: AppConstants.UserConstants.userEmptyErrorTitle, message: AppConstants.UserConstants.userEmptyErrorMsg, action: actions), animated: true, completion: nil)
                return
        }
        guard savedUser != nil && savedUser!.name.elementsEqual(userName) && savedUser!.password.elementsEqual(password) else{
                let actions = [UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)]
                self.present(AlertDialogUtils.getAlertDialog(title: AppConstants.UserConstants.userValidationError, message: AppConstants.UserConstants.userValidationErrorMsg, action: actions), animated: true, completion: nil)
                return
        }
        NotificationCenter.default.post(name: AppConstants.UserConstants.userValue , object: nil, userInfo: nil)
        
        self.navigationController?.popViewController(animated: true)
    }
    
}

