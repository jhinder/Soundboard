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
    private let ResetWhenStoppingSettingsKey = "resetUponStop"
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    private init() {
        darkTheme = defaults.boolForKey(ThemeSettingsKey)
        resetWhenStopping = defaults.boolForKey(ResetWhenStoppingSettingsKey)
    }
    
    // MARK: - Singleton
    
    private static var _instance = AppSettings()
    
    /// Gets the singleton instance of the application's settings.
    internal class func instance() -> AppSettings {
        return _instance
    }
    
    // MARK: - Properties
    
    /// Gets or sets whether the app uses a dark or a light theme.
    internal var darkTheme : Bool {
        didSet {
            defaults.setBool(darkTheme, forKey: ThemeSettingsKey)
        }
    }
    
    /// Gets or sets if the play position should be reset when playback is stopped.
    internal var resetWhenStopping : Bool {
        didSet {
            defaults.setBool(resetWhenStopping, forKey: ResetWhenStoppingSettingsKey)
        }
    }
    
}
