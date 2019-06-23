//
//  LoginOptionViewController.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos on 5/21/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit
import FBSDKCoreKit

class LoginOptionViewController: UIViewController {

    @IBOutlet weak var accountBtn: UIButton!
    @IBOutlet weak var loginWithFacebook: UIImageView!
    var dict : [String: AnyObject] = [:]
    var user : User!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //creating button
        accountBtn.layer.cornerRadius = 5
        accountBtn.layer.borderWidth = 1
        accountBtn.layer.borderColor = UIColor.blue.cgColor
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        loginWithFacebook.isUserInteractionEnabled = true
        loginWithFacebook.addGestureRecognizer(singleTap)
    }
    
    @objc func tapDetected() {
        loginButtonClicked()
    }

    @IBAction func loginWithEmail(_ sender: Any) {
    }
    @IBAction func createNewAccount(_ sender: Any) {
    }
    
    
    @objc func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                let alert = UIAlertController(title: AppConstants.LoginConstants.loginErrorTitle, message:" $\(AppConstants.LoginConstants.loginErrorRetry) Details: $\(error.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: AppConstants.LoginConstants.loginRetry, style: UIAlertAction.Style.default, handler: { action in
                    self.loginButtonClicked()
                }))
                alert.addAction(UIAlertAction(title: AppConstants.cancelOption, style: UIAlertAction.Style.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            case .success( _, _, _):
                self.getFBUserData()
            case .cancelled:
                print("Login cancelled")
            }
        }
    }
    
    //function is fetching the user data
    func getFBUserData(){
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: AppConstants.LoginConstants.loginMe, parameters: [AppConstants.LoginConstants.loginFields: "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    guard let userName = self.dict["name"] as? String , let mail = self.dict["email"] as? String, let userphotoDictionary = self.dict["picture"] as? [String:NSDictionary], let photoData = userphotoDictionary["data"], let userUrlPhoto = photoData["url"] as? String else {
                        let alert = UIAlertController(title: AppConstants.LoginConstants.loginErrorTitle, message: (AppConstants.LoginConstants.loginErrorRetry), preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: AppConstants.LoginConstants.loginRetry, style: UIAlertAction.Style.default, handler: { action in
                            self.loginButtonClicked()
                        }))
                        alert.addAction(UIAlertAction(title: AppConstants.cancelOption, style: UIAlertAction.Style.cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    self.user = User(name: userName, mail: mail, password: "empty", photo: userUrlPhoto)
                    
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "UserMenuTabViewController") as! UserMenuTabViewController
                        controller.user = self.user
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            })
        }
    }

}
