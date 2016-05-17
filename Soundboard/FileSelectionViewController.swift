//
//  FIleSelectionViewController.swift
//  Soundboard
//
//  Created by Jan on 14.05.16.
//  Copyright © 2016 dfragment.net. All rights reserved.
//

import UIKit

class FileSelectionViewController: FileListBaseTableViewController {

    /// A callback that gets invoked when this view returns. The parameter contains the URL of the selected audio file. 
    internal var callback : ((NSURL) -> Void)?
    
    internal var selectedUrl : NSURL?
    
    override func viewDidLoad() {
        reuseIdentifier = "cell"
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedUrl = theFiles![indexPath.row].absoluteURL
        executeCallback()
    }
    
    func executeCallback() {
        if let _ = callback {
            callback!(selectedUrl!)
            navigationController?.popViewControllerAnimated(true)
        } else {
            print("Callback was not set!")
        }
    }

}
