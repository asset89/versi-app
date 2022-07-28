//
//  UIViewControllerExt.swift
//  versi-app
//
//  Created by Asset Ryskul on 28.07.2022.
//

import Foundation
import UIKit
import SafariServices

extension UIViewController {
    func presentSFSafariVCFor(url: String) {
        let readmeUrl = URL(string: url + readmeSegment)
        let safariVC = SFSafariViewController(url: readmeUrl!)
        present(safariVC, animated: true, completion: nil)
    }
}
