//
//  VoteController.swift
//  Crusade
//
//  Created by Eric Ziegler on 12/22/19.
//  Copyright © 2019 Zigabytes. All rights reserved.
//

import UIKit
import WebKit

// MARK: - Constants

let VoteControllerId = "VoteControllerId"

class VoteController: BaseViewController {

    // MARK: - Properties

    @IBOutlet var voteWebView: WKWebView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    var itemType = MenuItemType.registerVoter

    // MARK: - Init

    class func createController() -> VoteController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: VoteController = storyboard.instantiateViewController(withIdentifier: VoteControllerId) as! VoteController
        return viewController
    }

    // MARK: - Loading

    func loadRequest() {
        voteWebView.navigationDelegate = self
        DispatchQueue.main.async {
            self.loadingIndicator.isHidden = false
            self.loadingIndicator.startAnimating()
        }
        if let registerPath = Bundle.main.path(forResource: itemType.fileName, ofType: "html") {
            let url = URL(fileURLWithPath: registerPath)
            let request = URLRequest(url: url)
            voteWebView.load(request)
        }
    }

}

// MARK: - WKNavigationDelegate

extension VoteController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.isHidden = true
        }
    }

}
