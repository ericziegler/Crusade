
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
let MenuSectionHeight: CGFloat = 74

// MARK: - Protocols

protocol MenuControllerDelegate {
    func didSelectItem(menuItem: MenuItemType)
}

class MenuController: BaseViewController {

    // MARK: - Properties

    @IBOutlet var menuTable: UITableView!
    var curItem = MenuItemType.routes
    var delegate: MenuControllerDelegate?

    // MARK: - Init

    class func createController() -> MenuController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: MenuController = storyboard.instantiateViewController(withIdentifier: MenuControllerId) as! MenuController
        return viewController
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension MenuController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 5
        }
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuHeaderCellId, for: indexPath) as! MenuHeaderCell
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuCellId, for: indexPath) as! MenuCell
            cell.layoutFor(item: .routes, isSelected: curItem == .routes)
            return cell
        }
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuCellId, for: indexPath) as! MenuCell
            if indexPath.row == 0 {
                cell.layoutFor(item: .registerVoter, isSelected: curItem == .registerVoter)
            }
            else if indexPath.row == 1 {
                cell.layoutFor(item: .checkRegistration, isSelected: curItem == .checkRegistration)
            }
            else if indexPath.row == 2 {
                cell.layoutFor(item: .absenteeBallot, isSelected: curItem == .absenteeBallot)
            }
            else if indexPath.row == 3 {
                cell.layoutFor(item: .voteReminder, isSelected: curItem == .voteReminder)
            }
            else if indexPath.row == 4 {
                cell.layoutFor(item: .votePledge, isSelected: curItem == .votePledge)
            }
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return MenuHeaderHeight
        }
        return MenuCellHeight
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            return UIView.createTableHeaderWith(title: "Canvassing", tableView: tableView, bgColor: UIColor.appBlueGray, titleColor: UIColor.appWhite, font: UIFont.applicationFontOfSize(32))
        }
        else if section == 2 {
            return UIView.createTableHeaderWith(title: "Voter Info", tableView: tableView, bgColor: UIColor.appBlueGray, titleColor: UIColor.appWhite, font: UIFont.applicationFontOfSize(32))
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return MenuSectionHeight
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var needsReload = false

        if indexPath.section == 1 {
            curItem = .routes
            needsReload = true
        }
        else if indexPath.section == 2 {
            if indexPath.row == 0 {
                curItem = .registerVoter
            }
            else if indexPath.row == 1 {
                curItem = .checkRegistration
            }
            else if indexPath.row == 2 {
                curItem = .absenteeBallot
            }
            else if indexPath.row == 3 {
                curItem = .voteReminder
            }
            else if indexPath.row == 4 {
                curItem = .votePledge
            }
            needsReload = true
        }
        if needsReload == true {
            tableView.reloadData()
            delegate?.didSelectItem(menuItem: curItem)
        }
    }

}
