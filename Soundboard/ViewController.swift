//
//  ViewController.swift
//  Soundboard
//
//  Created by Jan on 14.05.16.
//  Copyright © 2016 dfragment.net. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {

    var soundbites : [Soundbite] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.lightGrayColor()
        // Don't register cells here, we've already set the cell identifier in the storyboard.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addCell(sender: UIBarButtonItem) {
        soundbites.append(Soundbite())
        collectionView?.reloadData()
    }
    
    private func getCellId(button: UIButton) -> Int {
        let convertedPoint = collectionView?.convertPoint(button.center, fromView: button.superview)
        let indexPath = collectionView?.indexPathForItemAtPoint(convertedPoint!)
        return (indexPath?.row)!
    }
    
    @IBAction func playbackCell(sender: UIButton) {
        let indexPath = getCellId(sender)
        print("Playing cell:", indexPath)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "soundbiteDetailSegue" {
            let targetViewController = (segue.destinationViewController as! UINavigationController).viewControllers[0] as! SoundbiteDetailsViewController
            let cellId = getCellId(sender as! UIButton)
            targetViewController.soundbite = soundbites[cellId]
            targetViewController.callback = { (soundbite) in
                if soundbite.toBeDeleted {
                    print("Soundbite \(cellId) should be deleted")
                    self.soundbites.removeAtIndex(cellId)
                } else {
                    print("Soundbite \(cellId) will be updated")
                    self.soundbites[cellId] = soundbite
                }
                self.collectionView?.reloadData()
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return soundbites.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("playCell", forIndexPath: indexPath) as! SoundbiteCell
        
        let soundbite = soundbites[indexPath.row]
        cell.backgroundColor = soundbite.backgroundColour
        cell.tintColor = soundbite.darkForeground ? UIColor.blackColor() : UIColor.whiteColor()
        cell.setName(soundbite.name)
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
     
     }
     */


}
