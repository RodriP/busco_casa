//
//  AlertDialogUtils.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos on 6/23/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import Foundation
import UIKit

class AlertDialogUtils{
    
    static func getAlertDialog(title customTitle: String, message customMessage: String, action actions: [UIAlertAction]) -> UIAlertController{
         let alertDialog = UIAlertController(title: customTitle, message: customMessage, preferredStyle: UIAlertController.Style.alert)
        for action in actions {
            alertDialog.addAction(action)
        }
        return alertDialog
    }
}
