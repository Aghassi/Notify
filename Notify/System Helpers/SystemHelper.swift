//
//  SystemHelper.swift
//  Notify
//
//  Created by David Aghassi on 9/19/15.
//  Copyright © 2015 David Aghassi. All rights reserved.
//

import Foundation
import Cocoa

class SystemHelper {
    // Checks if spotify is currently playing
    static func checkPlayerStateIsPlayingAndSpotifyIsNotInForeground(playerState: String) -> Bool {
        let foregroundApp : NSRunningApplication = NSWorkspace.sharedWorkspace().frontmostApplication!
        
        // Don't display anything if spotify is in the foreground
        if (foregroundApp.bundleIdentifier == "com.spotify.client") {
            return false
        }
        
        return (playerState == "Playing")
    }
}