//
//  ITunesNotificationHandler.swift
//  Notify
//
//  Created by Chris Rees on 9/21/15.
//  Copyright © 2015 David Aghassi. All rights reserved.
//

import Foundation

class ITunesNotificationHandler: NSObject, NSUserNotificationCenterDelegate, NotificationHandler {
    let track = Song()
    
    /**
    Called when the application changes its playback state
    @param notification, an NSNotification passed in when state changes
    **/
    func stateChanged(notification: NSNotification) {
        // Assign constant userInfo as type NSDictionary
        let userInfo: NSDictionary = notification.userInfo!
        let stateOfPlayer: String = userInfo["Player State"] as! String
        
        if (SystemHelper.checkPlayerStateIsPlayingAndApplicationIsNotInForeground(stateOfPlayer, Client.iTunes)) {
            // Set the current track
            self.setCurrentTrack(userInfo)
        }
        else {
            // Remove all the notifications we have delivered
            NSUserNotificationCenter.defaultUserNotificationCenter().removeAllDeliveredNotifications()
        }
    }
    
    /**********************
    * Getters and Setters *
    **********************/
    func setCurrentTrack(info: NSDictionary) {
        // Set the current track
        NSLog("%@", info)
        track.name = info["Name"] as! String
        track.artist = info["Album Artist"] as! String
        track.album = info["Album"] as! String
        sendNotification()
    }
}