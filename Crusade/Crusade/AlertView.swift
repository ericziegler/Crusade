//
//  AlertView.swift
//

import UIKit

// MARK: - Constants

let AlertViewTopConstraintConstant: CGFloat = 105
let AlertViewDarkAnimateInterval: TimeInterval = 0.15
let AlertViewLightAnimateInterval: TimeInterval = 0.2

// MARK: - Protocols

protocol AlertViewDelegate {
    func okTappedForAlertView(alertView: AlertView)
}

class AlertView: UIView {

    // MARK: - Properties

    @IBOutlet var bgView: UIView!
    @IBOutlet var alertViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var titleLabel: BoldLabel!
    @IBOutlet var messageLabel: RegularLabel!
    @IBOutlet var okButton: BoldButton!

    var delegate: AlertViewDelegate?

    // MARK: - Init

    class func createAlertFor(parentController: UIViewController, title: String?, message: String?, buttonTitle: String = "OK") -> AlertView {
        let alert: AlertView = UIView.fromNib()
        alert.fillInParentView(parentView: parentController.view)
        alert.titleLabel.text = title
        alert.messageLabel.text = message
        alert.messageLabel.sizeToFit()
        return alert
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 15
        showAlert()
    }

    // MARK: - Show / Hide Animations

    func showAlert() {
        self.alpha = 0
        alertViewTopConstraint.constant = 0
        UIView.animate(withDuration: AlertViewDarkAnimateInterval, animations: {
            self.alpha = 1
        }) { (didFinish) in
            UIView.animate(withDuration: AlertViewLightAnimateInterval) {
                self.alertViewTopConstraint.constant = AlertViewTopConstraintConstant
                self.layoutIfNeeded()
            }
        }
    }

    func hideAlert() {
        UIView.animate(withDuration: AlertViewDarkAnimateInterval, animations: {
            self.alpha = 0
        }) { (didFinish) in
            self.removeFromSuperview()
            self.delegate?.okTappedForAlertView(alertView: self)
        }
    }

    // MARK: - Actions

    @IBAction func okTapped(_ sender: AnyObject) {
        hideAlert()
    }

}
