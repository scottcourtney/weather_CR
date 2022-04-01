//
//  Utils.swift
//  weather_CR
//
//  Created by Scott Courtney on 3/31/22.
//

import Foundation
import MBProgressHUD

class Utils {

    class var shared: Utils {
        struct Static {
            static let instance: Utils = Utils()
        }

        return Static.instance
    }

    // MARK: - MBProgressHUD

    func showSpinner(message: String?, view: UIView) {

        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.bezelView.color = UIColor.black.withAlphaComponent(0.45)
        loadingNotification.backgroundColor = UIColor.black.withAlphaComponent(0.45)
        loadingNotification.label.text = message!
        loadingNotification.contentColor = UIColor.white
    }

    func hideSpinner(view: UIView) {
        MBProgressHUD.hide(for: view, animated: true)
    }
}

