//
//  AppSettings.swift
//  Soundboard
//
//  Created by Jan on 16.05.16.
//  Copyright © 2016 dfragment.net. All rights reserved.
//

import Foundation

class AppSettings {

    // Preference file keys
    private let ThemeSettingsKey = "darkTheme"
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    private init() {
        darkTheme = defaults.boolForKey(ThemeSettingsKey)
    }
    
    // MARK: - Singleton
    
    private static var _instance = AppSettings()
    
    /// Gets the singleton instance of the application's settings.
    internal class func instance() -> AppSettings {
        return _instance
    }
    
    // MARK: - Properties
    
    /// Determines whether the app uses a dark or a light theme.
    internal var darkTheme : Bool {
        didSet {
            defaults.setBool(darkTheme, forKey: ThemeSettingsKey)
        }
    }
    
}
