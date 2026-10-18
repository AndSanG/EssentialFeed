//
//  UITableView+Dequeueing.swift
//  EssentialFeed
//
//  Created by Andres Sanchez on 18/10/26.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
