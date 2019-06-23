//
//  UserViewController.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos on 6/22/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet weak var hightConstraint: NSLayoutConstraint!
    @IBOutlet weak var editUserInfoBtn: UIButton!
    @IBOutlet weak var userEmail: UILabel!
    var user : User!
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.text = user.name
        userEmail.text = user.mail
        userPicture.downloaded(from: user.photo)
        userPicture.contentMode = .scaleAspectFill
        setButtonIcon()
        self.navigationItem.setHidesBackButton(true, animated:true);
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        userPicture.layer.cornerRadius = hightConstraint.constant/2
        userPicture.layer.borderWidth = 1
        userPicture.layer.borderColor = UIColor.lightGray.cgColor
    }
    @IBAction func editUserInfo(_ sender: Any) {
    }
    
    private func setButtonIcon(){
        let icon = UIImage(named: "ball_point_pen")!
        
        editUserInfoBtn.setImage(icon, for: .normal)
        editUserInfoBtn.imageView?.contentMode = .scaleAspectFit
        editUserInfoBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
    }
    @IBAction func logout(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginOptionViewController") as! LoginOptionViewController
        present(vc, animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
}



extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix(AppConstants.UserConstants.userImage),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
