//
//  AddressCell.swift
//  Crusade
//
//  Created by Eric Ziegler on 12/24/19.
//  Copyright © 2019 Zigabytes. All rights reserved.
//

import UIKit

// MARK: - Constants

let AddressCellId = "AddressCellId"
let AddressCellHeight: CGFloat = 64

class AddressCell: UITableViewCell {

    // MARK: - Properties

    @IBOutlet var addressLabel: RegularLabel!
    @IBOutlet var checkmarkImageView: UIImageView!

    // MARK: - Layout

    func layoutFor(location: Location) {
        addressLabel.text = "\(location.streetNumber) \(location.streetName)"
        checkmarkImageView.alpha = (location.hasKnocked == true) ? 1 : CheckmarkAlpha
    }

}
