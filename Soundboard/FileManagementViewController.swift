//
//  FileManagementViewController.swift
//  Soundboard
//
//  Created by Jan on 14.05.16.
//  Copyright © 2016 dfragment.net. All rights reserved.
//

import UIKit
import AVFoundation

class FileManagementViewController: FileListBaseTableViewController {

    let durationFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        reuseIdentifier = "soundfileCell"
        super.viewDidLoad()
        
        durationFormatter.dateFormat = "mm:ss"
        durationFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)

        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)

        let file = theFiles![indexPath.row]
        let durationDatetime = NSDate(timeIntervalSince1970: CMTimeGetSeconds(AVAsset(URL: file).duration))
        cell.detailTextLabel!.text = durationFormatter.stringFromDate(durationDatetime)

        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let url = theFiles![indexPath.row]
            do {
                tableView.beginUpdates()
                try NSFileManager.defaultManager().removeItemAtURL(url)
                print("Deleted file:", url.lastPathComponent)
                theFiles?.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                tableView.endUpdates()
            } catch let error as NSError {
                print("Could not delete file:", error)
                showError("The file \"\(url.lastPathComponent)\" could not be removed.", title: "Error")
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "metadataSegue" {
            let targetViewController = segue.destinationViewController as! FileMetadataViewController
            targetViewController.fileUrl = theFiles![(tableView.indexPathForSelectedRow?.row)!]
        }
    }


}
