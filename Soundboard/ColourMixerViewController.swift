//
//  ColourMixerViewController.swift
//  Soundboard
//
//  Created by Jan on 14.05.16.
//  Copyright © 2016 dfragment.net. All rights reserved.
//

import UIKit

class ColourMixerViewController: UITableViewController {

    var blackText = true
    var modified = false
    
    /// A callback that gets invoked when this view returns. The parameter contains the new colour.
    internal var callback : ((UIColor) -> Void)?
    /// Set this value before displaying the view controller if you want to set the sliders to the correct values.
    internal var initialColour : UIColor?
    
    @IBOutlet weak var previewCellView: UIView!
    @IBOutlet weak var previewCellText: UILabel!
    
    @IBOutlet weak var redSlider : UISlider!
    @IBOutlet weak var greenSlider : UISlider!
    @IBOutlet weak var blueSlider : UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let initColour = initialColour {
            let numOfComponents = CGColorGetNumberOfComponents(initColour.CGColor)
            let components = CGColorGetComponents(initColour.CGColor)
            if numOfComponents == 2 {
                // greyscale
                let greyValue = Float(components[0] * 255.0)
                redSlider.value = greyValue
                greenSlider.value = greyValue
                blueSlider.value = greyValue
            } else if numOfComponents == 4 {
                // colour
                redSlider.value = Float(components[0] * 255.0)
                greenSlider.value = Float(components[1] * 255.0)
                blueSlider.value = Float(components[2] * 255.0)
            } else {
                print("Unknown number of components")
            }
            updatePreview()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        if isMovingFromParentViewController() {
            executeCallback()
        }
        
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func textColourChanged(sender: UISegmentedControl) {
        blackText = sender.selectedSegmentIndex == 0
        updatePreview()
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        modified = true
        updatePreview()
    }
    
    func executeCallback() {
        if let _ = callback {
            if modified {
                callback!(colourFromSliders())
            }
        }
    }
    
    func updatePreview() {
        let colour = colourFromSliders()
        previewCellView.backgroundColor = colour
        previewCellText.textColor = blackText ? UIColor.blackColor() : UIColor.whiteColor()
    }
    
    /**
     * Creates a UIColor from the slider values.
     * - Returns: An instance of UIColor that corresponds to the slider values.
     */
    private func colourFromSliders() -> UIColor {
        return UIColor(red: CGFloat(redSlider.value/255.0), green: CGFloat(greenSlider.value/255.0), blue: CGFloat(blueSlider.value/255.0), alpha: 1.0)
    }
}
