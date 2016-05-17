//
//  Soundbite.swift
//  Soundboard
//
//  Created by Jan on 14.05.16.
//  Copyright © 2016 dfragment.net. All rights reserved.
//

import UIKit
import CoreData

class Soundbite : NSManagedObject {
    
    private static let documentFolder =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    
    /// The filename; relative to the Documents folder.
    @NSManaged internal var relativeFile : String?
    
    /// The name of the soundbite.
    @NSManaged internal var name : String
    
    /// The background colour of the soundbite cell.
    @NSManaged internal var backgroundColour : UIColor
    
    /// Determines whether the foreground (text and buttons) of the cell are dark or white.
    @NSManaged internal var darkForeground : Bool
    
    /// If this is set to true, the soundbite will be deleted.
    internal var toBeDeleted : Bool = false
    
    // This property stores nothing, it just provides easy access to the underlying file.
    /// The URL pointing to the audio file's location on the disk.
    internal var file : NSURL?  {
        get {
            // Compose the URL from the document folder and the relative file name.
            if let fileName = relativeFile {
                return Soundbite.documentFolder.URLByAppendingPathComponent(fileName)
            } else {
                return nil
            }
        }
        set {
            // Extract the last path component (i.e. the filename) from the URL.
            if let file = newValue {
                relativeFile = file.lastPathComponent
            } else {
                relativeFile = nil
            }
        }
    }
    
    override func awakeFromInsert() {
        relativeFile = nil
        name = "Soundbite"
        backgroundColour = UIColor.whiteColor()
        darkForeground = true
    }
    
}
