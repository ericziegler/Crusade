//
//  AddAddressController.swift
//  Crusade
//
//  Created by Eric Ziegler on 12/25/19.
//  Copyright © 2019 Zigabytes. All rights reserved.
//

import UIKit
import CoreLocation

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
            findCoordinates()
        }
    }

    // MARK: - Geocoding

    private func findCoordinates() {
        let geoCoder = CLGeocoder()
        let address = "\(numberField.text!) \(streetField.text!)"
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            DispatchQueue.main.async {
                self.loadingView.isHidden = true
                self.loadingIndicator.stopAnimating()
            }
            guard
                let placemarks = placemarks,
                let result = placemarks.first?.location
            else {
                DispatchQueue.main.async {
                    let alert = AlertView.createAlertFor(parentController: self, title: "Address Not Found", message: "Please verify the street name and number are correct.")
                    alert.showAlert()
                }
                return
            }
            
            // location found
            let location = Location(streetNumber: self.numberField.text!, streetName: self.streetField.text!, coordinate: result.coordinate)
            self.routeManager.add(location: location)
            self.routeManager.saveRoute()

            DispatchQueue.main.async {
                self.numberField.text = nil
                self.numberField.becomeFirstResponder()
                self.statusLabel.alpha = 1
                UIView.animate(withDuration: 0.05, delay: 2.5, options: .curveEaseInOut, animations: {
                    self.statusLabel.alpha = 0
                }, completion: nil)
            }
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
