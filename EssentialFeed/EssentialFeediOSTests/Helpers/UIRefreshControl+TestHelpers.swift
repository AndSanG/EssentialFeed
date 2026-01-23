//
//  UIRefreshControl+TestHelpers.swift
//  EssentialFeed
//
//  Created by Andres Sanchez on 23/1/26.
//

import UIKit

extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
