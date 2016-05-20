//
//  ColourMixerViewController.swift
//  Soundboard
//
//  Created by Jan on 14.05.16.
//  Copyright © 2016 dfragment.net. All rights reserved.
//

import UIKit

class ColourMixerViewController: UITableViewController {

    var backgroundIndex : Int = 0
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
        backgroundIndex = sender.selectedSegmentIndex
        updatePreview()
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        modified = true
        updatePreview()
    }
    
    func executeCallback() {
        if let _ = callback {
            if modified {
                callback!(uiColourFromSliders(colourFromSliders()))
            }
        }
    }
    
    func updatePreview() {
        let colourTuple = colourFromSliders()
        let colour = uiColourFromSliders(colourTuple)
        previewCellView.backgroundColor = colour
        var black : Bool
        if backgroundIndex == 2 {
            // Auto
            let greyValue = luminescence(colourTuple)
            // 0-127 = dark -> white text, 127-255 = light = black text
            black = (greyValue > 127.5) // 255.0/2.0
        } else {
            // black or white
            black = backgroundIndex == 0
        }
        previewCellText.textColor = black ? UIColor.blackColor() : UIColor.whiteColor()
    }
    
    /**
     * Creates a UIColor from a tuple of RGB colours.
     * - Returns: An instance of UIColor that corresponds to the RGB colours.
     */
    private func uiColourFromSliders(colours: (Float, Float, Float)) -> UIColor {
        return UIColor(red: CGFloat(redSlider.value/255.0), green: CGFloat(greenSlider.value/255.0), blue: CGFloat(blueSlider.value/255.0), alpha: 1.0)
    }
    
    /**
     * Creates a tuple of three colours (RGB) from the sliders.
     * The values are in the range of 0.0 to 255.0.
     */
    private func colourFromSliders() -> (Float, Float, Float) {
        return (redSlider.value, greenSlider.value, blueSlider.value)
    }
    
    /**
     * Calculates the luma according to ITU-R BT.709.
     * - Returns: The luma of the RGB colour; the value is in the 0.0 to 255.0 range.
     */
    private func luminescence(colours: (Float, Float, Float)) -> Float {
        return  0.2126 * colours.0 + 0.7152 * colours.1 + 0.0722 * colours.2
    }
}
