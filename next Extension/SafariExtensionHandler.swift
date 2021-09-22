//
//  SafariExtensionHandler.swift
//  next Extension
//
//  Created by Andrey Dorofeev on 11.09.2021.
//

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
    
    private func nextPage(url: URL) -> URL? {
        var stringUrl = url.absoluteString
        
        let range = NSRange(location: 0, length: stringUrl.count)
        
        let regex = try! NSRegularExpression(pattern: "[0-9]+")
        let result = regex.matches(in: stringUrl, options: [], range: range)
        
        guard let lastMatchRange = result.last?.range,
              let stringRange = Range(lastMatchRange, in: stringUrl) else { return nil }
        
        let lastNumberString = stringUrl[stringRange]
        guard let lastNumber = UInt(lastNumberString) else { return nil }
        let upperNumber = lastNumber + 1
        
        stringUrl.replaceSubrange(stringRange, with: "\(upperNumber)")
        
        return URL(string: stringUrl)
    }
    
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        // This method will be called when a content script provided by your extension calls safari.extension.dispatchMessage("message").
        page.getPropertiesWithCompletionHandler { properties in
            NSLog("The extension received a message (\(messageName)) from a script injected into (\(String(describing: properties?.url))) with userInfo (\(userInfo ?? [:]))")
        }
    }

    override func toolbarItemClicked(in window: SFSafariWindow) {
        // This method will be called when your toolbar item is clicked.
        NSLog("The extension's toolbar item was clicked")
        window.getActiveTab { tab in
            tab?.getActivePage(completionHandler: { page in
                page?.getPropertiesWithCompletionHandler({ [weak self] properties in
                    guard let url = properties?.url,
                          let newUrl = self?.nextPage(url: url) else { return }
                    tab?.navigate(to: newUrl)
                })
            })
        }
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
        // This is called when Safari's state changed in some way that would require the extension's toolbar item to be validated again.
        validationHandler(true, "")
    }
    
    override func popoverViewController() -> SFSafariExtensionViewController {
        return SafariExtensionViewController.shared
    }

}
