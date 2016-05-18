//
//  AppDelegate.swift
//  Soundboard
//
//  Created by Jan on 14.05.16.
//  Copyright © 2016 dfragment.net. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Especially useful during debugging in the Simulator.
        let appPath = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        print("App document path:", appPath)
        
        return true
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        // We have received a file -> move from Documents/Inbox to Documents
        // Note that you can't send audio files from Safari to other apps.
        let fileManager = NSFileManager.defaultManager()
        let documentFolder =  fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        do {
            let inbox = documentFolder.URLByAppendingPathComponent("Inbox", isDirectory: true)
            let allFiles = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(inbox, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions())
            for file in allFiles {
                let target = documentFolder.URLByAppendingPathComponent(file.lastPathComponent!)
                print("Moving", file, "to", target)
                try fileManager.moveItemAtURL(file, toURL: target)
            }
        } catch let error as NSError {
            print("Error while moving inbox:", error)
            return false
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        SoundbitePlayer.stopAllPlayers()
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file.
        self.createAppSupportDirectory()
        let urls = NSFileManager.defaultManager().URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application.
        let modelURL = NSBundle.mainBundle().URLForResource("Soundboard", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    /// Creates a "Library/Application Support" folder inside the app's container if it doesn't already exist.
    private func createAppSupportDirectory() {
        // By default there is no Application Support folder, so we need to create it before attempting to write to it
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask) as [NSURL]
        let firstHit = urls.first!
        var isDir : ObjCBool = false
        let exists = fileManager.fileExistsAtPath(firstHit.relativePath!, isDirectory: &isDir)
        print("AppSupport Check:", isDir, exists)
        if !(exists && isDir) {
            do {
                try fileManager.createDirectoryAtURL(firstHit, withIntermediateDirectories: true, attributes: [:])
                print("AppSupport folder created.")
            } catch {
                print("Could not create AppSupport folder.", error)
            }
        } else {
            print("AppSupport already exists.")
        }
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}
