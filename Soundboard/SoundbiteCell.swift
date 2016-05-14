//
//  SoundbiteCell.swift
//  Soundboard
//
//  Created by Jan on 14.05.16.
//  Copyright © 2016 dfragment.net. All rights reserved.
//

import UIKit

class SoundbiteCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    internal func setName(name: String) {
        nameLabel.text = name
    }
    
    override func tintColorDidChange() {
        // UILabel ignores tintColor in favour of its own textColor,
        // so we force it to update textColor to maintain a consistent
        // colour for all elements in the cell.
        nameLabel.textColor = tintColor
    }
    
}
