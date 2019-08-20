//
//  AnimationUtils.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos Costa on 8/20/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import Foundation
import Lottie

struct AnimationUtils {
    static func playAnimation(animateImage: AnimationView, animation: String){
        animateImage.isHidden = false
        let animation = Animation.named(animation)
        animateImage.animation = animation
        animateImage.layer.cornerRadius = animateImage.frame.size.width / 2;
        animateImage.clipsToBounds = true
        animateImage.loopMode = .loop
        animateImage.play()
    }
}
