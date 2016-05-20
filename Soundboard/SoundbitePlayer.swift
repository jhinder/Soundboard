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
    private static var audioSession = AVAudioSession.sharedInstance()
    
    /// Inserts an audio file into the cache.
    internal class func cacheFile(url: NSURL) {
        do {
            let player = try AVAudioPlayer(contentsOfURL: url)
            recordStore[url.absoluteString] = player
        } catch let error as NSError {
            print("Could not submit audio player to cache:", error)
        }
    }
    
    /// Plays an audio file and inserts it to the cache if required.
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
            /* Superfluous call: play() invokes prepareForPlay() if necessary,
             * and stop() or end of playback undoes prepareForPlay().
             * //player.prepareToPlay()
             */
            player.play()
        } else {
            print("Tried to play -> cache miss.")
            cacheFile(url)
            playFile(url, recursionDepth: recursionDepth + 1) // if this enters infinite recursion, something is very broken
        }
    }
    
    /// Stops playback of all audio files.
    internal class func stopAllPlayers() {
        let reset = AppSettings.instance().resetWhenStopping
        for (_, player) in recordStore {
            player.stop()
            if reset {
                player.currentTime = 0
            }
        }
    }
    
    /// Prepares the audio session for playback (sets category and options).
    internal class func setUpSession() {
        print("Preparing the session...")
        applyFlagsToAudioSession()
        do {
            try audioSession.setActive(true)
        } catch {
            print("Could not start session:", error)
        }
    }
    
    /// Disables the audio session.
    internal class func tearDownSession() {
        print("Stopping the session...")
        do {
            try audioSession.setActive(false)
        } catch {
            print("Could not stop session:", error)
        }
    }
    
    private class func applyFlagsToAudioSession() {
        let options = getSessionOptionFlags()
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: options)
            print("New audio options (bitmask value):", options.rawValue)
        } catch {
            print("Could not apply session flags, bitmask value \(options.rawValue):", error)
        }
    }
    
    private class func getSessionOptionFlags() -> AVAudioSessionCategoryOptions {
        let settings = AppSettings.instance()
        var flagsRaw : UInt = 0
        if settings.allowOtherAudio {
            flagsRaw = flagsRaw | AVAudioSessionCategoryOptions.MixWithOthers.rawValue
        }
        return AVAudioSessionCategoryOptions(rawValue: flagsRaw)
    }
    
}
