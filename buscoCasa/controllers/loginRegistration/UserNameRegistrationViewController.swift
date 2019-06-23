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
            let alert = UIAlertController(title: "Empty user name", message: "User Name can't be empty", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        guard let emailController = segue.destination as? MailRegistrationViewController else{
            fatalError()
        }
        user = User(name: userName, mail: "", password: "", photo: "")
        emailController.user = self.user
    }
    
}
