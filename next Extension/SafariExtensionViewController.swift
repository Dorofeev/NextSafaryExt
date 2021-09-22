//
//  SafariExtensionViewController.swift
//  next Extension
//
//  Created by Andrey Dorofeev on 11.09.2021.
//

import SafariServices

class SafariExtensionViewController: SFSafariExtensionViewController {
    
    static let shared: SafariExtensionViewController = {
        let shared = SafariExtensionViewController()
        shared.preferredContentSize = NSSize(width:320, height:240)
        return shared
    }()

}
