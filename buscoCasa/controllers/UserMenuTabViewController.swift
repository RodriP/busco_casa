//
//  UserMenuTabViewController.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos on 6/22/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import UIKit

class UserMenuTabViewController: UITabBarController {
    var user : User!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let navigationVC = viewControllers?.first as? UINavigationController else {
            return
        }
        
        guard let userAccountVC = navigationVC.viewControllers.first as? UserViewController else {
                return
        }
        
        userAccountVC.user = self.user

    }

}

