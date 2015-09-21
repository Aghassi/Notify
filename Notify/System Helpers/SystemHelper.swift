//
//  SystemHelper.swift
//  Contains a collection of methods that may be used to detect certain
//  system based properties
//
//  Notify
//
//  Created by David Aghassi on 9/19/15.
//  Copyright © 2015 David Aghassi. All rights reserved.
//

import Foundation
import Cocoa

class SystemHelper {
    /*
    Checks if spotify is currently playing and is not in foreground
    */
    static func checkPlayerStateIsPlayingAndSpotifyIsNotInForeground(playerState: String) -> Bool {
        let foregroundApp: NSRunningApplication = NSWorkspace.sharedWorkspace().frontmostApplication!
        
        // Don't display anything if spotify is in the foreground
        if (foregroundApp.bundleIdentifier == "com.spotify.client") {
            return false
        }
        
        return (playerState == "Playing")
    }
    
    /**
    Sends a specific command to an application
    @param app The application to which we should send the command (iTunes, Spotify, etc)
    @param command The command to be sent (next, playpause, previous etc.)
    **/
    static func sendCommand(app: Application, _ command: Command) {
        let script = "tell application \"" + app.rawValue + "\"\n" +
                          command.rawValue + " track\n" +
                     "end tell"
        runScript(script)
    }
    
    /**
    Runs an apple script for the string passed in
    @param script A string representing the script to be run
    **/
    static func runScript(script: String) {
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: script) {
            scriptObject.executeAndReturnError(&error)
            if (error != nil) {
                NSLog("error: \(error)")
            }
        }
    }

}