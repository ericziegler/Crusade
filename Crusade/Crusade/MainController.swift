//
//  MainController.swift
//  Crusade
//
//  Created by Eric Ziegler on 12/21/19.
//  Copyright © 2019 Zigabytes. All rights reserved.
//

import UIKit

// MARK: - Constants

let MainControllerId = "MainControllerId"
let CenterPanelExpandedOffset: CGFloat = 90

// MARK: - Enums

enum SlideOutState {
    case allCollapsed
    case leftExpanded
}

class MainController: BaseViewController {

    // MARK: - Properties

    var centerNavController: BaseNavigationController!
    var centerController: CenterController!
    var leftController: MenuController!
    var canvassController: CanvassController!
    var voteController: VoteController!
    var currentItem = MenuItemType.routes
    var currentState: SlideOutState = .allCollapsed {
      didSet {
        let shouldShowShadow = currentState != .allCollapsed
        showShadowForCenterController(shouldShowShadow)
      }
    }

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        initChildControllers()
        setupCenterController()
        setupGestureRecognizers()
    }

    private func initChildControllers() {
        if canvassController == nil {
            canvassController = CanvassController.createController()
        }
        if voteController == nil {
            voteController = VoteController.createController()
        }
    }

    private func setupCenterController() {
        centerController = CenterController.createControllerWith(initialController: canvassController, initialHeader: currentItem.headerTitle)
        centerController.delegate = self
        centerNavController = BaseNavigationController(rootViewController: centerController)
        view.addSubview(centerNavController.view)
        addChild(centerNavController)
        centerNavController.didMove(toParent: self)
        centerNavController.view.layer.shadowRadius = 3
        centerNavController.view.layer.shadowColor = UIColor.lightGray.cgColor
        centerNavController.view.clipsToBounds = false
    }

    private func setupGestureRecognizers() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(collapseMenuTapped(_:)))
        centerNavController.view.addGestureRecognizer(tapRecognizer)
    }

    // MARK: - Actions

    @IBAction func collapseMenuTapped(_ sender: AnyObject) {
        if currentState != .allCollapsed {
            handleToggleLeft()
        }
    }

    // MARK: - Panel Navigation

    private func handleToggleLeft() {
        self.view.endEditing(true)
        let notAlreadyExpanded = (currentState != .leftExpanded)
        if notAlreadyExpanded {
          addLeftController()
        }
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }

    private func addLeftController() {
      guard leftController == nil else { return }

        let vc = MenuController.createController()
        addChildSidePanelController(vc)
        leftController = vc
        leftController.delegate = self
    }

    private func addChildSidePanelController(_ menuController: MenuController) {
      view.insertSubview(menuController.view, at: 0)
      addChild(menuController)
      menuController.didMove(toParent: self)
    }

    private func animateLeftPanel(shouldExpand: Bool) {
      if shouldExpand {
        currentState = .leftExpanded
        animateCenterPanelXPosition(targetPosition: centerNavController.view.frame.width - CenterPanelExpandedOffset)
      } else {
        animateCenterPanelXPosition(targetPosition: 0) { _ in
          self.currentState = .allCollapsed
          self.leftController?.view.removeFromSuperview()
          self.leftController = nil
        }
      }
    }

    private func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
      UIView.animate(
        withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
          self.centerNavController.view.frame.origin.x = targetPosition
        },
        completion: completion)
    }

    private func showShadowForCenterController(_ shouldShowShadow: Bool) {
      if shouldShowShadow {
        centerNavController.view.layer.shadowOpacity = 0.6
      } else {
        centerNavController.view.layer.shadowOpacity = 0.0
      }
    }

}

// MARK: - CenterControllerDelegate

extension MainController: CenterControllerDelegate {

  func toggleLeftPanel() {
    handleToggleLeft()
  }

}

// MARK: - MenuControllerDelegate

extension MainController: MenuControllerDelegate {

    func didSelectItem(menuItem: MenuItemType) {
        if currentItem != menuItem {
            if menuItem == .routes {
                centerController.displayController(canvassController, headerTitle: menuItem.headerTitle)
            } else {
                centerController.displayController(voteController, headerTitle: menuItem.headerTitle)
                voteController.itemType = menuItem
                voteController.loadRequest()
            }
            currentItem = menuItem
        }
        toggleLeftPanel()
    }

}

