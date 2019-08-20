//
//  GetLoggedUser.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos Costa on 8/20/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

struct GetLoggedUser{
    
   static func getLoggedUser() -> User? {
        let retrievedUser: String? = KeychainWrapper.standard.string(forKey: AppConstants.UserConstants.userSaveData)
        if retrievedUser != nil {
            if let jsonData = retrievedUser!.data(using: .utf8)
            {
                let decoder = JSONDecoder()
                
                do {
                    return try decoder.decode(User.self, from: jsonData)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        return nil
    }
}
