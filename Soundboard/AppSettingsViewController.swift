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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        darkThemeSwitch.on = AppSettings.instance().darkTheme
        resetOnStopSwitch.on = AppSettings.instance().resetWhenStopping
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func appThemeSwitcher(sender: UISwitch) {
        AppSettings.instance().darkTheme = sender.on
        NSNotificationCenter.defaultCenter().postNotificationName(ThemeChangeNotification, object: nil)
    }
    
    @IBAction func resetOnStopChanged(sender: UISwitch) {
        AppSettings.instance().resetWhenStopping = sender.on
    }
    
}
