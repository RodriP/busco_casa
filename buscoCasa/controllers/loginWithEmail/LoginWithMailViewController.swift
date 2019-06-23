//
//  ViewController.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos on 5/20/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import UIKit

class LoginWithMailViewController: UIViewController {
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var user : User!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func userChange(_ sender: Any) {
    }
    @IBAction func passwordChange(_ sender: Any) {
    }
    
    @IBAction func loginButtonClick(_ sender: Any) {
        guard let user = validatUser() else {
            return
        }
        self.user = user
    }
    
    private func validatUser() -> User? {
        guard let userName = userTextField.text,
            let password = passwordTextField.text, !userName.isEmpty && !password.isEmpty else{
            let alert = UIAlertController(title: "Empty user or password", message: "Check your data", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
                return nil
        }
        let user = User(name: userName,mail:"batman@gmail.com", password:password, photo: "https://www.missingnumber.com.mx/wp-content/uploads/2016/04/Batman-SquareEnix-PlayArtsKai.jpg")
        return user
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! UserMenuTabViewController
        vc.user = self.user
    }
    
}

