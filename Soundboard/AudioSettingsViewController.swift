//
//  AudioSettingsViewController.swift
//  Soundboard
//
//  Created by Jan on 20.05.16.
//  Copyright © 2016 dfragment.net. All rights reserved.
//

import UIKit

class AudioSettingsViewController: UITableViewController {

    @IBOutlet weak var resetOnStopSwitch: UISwitch!
    
    let settings = AppSettings.instance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetOnStopSwitch.on = settings.resetWhenStopping
    }
    
    @IBAction func resetOnStopChanged(sender: UISwitch) {
        settings.resetWhenStopping = sender.on
    }
    
}
