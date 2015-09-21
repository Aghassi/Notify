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
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    
    let helper = NotificationHandler()

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        if let button = statusItem.button {
            button.image = NSImage(named: "statusIcon")
            button.image?.template = true   // sets the icon to inverted color for dark mode
            button.action = Selector("quitClicked:")
            
            statusItem.menu = statusMenu
        }
        
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
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }
}

