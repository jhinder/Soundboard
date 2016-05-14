//
//  FileManagementViewController.swift
//  Soundboard
//
//  Created by Jan on 14.05.16.
//  Copyright © 2016 dfragment.net. All rights reserved.
//

import UIKit
import AVFoundation

class FileManagementViewController: UITableViewController {

    var theFiles : [NSURL]?
    let permittedExtensions : [String] = ["mp3", "m4a", "mp4", "wav"]
    
    let durationFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        durationFormatter.dateFormat = "mm:ss"
        durationFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        
        super.viewDidLoad()
        loadFiles()
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadFiles(updateTable: Bool = false) {
        let documentFolder =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        
        do {
            let allFiles = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(documentFolder, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions())
            
            // filter result set: only MP3/M4A/AAC/WAV files
            let mappedFiles = allFiles.filter({ (fileUrl) -> Bool in
                return permittedExtensions.contains(fileUrl.pathExtension?.lowercaseString ?? "")
            })
            
            if mappedFiles.isEmpty {
                showError("Could not find any music files.", title: "No music files")
            } else {
                theFiles = mappedFiles
            }
        } catch let error as NSError {
            print("Error while enumerating files", error)
            showError("Could not load sound files: \(error)", title: "Error")
        }
        
        if updateTable {
            tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theFiles?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("soundfileCell", forIndexPath: indexPath)

        let file = theFiles![indexPath.row]
        let durationDatetime = NSDate(timeIntervalSince1970: CMTimeGetSeconds(AVAsset(URL: file).duration))
        
        cell.textLabel!.text = file.lastPathComponent
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
