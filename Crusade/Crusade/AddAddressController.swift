//
//  AddAddressController.swift
//  Crusade
//
//  Created by Eric Ziegler on 12/25/19.
//  Copyright © 2019 Zigabytes. All rights reserved.
//

import UIKit

// MARK: - Constants

let AddAddressListControllerId = "AddAddressListControllerId"

class AddAddressListController: BaseViewController {

    // MARK: - Properties

    @IBOutlet var statusLabel: BoldLabel!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var numberField: StyledTextField!
    @IBOutlet var streetField: StyledTextField!
    @IBOutlet var loadingView: UIView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    var routeManager = RouteManager.shared

    // MARK: - Init

    class func createController() -> AddAddressListController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: AddAddressListController = storyboard.instantiateViewController(withIdentifier: AddAddressListControllerId) as! AddAddressListController
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupButtons()
    }

    private func setupNavBar() {
        self.title = "Add Addresses"
        self.navigationController?.navigationBar.titleTextAttributes = navTitleTextAttributes()

        let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeTapped(_:)))
        self.navigationItem.leftBarButtonItem = closeButton
    }

    private func setupButtons() {
        addButton.layer.cornerRadius = 12
    }

    // MARK: - Actions

    @IBAction func closeTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func addTapped(_ sender: AnyObject) {
        if numberField.text?.count == 0 || streetField.text?.count == 0 {
            let alert = AlertView.createAlertFor(parentController: self, title: "Address Error", message: "Please enter both a street number and name.")
            alert.showAlert()
        } else {
            loadingView.isHidden = false
            loadingIndicator.startAnimating()
            view.endEditing(true)
        }
    }

}

// MARK: - UITextFieldDelegate

extension AddAddressListController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
