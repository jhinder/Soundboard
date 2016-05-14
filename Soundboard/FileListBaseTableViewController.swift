//
//  FileListBaseTableViewController.swift
//  Soundboard
//
//  Created by Jan on 14.05.16.
//  Copyright © 2016 dfragment.net. All rights reserved.
//

import UIKit

// This class is a base class for any table view controller
// that wants to enumerate the music files in the Documents folder.
// It only provides the basics (a data source and row/section count, basic cell).
// Any concrete subclass must implement anything it needs or wants to override.

class FileListBaseTableViewController: UITableViewController {

    internal var theFiles : [NSURL]?
    private let permittedExtensions : [String] = ["mp3", "m4a", "mp4", "wav"]
    
    internal var reuseIdentifier : String = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFiles()
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
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)

        let file = theFiles![indexPath.row]
        cell.textLabel!.text = file.lastPathComponent

        return cell
    }

}
