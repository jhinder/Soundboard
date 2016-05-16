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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        darkThemeSwitch.on = AppSettings.instance().darkTheme
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func appThemeSwitcher(sender: UISwitch) {
        AppSettings.instance().darkTheme = sender.on
        NSNotificationCenter.defaultCenter().postNotificationName(ThemeChangeNotification, object: nil)
    }
    
}
