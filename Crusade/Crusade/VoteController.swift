//
//  VoteController.swift
//  Crusade
//
//  Created by Eric Ziegler on 12/22/19.
//  Copyright © 2019 Zigabytes. All rights reserved.
//

import UIKit

// MARK: - Constants

let VoteControllerId = "VoteControllerId"

class VoteController: BaseViewController {

    // MARK: - Init

    class func createController() -> VoteController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: VoteController = storyboard.instantiateViewController(withIdentifier: VoteControllerId) as! VoteController
        return viewController
    }

}
