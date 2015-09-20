//
//  AppDelegate.swift
//  Notify
//
//  Created by David Aghassi on 9/18/15.
//  Copyright © 2015 David Aghassi. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {
    let helper = NotificationHandler()

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Set as delegate
        NSUserNotificationCenter.defaultUserNotificationCenter().delegate = helper
        // Set observer to when Spotify state changes
        NSDistributedNotificationCenter.defaultCenter().addObserver(helper.self,
            selector: "stateChanged:",
            name: "com.spotify.client.PlaybackStateChanged",
            object: nil,
            suspensionBehavior: NSNotificationSuspensionBehavior.DeliverImmediately)
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

