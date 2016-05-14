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
    
}
