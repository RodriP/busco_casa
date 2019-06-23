//
//  MailRegistrationViewController.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos on 6/22/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import UIKit

class MailRegistrationViewController: UIViewController {

    var user : User!
 
    @IBOutlet weak var mailUserText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func skipAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let mail = mailUserText.text, !mail.isEmpty else{
            let actions = [UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)]
            self.present(AlertDialogUtils.getAlertDialog(title: AppConstants.UserConstants.userEmailErrorTitle, message: AppConstants.UserConstants.userEmailErrorMsg, action: actions), animated: true, completion: nil)
            return
        }
        guard let passwordController = segue.destination as? PasswordRegistrationViewController else{
            fatalError()
        }
        user.mail = mail
        passwordController.user = self.user
    }

}
