//
//  SoundbitePlayer.swift
//  Soundboard
//
//  Created by Jan on 17.05.16.
//  Copyright © 2016 dfragment.net. All rights reserved.
//

import Foundation
import AVFoundation

class SoundbitePlayer {
    
    private static var recordStore : [String : AVAudioPlayer] = [:]
    
    internal class func cacheFile(url: NSURL) {
        do {
            let player = try AVAudioPlayer(contentsOfURL: url)
            recordStore[url.absoluteString] = player
        } catch let error as NSError {
            print("Could not submit audio player to cache:", error)
        }
    }
    
    internal class func playFile(url: NSURL) {
        playFile(url, recursionDepth: 0)
    }
    
    private class func playFile(url: NSURL, recursionDepth: Int) {
        if (recursionDepth >= 2) {
            print("Recursion depth is larger than 1; aborting to prevent infinite loop")
            return
        }
        let key = url.absoluteString
        if let player = recordStore[key] {
            print("Tried to play -> cache hit.")
            player.prepareToPlay()
            player.play()
        } else {
            print("Tried to play -> cache miss.")
            cacheFile(url)
            playFile(url, recursionDepth: recursionDepth + 1) // if this enters infinite recursion, something is very broken
        }
    }
    
    internal class func stopAllPlayers() {
        for (_, player) in recordStore {
            player.stop()
        }
    }
    
    internal class func emptyCache() {
        recordStore = [:]
    }
    
}
