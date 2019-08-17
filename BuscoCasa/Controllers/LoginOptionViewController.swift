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
import SwiftKeychainWrapper
import Lottie

class LoginOptionViewController: UIViewController {

    @IBOutlet weak var loginImageAnimation: AnimationView!
    @IBOutlet weak var accountBtn: UIButton!
    @IBOutlet weak var loginWithFacebook: UIImageView!
    var fbDictionaryDataResult : [String: AnyObject] = [:]
    var user : User!

    @IBOutlet weak var loginWithEmailBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareButtons()
        registerForNotifications()
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        loginWithFacebook.isUserInteractionEnabled = true
        loginWithFacebook.addGestureRecognizer(singleTap)
    }
    override func viewWillAppear(_ animated: Bool) {
        playAnimation()
    }
    
    private func playAnimation(){
        let animation = Animation.named("loginHome")
        loginImageAnimation.animation = animation
        loginImageAnimation.layer.cornerRadius = self.loginImageAnimation.frame.size.width / 2;
        loginImageAnimation.clipsToBounds = true
        loginImageAnimation.loopMode = .loop
        loginImageAnimation.play()
    }
    
    private func registerForNotifications() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(currentUser),
                                               name: AppConstants.UserConstants.userValue,
                                               object: nil)
        
    }
    
    @objc private func currentUser() {
        dismiss(animated: true, completion: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "UserMenuTabViewController") as! UserMenuTabViewController
        mainVC.user = self.user
        self.present(mainVC, animated: true, completion: nil)
    }
    
    private func prepareButtons(){
        loginWithEmailBtn.layer.cornerRadius = 5
        loginWithEmailBtn.layer.borderWidth = 1
        loginWithEmailBtn.layer.borderColor = UIColor.blue.cgColor
        loginWithEmailBtn.titleEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
        
        accountBtn.layer.cornerRadius = 5
        accountBtn.layer.borderWidth = 1
        accountBtn.layer.borderColor = UIColor.blue.cgColor
        accountBtn.titleEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
    }
    
    @objc func tapDetected() {
        loginButtonClicked()
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
                print("Login cancelled, nothing here")
            }
        }
    }
    
    //function is fetching the user data
    func getFBUserData(){
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: AppConstants.LoginConstants.loginMe, parameters: [AppConstants.LoginConstants.loginFields: "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.fbDictionaryDataResult = result as! [String : AnyObject]
                    guard let userName = self.fbDictionaryDataResult["name"] as? String , let userphotoDictionary = self.fbDictionaryDataResult["picture"] as? [String:NSDictionary], let photoData = userphotoDictionary["data"], let userUrlPhoto = photoData["url"] as? String else {
                        let alert = UIAlertController(title: AppConstants.LoginConstants.loginErrorTitle, message: (AppConstants.LoginConstants.loginErrorRetry), preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: AppConstants.LoginConstants.loginRetry, style: UIAlertAction.Style.default, handler: { action in
                            self.loginButtonClicked()
                        }))
                        alert.addAction(UIAlertAction(title: AppConstants.cancelOption, style: UIAlertAction.Style.cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    let mail = self.fbDictionaryDataResult["email"] as? String
                    ImageStorageUtils.deleteDirectory(deleteName: userName)
                    self.user = User(name: userName, mail: mail ?? "", password: "empty", photo: userUrlPhoto, profilePic: "")
                    
                    NotificationCenter.default.post(name: AppConstants.UserConstants.userValue , object: nil, userInfo: nil)
                    
                    //Save user
                    let jsonData = try! JSONEncoder().encode(self.user)
                    let userJsonString = String(data: jsonData, encoding: .utf8)!
                    KeychainWrapper.standard.set(userJsonString, forKey: AppConstants.UserConstants.userSaveData)
                    
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
    }

}