//
//  PictureViewController.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos on 5/21/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import UIKit

class PictureViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var hightConstraint: NSLayoutConstraint!
    var user : User!
    @IBOutlet weak var userImageView: UIImageView!
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        userImageView.isUserInteractionEnabled = true
        userImageView.addGestureRecognizer(singleTap)
    }
    
    @IBAction func skipAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        userImageView.contentMode = .scaleAspectFill
        userImageView.layer.cornerRadius = hightConstraint.constant/2
        userImageView.layer.borderWidth = 1
        userImageView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @objc func tapDetected() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: { () -> Void in
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.userImageView.image = image
                self.saveImage(image: image)

            }
        })
        self.user.photo = "image.png"
    }
    
    @IBAction func nextFlow(_ sender: Any) {
        guard ImageStorageUtils.getSavedImage(named: "image.png") != nil else {
            let alert = UIAlertController(title: "Choose a picture before continue", message: "You have to choose a profile picture", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    
    func saveImage(image: UIImage) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent("image.png")!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let userMenuController = segue.destination as? UserMenuTabViewController else{
            fatalError()
        }
        userMenuController.user = self.user
    }
    
}
