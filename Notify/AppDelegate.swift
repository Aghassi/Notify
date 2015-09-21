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
    @IBOutlet weak var playPause: NSMenuItem!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    
    // Delivers notifications when the tracks change
    let helper = NotificationHandler()
    
    let spotify: ApplicationController = SpotifyController()

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Set statusbar icon
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
            name: Client.Spotify.rawValue + ".PlaybackStateChanged",
            object: nil,
            suspensionBehavior: NSNotificationSuspensionBehavior.DeliverImmediately)
        NSDistributedNotificationCenter.defaultCenter().addObserver(self,
            selector: "togglePlayPauseText:",
            name: Client.Spotify.rawValue + ".PlaybackStateChanged",
            object: nil,
            suspensionBehavior: NSNotificationSuspensionBehavior.DeliverImmediately)
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }
    
    @IBAction func nextTrack(sender: NSMenuItem) {
        spotify.sendCommand(Command.Next)
    }
    
    @IBAction func prevTrack(sender: NSMenuItem) {
        spotify.sendCommand(Command.Previous)
    }
    
    // Would like to change the menu item text if we can tell if spotify is playing
    @IBAction func playPauseToggle(sender: NSMenuItem) {
        spotify.sendCommand(Command.PlayPause)
    }
    
    /**
    Toggles the "Play/Pause" button when the player state changes"
    **/
    func togglePlayPauseText(notification: NSNotification) {
        // Assign constant userInfo as type NSDictionary
        let userInfo: NSDictionary = notification.userInfo!
        let stateOfPlayer: String = userInfo["Player State"] as! String
        
        if (stateOfPlayer == "Playing") {
            playPause.title = "Pause"
        }
        else if (stateOfPlayer == "Paused") {
            playPause.title = "Play"
        }
    }
}

