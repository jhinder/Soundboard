//
//  AppSettingsViewController.swift
//  Soundboard
//
//  Created by Jan on 14.05.16.
//  Copyright © 2016 dfragment.net. All rights reserved.
//

import UIKit

class AppSettingsViewController: UITableViewController {

    @IBOutlet weak var darkThemeSwitch: UISwitch!
    @IBOutlet weak var resetOnStopSwitch: UISwitch!
    @IBOutlet weak var cloudBackupSwitch: UISwitch!
    
    let settings = AppSettings.instance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        darkThemeSwitch.on = settings.darkTheme
        resetOnStopSwitch.on = settings.resetWhenStopping
        cloudBackupSwitch.on = settings.cloudBackup
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func appThemeSwitcher(sender: UISwitch) {
        settings.darkTheme = sender.on
        NSNotificationCenter.defaultCenter().postNotificationName(ThemeChangeNotification, object: nil)
    }
    
    @IBAction func resetOnStopChanged(sender: UISwitch) {
        settings.resetWhenStopping = sender.on
    }
    
    @IBAction func cloudBackupChanged(sender: UISwitch) {
        let isOn = sender.on
        settings.cloudBackup = isOn
        
        do {
            try NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!.setResourceValue(isOn, forKey: NSURLIsExcludedFromBackupKey)
        } catch {
            print("Could not set Backup flag to", isOn, "; ", error)
        }

    }
    
}
