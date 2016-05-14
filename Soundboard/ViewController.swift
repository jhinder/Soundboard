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
        let index = getCellId(sender)
        let soundbite = soundbites[index]
        print("Playing soundbite \(index)/\(soundbite.name)")
        soundbite.play()
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
        
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.blackColor().CGColor
        
        return cell
    }
    
}
