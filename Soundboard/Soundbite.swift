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
    
    @NSManaged internal var file : NSURL?
    
    @NSManaged internal var name : String
    
    @NSManaged internal var backgroundColour : UIColor
    
    @NSManaged internal var darkForeground : Bool
    
    internal var toBeDeleted : Bool = false
    
    override func awakeFromInsert() {
        file = nil
        name = "Soundbite"
        backgroundColour = UIColor.whiteColor()
        darkForeground = true
    }
    
}
