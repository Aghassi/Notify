//
//  NotificationHandler.swift
//  Type: Object and Delegate of NSUserNotificationCenter
//  Notify
//
//  Created by David Aghassi on 9/19/15.
//  Copyright © 2015 David Aghassi. All rights reserved.
//

import Foundation

class NotificationHandler: NSObject, NSUserNotificationCenterDelegate {
    // The current track being played
    var track = Song()
    // Previous trackID
    var previousTrackID = ""
    
    override init() {
        super.init()
        // Set as delegate
        NSUserNotificationCenter.defaultUserNotificationCenter().delegate = self
        // Set observer to when Spotify state changes
        NSDistributedNotificationCenter.defaultCenter().addObserver(self,
                                                        selector: Selector("stateChanged"),
                                                        name: "com.spotify.client.PlaybackStateChanged",
                                                        object: nil,
                                                        suspensionBehavior: NSNotificationSuspensionBehavior.DeliverImmediately)
    }
    
    func setCurrentTrack() {
        
    }
    
    func currentTrack() -> Song {
        return track
    }
}