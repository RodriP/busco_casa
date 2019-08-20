//
//  TransitionHelper.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos Costa on 8/17/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import Foundation
import UIKit

struct TransitionHelper {
    public static func setRootView(_ viewController: UIViewController,
                     options: UIView.AnimationOptions = .transitionCrossDissolve,
                     animated: Bool = true,
                     duration: TimeInterval = 0.5,
                     completion: (() -> Void)? = nil) {
        guard animated else {
            UIApplication.shared.keyWindow!.rootViewController = viewController
            return
        }
        UIView.transition(with: UIApplication.shared.keyWindow!, duration: duration, options: options, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            UIApplication.shared.keyWindow!.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        }) { _ in
            completion?()
        }
    }
}
