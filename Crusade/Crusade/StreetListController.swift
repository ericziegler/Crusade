//
//  StreetListController.swift
//  Crusade
//
//  Created by Eric Ziegler on 12/23/19.
//  Copyright © 2019 Zigabytes. All rights reserved.
//

import UIKit

// MARK: - Constants

let StreetListControllerId = "StreetListControllerId"

class StreetListController: BaseViewController {

    // MARK: - Properties

    @IBOutlet var streetTable: UITableView!

    // MARK: - Init

    class func createController() -> StreetListController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: StreetListController = storyboard.instantiateViewController(withIdentifier: StreetListControllerId) as! StreetListController
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension StreetListController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
