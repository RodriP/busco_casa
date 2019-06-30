//
//  ViewController.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos on 5/20/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import UIKit

class LoginWithMailViewController: UIViewController {
    @IBOutlet weak var houseImage: UIImageView!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var user : User!
    
    @IBOutlet weak var loginbtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginbtn.layer.cornerRadius = 5
        loginbtn.layer.borderWidth = 1
        loginbtn.layer.borderColor = UIColor.white.cgColor
        loginbtn.titleEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)    }

    @IBAction func userChange(_ sender: Any) {
    }
    @IBAction func skipAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func passwordChange(_ sender: Any) {
    }
    
    @IBAction func loginButtonClick(_ sender: Any) {
        guard let userName = userTextField.text,
            let password = passwordTextField.text, !userName.isEmpty && !password.isEmpty else{
                let actions = [UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)]
                self.present(AlertDialogUtils.getAlertDialog(title: AppConstants.UserConstants.userEmptyErrorTitle, message: AppConstants.UserConstants.userEmptyErrorMsg, action: actions), animated: true, completion: nil)
                return
        }
        // Fake user until we have Local Storage to save user info and checks
        let user = User(name: userName,mail:"batman@gmail.com", password:password, photo: "https://www.missingnumber.com.mx/wp-content/uploads/2016/04/Batman-SquareEnix-PlayArtsKai.jpg")
        let userDataDict:[String: User] = [AppConstants.UserConstants.userObject: user]
        
        NotificationCenter.default.post(name: AppConstants.UserConstants.userValue , object: nil, userInfo: userDataDict)
        
        dismiss(animated: true, completion: nil)
        self.parent?.dismiss(animated: true, completion: nil)
    }
    
}

