//
//  UIImageView+Animations.swift
//  EssentialFeed
//
//  Created by Andres Sanchez on 18/10/26.
//

import UIKit

extension UIImageView {
    func setImageAnimated(_ newImage: UIImage?) {
        image = newImage

        guard newImage != nil else { return }

        alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
}
