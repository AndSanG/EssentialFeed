//
//  UIControl+TestHelpers.swift
//  EssentialFeed
//
//  Created by Andres Sanchez on 23/1/26.
//

import UIKit

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
