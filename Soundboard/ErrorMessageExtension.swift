//
//  ErrorMessageExtension.swift
//  Soundboard
//
//  Created by Jan on 14.05.16.
//  Copyright © 2016 dfragment.net. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /**
     * Shows a simple error message to the user.
     * - Parameter message: The error message itself.
     * - Parameter title: The title of the error message.
     */
    public func showError(message: String!, title: String!) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
