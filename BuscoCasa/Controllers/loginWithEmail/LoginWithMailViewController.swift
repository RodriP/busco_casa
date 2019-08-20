//
//  ViewController.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos on 5/20/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Lottie

class LoginWithMailViewController: UIViewController {
    @IBOutlet weak var houseImage: UIImageView!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var user : User!
    
    @IBOutlet weak var mailAnimationImage: AnimationView!
    @IBOutlet weak var loginbtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadButtonData()
   }

    @IBAction func userChange(_ sender: Any) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        playAnimation()
    }
    
    func playAnimation(){
        let animation = Animation.named("loginHome")
        mailAnimationImage.animation = animation
        mailAnimationImage.layer.cornerRadius = self.mailAnimationImage.frame.size.width / 2;
        mailAnimationImage.backgroundColor = UIColor(red: 48, green: 120, blue: 168, alpha: 0)
        mailAnimationImage.clipsToBounds = true
        mailAnimationImage.loopMode = .loop
        mailAnimationImage.play()
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
        
        var savedUser = GetLoggedUser.getLoggedUser()
        
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

