//
//  SoundbiteDetailsViewController.swift
//  Soundboard
//
//  Created by Jan on 14.05.16.
//  Copyright © 2016 dfragment.net. All rights reserved.
//

import UIKit

class SoundbiteDetailsViewController: UITableViewController, UITextFieldDelegate {

    internal var soundbite : Soundbite?
    
    internal var callback : ((Soundbite) -> Void)?
    
    // UI components
    @IBOutlet weak var bgColourPreview: UIView!
    @IBOutlet weak var soundFileCell: UITableViewCell!
    @IBOutlet weak var soundbiteName: UITextField!
    @IBOutlet weak var foregroundSelector: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let soundbite = soundbite {
            navigationItem.title = soundbite.name
            soundbiteName.text = soundbite.name
            foregroundSelector.selectedSegmentIndex = soundbite.darkForeground ? 0 : 1
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Anything that might change in a child controller gets updated here
        setSoundFileName()
        setPreviewBackground()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "fileSelectionSegue" {
            let targetController = segue.destinationViewController as! FileSelectionViewController
            targetController.callback = { (url) in
                self.soundbite?.file = url
            }
        } else if segue.identifier == "colourSegue" {
            let targetController = segue.destinationViewController as! ColourMixerViewController
            targetController.initialColour = self.soundbite?.backgroundColour
            targetController.callback = { (colour) in
                self.soundbite?.backgroundColour = colour
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
    
    private func setPreviewBackground() {
        bgColourPreview.backgroundColor = soundbite?.backgroundColour
    }
    
    @IBAction func dismiss(sender: UIBarButtonItem) {
        soundbite?.name = soundbiteName.text!
        executeCallback()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == "" {
            textField.text = "Soundbite"
        }
        navigationItem.title = textField.text!
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
