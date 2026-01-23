//
//  UIRefreshControl+TestHelpers.swift
//  EssentialFeed
//
//  Created by Andres Sanchez on 23/1/26.
//

import UIKit

extension UIRefreshControl {
    func simulatePullToRefresh() {
        simulate(event: .valueChanged)
    }
}
