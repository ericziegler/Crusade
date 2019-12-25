//
//  AddressListController.swift
//  Crusade
//
//  Created by Eric Ziegler on 12/25/19.
//  Copyright © 2019 Zigabytes. All rights reserved.
//

import UIKit

// MARK: - Constants

let AddressListControllerId = "AddressListControllerId"

class AddressListController: BaseViewController {

    // MARK: - Properties

    @IBOutlet var addressTable: UITableView!
    var routeManager = RouteManager.shared

    // MARK: - Init

    class func createController() -> AddressListController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: AddressListController = storyboard.instantiateViewController(withIdentifier: AddressListControllerId) as! AddressListController
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }

    private func setupNavBar() {
        self.title = "Addresses"
        self.navigationController?.navigationBar.titleTextAttributes = navTitleTextAttributes()

        if let closeImage = UIImage(named: "Close")?.maskedImageWithColor(UIColor.appWhite) {
            let closeButton = UIButton(type: .custom)
            closeButton.addTarget(self, action: #selector(closeTapped(_:)), for: .touchUpInside)
            closeButton.setImage(closeImage, for: .normal)
            closeButton.frame = CGRect(x: 0, y: 0, width: closeImage.size.width, height: closeImage.size.height)
            let closeItem = UIBarButtonItem(customView: closeButton)
            self.navigationItem.leftBarButtonItems = [closeItem]
        }

        if let addImage = UIImage(named: "Add")?.maskedImageWithColor(UIColor.appWhite) {
            let addButton = UIButton(type: .custom)
            addButton.addTarget(self, action: #selector(addTapped(_:)), for: .touchUpInside)
            addButton.setImage(addImage, for: .normal)
            addButton.frame = CGRect(x: 0, y: 0, width: addImage.size.width, height: addImage.size.height)
            let addItem = UIBarButtonItem(customView: addButton)
            self.navigationItem.rightBarButtonItems = [addItem]
        }
    }

    // MARK: - Actions

    @IBAction func closeTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func addTapped(_ sender: AnyObject) {
        print("ADD TAPPED")
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension AddressListController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeManager.locationCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddressCellId, for: indexPath) as! AddressCell
        let guid = routeManager.allKeys[indexPath.row]
        if let location = routeManager.locationFor(guid: guid) {
            cell.layoutFor(location: location)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AddressCellHeight
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let guid = routeManager.allKeys[indexPath.row]
            if let location = routeManager.locationFor(guid: guid) {
                routeManager.remove(location: location)
                routeManager.saveRoute()
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }

}
