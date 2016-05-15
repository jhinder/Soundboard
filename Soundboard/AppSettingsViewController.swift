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
    
    let defaults = NSUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        darkThemeSwitch.on = defaults.boolForKey(ThemeSettingsKey)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func appThemeSwitcher(sender: UISwitch) {
        let notif = ThemeNotification()
        // Switch: on = dark, off = light
        notif.darkTheme = sender.on
        NSNotificationCenter.defaultCenter().postNotificationName(ThemeChangeNotification, object: notif)
    }
    
}

class ThemeNotification {
    
    internal var darkTheme : Bool = false
    
}
