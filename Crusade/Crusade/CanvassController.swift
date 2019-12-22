//
//  CanvassController.swift
//  Crusade
//
//  Created by Eric Ziegler on 12/22/19.
//  Copyright © 2019 Zigabytes. All rights reserved.
//

import UIKit

// MARK: - Constants

let CanvassControllerId = "CanvassControllerId"

class CanvassController: BaseViewController {

    // MARK: - Init

    class func createController() -> CanvassController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: CanvassController = storyboard.instantiateViewController(withIdentifier: CanvassControllerId) as! CanvassController
        return viewController
    }

}
