//
//  Soundbite.swift
//  Soundboard
//
//  Created by Jan on 14.05.16.
//  Copyright © 2016 dfragment.net. All rights reserved.
//

import UIKit
import AVFoundation

struct Soundbite {
    
    internal var file : NSURL?
    
    internal var name : String
    
    internal var backgroundColour : UIColor
    
    internal var darkForeground : Bool
    
    internal var toBeDeleted : Bool = false
    
    init() {
        self.file = nil
        self.name = "Soundbite"
        backgroundColour = UIColor.whiteColor()
        darkForeground = true
    }
    
    init(withFile file: NSURL, andName name: String, andBackground bg: UIColor, useBlackForeground useDarkFg: Bool) {
        self.file = file
        self.name = name
        self.backgroundColour = bg
        self.darkForeground = useDarkFg
    }
    
}