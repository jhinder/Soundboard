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
    @IBOutlet weak var allowOtherAudioSwitch: UISwitch!
    
    let settings = AppSettings.instance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetOnStopSwitch.on = settings.resetWhenStopping
        allowOtherAudioSwitch.on = settings.allowOtherAudio
    }
    
    @IBAction func resetOnStopChanged(sender: UISwitch) {
        settings.resetWhenStopping = sender.on
    }
    
    @IBAction func allowOtherAudioChanged(sender: UISwitch) {
        settings.allowOtherAudio = sender.on
        NSNotificationCenter.defaultCenter().postNotificationName(AudioOptionsChangeNotification, object: nil)
    }
    
}
