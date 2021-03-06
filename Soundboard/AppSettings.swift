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
    private let CloudBackupSettingsKey = "backupMusicToCloud"
    private let CellSizeSettingsKey = "cellSizeIndex"
    private let AllowOtherAudioSettingsKey = "allowOtherAudio"
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    private init() {
        darkTheme = defaults.boolForKey(ThemeSettingsKey)
        resetWhenStopping = defaults.boolForKey(ResetWhenStoppingSettingsKey)
        if defaults.objectForKey(CloudBackupSettingsKey) == nil {
            // not yet set -> enable backup by default
            cloudBackup = true
        } else {
            // some value is set
            cloudBackup = defaults.boolForKey(CloudBackupSettingsKey)
        }
        cellSizeIndex = defaults.integerForKey(CellSizeSettingsKey)
        
        if defaults.objectForKey(AllowOtherAudioSettingsKey) == nil { // same as with cloudBackup
            allowOtherAudio = true
        } else {
            allowOtherAudio = defaults.boolForKey(AllowOtherAudioSettingsKey)
        }
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
    
    /// Gets or sets if the Documents folder (containing all music files) should be backed up to the cloud.
    internal var cloudBackup : Bool {
        didSet {
            defaults.setBool(cloudBackup, forKey: CloudBackupSettingsKey)
        }
    }
    
    /// Gets or sets the index of the cell size settings (0 = normal, 1 = larger)
    internal var cellSizeIndex : Int {
        didSet {
            defaults.setInteger(cellSizeIndex, forKey: CellSizeSettingsKey)
        }
    }
    
    /// Gets or sets if other audio should be ducked while playing a soundbite.
    internal var allowOtherAudio : Bool {
        didSet {
            defaults.setBool(allowOtherAudio, forKey: AllowOtherAudioSettingsKey)
        }
    }
    
}
