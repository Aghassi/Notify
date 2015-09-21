//
//  NotificationHandler.swift
//  Notify
//
//  Created by Chris Rees on 9/21/15.
//  Copyright © 2015 David Aghassi. All rights reserved.
//

import Foundation

protocol NotificationHandler {
    // The current track being played
    var track: Song { get }
    
    func setCurrentTrack(info: NSDictionary)
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
}