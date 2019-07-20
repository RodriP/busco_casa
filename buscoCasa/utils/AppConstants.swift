//
//  Constants.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos on 6/22/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import Foundation
struct AppConstants{
    static let positiveResponse : String = "Ok"
    static let cancelOption : String = "Cancel"
    
    struct LoginConstants {
        static let loginMe : String = "me"
        static let loginFields : String = "fields"
        static let loginErrorTitle : String = "Error Login"
        static let loginErrorRetry : String = "Login Failed, try again"
        static let loginRetry : String = "Retry"
    }
    
    struct UserConstants{
        static let userValue = NSNotification.Name("user")
        static let welcomeUser = "Bienvenid@ a BuscoCasa!"
        static let welcomeLoggedUser = "Bienvenid@ de nuevo "
        static let userObject = "user"
        static let userImage = "image"
        static let userSaveData = "userData"
        static let userValidationErrorMsg = "Wrong user name or password"
        static let userValidationError = "Login Error"
        static let userEmptyErrorTitle = "Empty user or password"
        static let userEmptyErrorMsg = "Check your data"
        static let userEmptyPassword = "Empty password"
        static let userEmptyPassMsg = "User password can't be empty"
        static let userChoosePictureError = "Choose a picture before continue"
        static let userChoosePicMsg = "You have to choose a profile picture"
        static let userImageNameToSave = "image.png"
        static let userEmailErrorTitle = "Empty user mail"
        static let userEmailErrorMsg = "User mail can't be empty"
        static let userNameEmptyTitle = "Empty user name"
        static let userNameEmptyMsg = "User Name can't be empty"
        static let userEmptyValue = ""
    }
    
    struct MapConstants{
        static let MapTitle = "Map"
        static let AskLocationTitle = "Set Location Services"
        static let AskLocationMsg = "We need to access to location services for this application"
        static let AskLocationConfigAction = "Ir a Configuración"
        static let AskLocationCancelAction = "Cancel"
    }
}
