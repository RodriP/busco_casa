//
//  PasswordRegistrationViewController.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos on 5/21/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import UIKit

class PasswordRegistrationViewController: UIViewController {
    var user : User!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.isSecureTextEntry = true

       
    }
    
    @IBAction func skipPassword(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let password = passwordField.text, !password.isEmpty else{
            let actions = [UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)]
            self.present(AlertDialogUtils.getAlertDialog(title: AppConstants.UserConstants.userEmptyPassword, message: AppConstants.UserConstants.userEmptyPassMsg, action: actions), animated: true, completion: nil)
            return
        }
        
        guard let pictureController = segue.destination as? PictureViewController else{
            fatalError()
        }
        user.password = password
        pictureController.user = self.user
        
    }
    
}
