//
//  ViewController.swift
//  Soundboard
//
//  Created by Jan on 14.05.16.
//  Copyright © 2016 dfragment.net. All rights reserved.
//

import UIKit
import CoreData

internal let ThemeChangeNotification = "ThemeChange"

class ViewController: UICollectionViewController {

    @IBOutlet weak var deleteBarButtonItem: UIBarButtonItem!
    
    /// The app delegate
    private let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    /// The CoreData context
    private let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var soundbites : [Soundbite] = []

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ThemeChangeNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Don't register cells here, we've already set the cell identifier in the storyboard.
        
        // Load data
        let fetchRequest = NSFetchRequest(entityName: "Soundbite")
        do {
            let resultSet = try context.executeFetchRequest(fetchRequest)
            soundbites = resultSet as! [Soundbite]
        } catch {
            print("Could not fetch data:", error)
        }
        
        setTheme()
        NSNotificationCenter.defaultCenter().addObserverForName(ThemeChangeNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) in
            self.setTheme()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setTheme() {
        let dark = AppSettings.instance().darkTheme
        self.navigationController?.navigationBar.tintColor = (dark ? UIColor.whiteColor() : nil)
        self.navigationController?.navigationBar.barStyle = (dark ? .Black : .Default)
        self.collectionView?.backgroundColor = (dark ? UIColor.darkGrayColor() : UIColor.whiteColor())
    }
    
    @IBAction func addCell(sender: UIBarButtonItem) {
        let soundbite = NSEntityDescription.insertNewObjectForEntityForName("Soundbite", inManagedObjectContext: context) as! Soundbite
        appDelegate.saveContext()
        soundbites.append(soundbite)
        collectionView?.reloadData()
    }
    
    @IBAction func clearBoard(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Clear soundboard?", message: "This will clear the entire soundboard.\nNo files will be removed.", preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Clear", style: .Destructive, handler: { (action) in
            self.clearData()
        }))
        alert.popoverPresentationController?.barButtonItem = deleteBarButtonItem
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    /// Clears the entire soundboard.
    private func clearData() {
        // Remove from persistence
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "Soundbite"))
        do {
            try context.executeRequest(deleteRequest)
        } catch let error as NSError {
            print("Couldn't clear board:", error)
        }
        
        // Remove from memory
        soundbites = []
        collectionView?.reloadData()
    }
    
    /// Gets the ID/index of the cell that contains the button that was tapped.
    private func getCellId(button: UIButton) -> Int {
        let convertedPoint = collectionView?.convertPoint(button.center, fromView: button.superview)
        let indexPath = collectionView?.indexPathForItemAtPoint(convertedPoint!)
        return (indexPath?.row)!
    }
    
    @IBAction func playbackCell(sender: UIButton) {
        let index = getCellId(sender)
        let soundbite = soundbites[index]
        print("Playing soundbite \(index)/\(soundbite.name)")
        if let file = soundbite.file {
            SoundbitePlayer.playFile(file)
        }
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
                    self.context.deleteObject(soundbite)
                    self.soundbites.removeAtIndex(cellId)
                } else {
                    print("Soundbite \(cellId) will be updated")
                    // The context and the object stay connected (somehow);
                    // the saveContext() below applies the changes made by
                    // the detail view to the persistent store.
                    self.soundbites[cellId] = soundbite
                }
                self.appDelegate.saveContext()
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
