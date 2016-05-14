//
//  FileMetadataViewController.swift
//  Soundboard
//
//  Created by Jan on 14.05.16.
//  Copyright © 2016 dfragment.net. All rights reserved.
//

import UIKit
import AVFoundation

class FileMetadataViewController: UITableViewController {

    internal var fileUrl : NSURL?
    var metadata : [AVMetadataItem]?
    
    override func viewDidLoad() {
        loadMetadata()
        super.viewDidLoad()
        navigationItem.title = fileUrl?.lastPathComponent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadMetadata() {
        if let fileUrl = fileUrl {
            let avAsset = AVAsset(URL: fileUrl)
            metadata = avAsset.commonMetadata
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return metadata?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("metadataCell", forIndexPath: indexPath)

        let metadatum = metadata![indexPath.row]
        cell.textLabel!.text = metadatum.commonKey
        cell.detailTextLabel!.text = metadatum.stringValue

        return cell
    }

}
