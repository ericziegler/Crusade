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
    @IBOutlet var noDataView: UIView!
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addressTable.reloadData()
        noDataView.isHidden = (routeManager.locationCount == 0) ? false : true
    }

    private func setupNavBar() {
        self.title = "Addresses"
        self.navigationController?.navigationBar.titleTextAttributes = navTitleTextAttributes()

        var closeItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(closeTapped(_:)))
        if #available(iOS 13.0, *) {
            closeItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(closeTapped(_:)))
        }
        self.navigationItem.leftBarButtonItem = closeItem

        var addItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped(_:)))
        if #available(iOS 13.0, *) {
            addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped(_:)))
        }
        var removeAllItem = UIBarButtonItem(title: "Clear All", style: .plain, target: self, action: #selector(removeAllTapped(_:)))
        if #available(iOS 13.0, *) {
            removeAllItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeAllTapped(_:)))
        }
        self.navigationItem.rightBarButtonItems = [addItem, removeAllItem]
    }

    // MARK: - Actions

    @IBAction func closeTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func addTapped(_ sender: AnyObject) {
        let controller = AddAddressListController.createController()
        let navController = BaseNavigationController(rootViewController: controller)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }

    @IBAction func removeAllTapped(_ sender: AnyObject) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        // custom title
        let titleString = "Are you sure you would like to remove all addresses?"
        alert.setValue(NSAttributedString(string: titleString, attributes: [NSAttributedString.Key.font : UIFont.applicationBoldFontOfSize(20), .foregroundColor : UIColor.appBlack]), forKey: "attributedTitle")
        // cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        // destrictove action
        let removeAllAction = UIAlertAction(title: "Remove All", style: .destructive) { (action) in
            self.routeManager.removeAll()
            self.routeManager.saveRoute()
            self.addressTable.reloadData()
            self.noDataView.isHidden = (self.routeManager.locationCount == 0) ? false : true
        }
        alert.addAction(removeAllAction)

        self.present(alert, animated: true, completion: nil)
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension AddressListController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeManager.locationsSortedByAddress.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddressCellId, for: indexPath) as! AddressCell
        let location = routeManager.locationsSortedByAddress[indexPath.row]
        cell.layoutFor(location: location)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AddressCellHeight
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let location = routeManager.locationsSortedByAddress[indexPath.row]
            routeManager.remove(location: location)
            routeManager.saveRoute()
            tableView.deleteRows(at: [indexPath], with: .fade)
            noDataView.isHidden = (routeManager.locationCount == 0) ? false : true
        }
    }

}
