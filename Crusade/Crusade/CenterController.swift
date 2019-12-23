//
//  CenterController.swift
//  Crusade
//
//  Created by Eric Ziegler on 12/22/19.
//  Copyright © 2019 Zigabytes. All rights reserved.
//

import UIKit

// MARK: - Constants

let CenterControllerId = "CenterControllerId"

// MARK: - Protocols

protocol CenterControllerDelegate {
    func toggleLeftPanel()
}

class CenterController: BaseViewController {

    // MARK: - Properties

    @IBOutlet var container: UIView!
    var delegate: CenterControllerDelegate?
    var initialController: UIViewController!
    var initialHeader = MenuItemType.routes.headerTitle

    // MARK: Init

    class func createControllerWith(initialController: UIViewController, initialHeader: String) -> CenterController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: CenterController = storyboard.instantiateViewController(withIdentifier: CenterControllerId) as! CenterController
        viewController.initialController = initialController
        viewController.initialHeader = initialHeader
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initNavBar()
        displayController(initialController, headerTitle: initialHeader)
    }

    private func initNavBar() {
        self.navigationController?.navigationBar.titleTextAttributes = navTitleTextAttributes()

        if let menuImage = UIImage(named: "Menu")?.maskedImageWithColor(.appWhite) {
            let menuButton = UIButton(type: .custom)
            menuButton.addTarget(self, action: #selector(menuTapped(_:)), for: .touchUpInside)
            menuButton.setImage(menuImage, for: .normal)
            menuButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 3, right: 0)
            menuButton.frame = CGRect(x: 0, y: 0, width: menuImage.size.width, height: menuImage.size.height)
            let menuItem = UIBarButtonItem(customView: menuButton)
            self.navigationItem.leftBarButtonItems = [menuItem]
        }
    }

    func displayController(_ controller: UIViewController, headerTitle: String) {
        controller.view.fillInParentView(parentView: container)
        addChild(controller)
        controller.didMove(toParent: self)
        self.title = headerTitle
    }

    // MARK: - Actions

    @IBAction func menuTapped(_ sender: AnyObject) {
        delegate?.toggleLeftPanel()
    }

}

