//
//  UIButton+TestHelpers.swift
//  EssentialFeed
//
//  Created by Andres Sanchez on 23/1/26.
//

import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
