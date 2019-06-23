//
//  UserNameRegistrationViewController.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos on 5/21/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import UIKit

class UserNameRegistrationViewController: UIViewController {
    var user: User!
    @IBOutlet weak var userNameTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func skipBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let userName = userNameTxt.text, !userName.isEmpty else{
            let actions = [UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)]
            self.present(AlertDialogUtils.getAlertDialog(title: AppConstants.UserConstants.userNameEmptyTitle, message: AppConstants.UserConstants.userNameEmptyMsg, action: actions), animated: true, completion: nil)
            return
        }
        guard let emailController = segue.destination as? MailRegistrationViewController else{
            fatalError()
        }
        user = User(name: userName, mail: AppConstants.UserConstants.userEmptyValue, password: AppConstants.UserConstants.userEmptyValue, photo: AppConstants.UserConstants.userEmptyValue)
        emailController.user = self.user
    }
    
}
