//
//  EditUserViewController.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos on 6/23/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import UIKit

class EditUserViewController: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var updateBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateBtn.layer.cornerRadius = 5
        updateBtn.layer.borderWidth = 1
        updateBtn.layer.borderColor = UIColor.blue.cgColor
        updateBtn.titleEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
    }

}
