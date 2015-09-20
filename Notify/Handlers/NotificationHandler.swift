//
//  NotificationHandler.swift
//  Type: Object and Delegate of NSUserNotificationCenter
//
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
    var previousTrackID = 0
    
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
    
    /**
    Called when Spotify changes it's playback state
    @param notification, an NSNotification passed in when state changes
    **/
    func stateChanged(notification: NSNotification) {
        // Assign constant userInfo as type NSDictionary
        let userInfo : NSDictionary = notification.userInfo!
        let stateOfPlayer : String = userInfo["Player State"] as! String
        
        if (SystemHelper.checkPlayerStateIsPlayingAndSpotifyIsNotInForeground(stateOfPlayer)) {
            // Set the current track
            setCurrentTrack(userInfo)
            let notificationToDeliver : NSUserNotification = NSUserNotification()
            notificationToDeliver.title = track.name
            notificationToDeliver.subtitle = track.album
            notificationToDeliver.informativeText = track.artist
            
            //Deliver Notification to user
            NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notificationToDeliver)
        }
        else {
            // We don't do anything if spotify is running
            return
        }
    }
    
    /**********************
    * Getters and Setters *
    **********************/
    func setCurrentTrack(info: NSDictionary) {
        // Set the prior trackID for when we playback previous
        previousTrackID = track.trackID
        
        // Set the current track
        track.name = info["Name"] as! String
        track.artist = info["Artist"] as! String
        track.album = info["Album"] as! String
        track.trackID = info["Track ID"] as! Int
    }
    
    func currentTrack() -> Song {
        return track
    }
}