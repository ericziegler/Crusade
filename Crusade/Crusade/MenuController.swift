
//
//  MenuController.swift
//  Crusade
//
//  Created by Eric Ziegler on 12/22/19.
//  Copyright © 2019 Zigabytes. All rights reserved.
//

import UIKit

// MARK: - Constants

let MenuControllerId = "MenuControllerId"

class MenuController: BaseViewController {

    // MARK: Init

    class func createController() -> MenuController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: MenuController = storyboard.instantiateViewController(withIdentifier: MenuControllerId) as! MenuController
        return viewController
    }

}
