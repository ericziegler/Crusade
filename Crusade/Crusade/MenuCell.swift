//
//  MenuCell.swift
//  Crusade
//
//  Created by Eric Ziegler on 12/22/19.
//  Copyright © 2019 Zigabytes. All rights reserved.
//

import UIKit

// MARK: - Constants

let MenuCellId = "MenuCellId"
let MenuCellHeight: CGFloat = 64

class MenuCell: UITableViewCell {

    // MARK: - Properties

    @IBOutlet var selectionView: UIView!
    @IBOutlet var itemLabel: RegularLabel!
    var itemType = MenuItemType.routes

    // MARK: - Layout

    func layoutFor(item: MenuItemType, isSelected: Bool) {
        itemType = item
        itemLabel.text = item.rawValue
        selectionView.backgroundColor = (isSelected == true) ? UIColor.appLightBlueGray : UIColor.appBlueGray
    }

}
