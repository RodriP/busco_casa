//
//  LaunchViewController.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos on 7/19/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import UIKit
import Lottie
import SwiftKeychainWrapper

class LaunchViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var animationView: AnimationView!
    private var retrievedUser: String?
    private var savedUser : User? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrievedUser = KeychainWrapper.standard.string(forKey: AppConstants.UserConstants.userSaveData)
        
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
        welcomeLabel.textColor = .white
        if savedUser != nil {
            welcomeLabel.text = AppConstants.UserConstants.welcomeLoggedUser + "\(savedUser!.name)"
        } else{
            welcomeLabel.text = AppConstants.UserConstants.welcomeUser
        }
        playAnimation()
    }
    
    private func playAnimation(){
        let animation = Animation.named("homeAnimation")
        animationView.animation = animation
        animationView.layer.cornerRadius = self.animationView.frame.size.width / 2;
        animationView.backgroundColor = UIColor(red: 48, green: 120, blue: 168, alpha: 0)
        animationView.clipsToBounds = true
        animationView.play(fromProgress: 0, toProgress: 0.5, loopMode: .repeat(3)) { (success) in
            let storyboard : UIStoryboard
            if self.savedUser != nil {
                storyboard = UIStoryboard(name: "Main", bundle: nil)
                let userInitialViewController = storyboard.instantiateViewController(withIdentifier: "UserMenuTabViewController") as! UserMenuTabViewController
                userInitialViewController.user = self.savedUser
                TransitionHelper.setRootView(userInitialViewController)
            } else {
                storyboard = UIStoryboard(name: "login", bundle: nil)
                let loginInitialViewController = storyboard.instantiateViewController(withIdentifier: "loginNavigationController")
                TransitionHelper.setRootView(loginInitialViewController)
            }
        }
    }
    

}
