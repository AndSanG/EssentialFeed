//
//  FeedViewController.swift
//  Prototype
//
//  Created by Andres Sanchez on 13/1/26.
//

import UIKit

final class FeedViewController: UITableViewController {

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "FeedImageCell")!
    }
}
