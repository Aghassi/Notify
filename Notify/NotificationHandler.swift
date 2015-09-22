//
//  NotificationHandler.swift
//  Notify
//
//  Created by Chris Rees on 9/21/15.
//  Copyright © 2015 David Aghassi. All rights reserved.
//

import Foundation
import Cocoa

protocol NotificationHandler: NSUserNotificationCenterDelegate {
    // The current track being played
    var track: Song { get }
    var client: Client { get }
    func setCurrentTrack(info: NSDictionary)
    func stateChanged(notification: NSNotification)
}

extension NotificationHandler {
    func sendNotification() {
        let notification: NSUserNotification = NSUserNotification()
        notification.title = track.name
        notification.subtitle = track.album
        notification.informativeText = track.artist
        notification.contentImage = track.image
        
        // If set as Alert, there will only be a close button
        notification.hasActionButton = false
        
        //Deliver Notification to user
        NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notification)
    }
    
    /**
    Called when the application changes its playback state
    @param notification, an NSNotification passed in when state changes
    **/
    func stateChanged(notification: NSNotification) {
        // Assign constant userInfo as type NSDictionary
        let userInfo: NSDictionary = notification.userInfo!
        let stateOfPlayer: String = userInfo["Player State"] as! String
        
        if (SystemHelper.checkPlayerStateIsPlayingAndApplicationIsNotInForeground(stateOfPlayer, self.client)) {
            // Set the current track
            self.setCurrentTrack(userInfo)
        }
        else {
            // Remove all the notifications we have delivered
            NSUserNotificationCenter.defaultUserNotificationCenter().removeAllDeliveredNotifications()
        }
    }
    
    func isApplicationRunning() -> Bool {
        let app = NSRunningApplication.runningApplicationsWithBundleIdentifier(self.client.rawValue)
        return app.count > 0
    }
}