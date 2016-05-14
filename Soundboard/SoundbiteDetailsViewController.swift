//
//  SoundbiteDetailsViewController.swift
//  Soundboard
//
//  Created by Jan on 14.05.16.
//  Copyright © 2016 dfragment.net. All rights reserved.
//

import UIKit

class SoundbiteDetailsViewController: UITableViewController {

    internal var soundbite : Soundbite?
    
    internal var callback : ((Soundbite) -> Void)?
    
    // UI components
    @IBOutlet weak var soundFileCell: UITableViewCell!
    @IBOutlet weak var soundbiteName: UITextField!
    @IBOutlet weak var foregroundSelector: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let soundbite = soundbite {
            navigationItem.title = soundbite.name
            soundbiteName.text = soundbite.name
            setSoundFileName()
            foregroundSelector.selectedSegmentIndex = soundbite.darkForeground ? 0 : 1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "fileSelectionSegue" {
            let targetController = segue.destinationViewController as! FileSelectionViewController
            targetController.callback = { (url) in
                self.soundbite?.file = url
                self.setSoundFileName()
            }
        }
    }
    
    private func setSoundFileName() {
        if let url = soundbite?.file {
            soundFileCell.detailTextLabel!.text = url.lastPathComponent
        } else {
            soundFileCell.detailTextLabel!.text = "(none selected)"
        }
    }
    
    @IBAction func dismiss(sender: UIBarButtonItem) {
        executeCallback()
    }

    @IBAction func endEditing(sender: UITextField) {
        if (sender.text! == "") {
            sender.text = "Soundbite"
        }
        navigationItem.title = sender.text!
        soundbite?.name = sender.text!
    }
    
    @IBAction func deleteSoundbite(sender: UIButton) {
        let deleteConfirmation = UIAlertController(title: "Delete soundbite?", message: "Do you really want to remove this soundbite?\nThis will remove its settings, but not the music file.", preferredStyle: .Alert)
        deleteConfirmation.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        deleteConfirmation.addAction(UIAlertAction(title: "Delete", style: .Destructive, handler: { (action) in
            if let _ = self.callback {
                print("Marking soundbite as 'delete'")
                self.soundbite?.toBeDeleted = true
                self.executeCallback()
            }
        }))
        self.presentViewController(deleteConfirmation, animated: true, completion: nil)
        
    }
    
    @IBAction func changedForegroundColour(sender: UISegmentedControl) {
        soundbite?.darkForeground = (sender.selectedSegmentIndex == 0)
    }
    
    func executeCallback() {
        if let _ = self.callback {
            callback!(soundbite!)
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            print("No callback specified!")
        }
    }
    
}
