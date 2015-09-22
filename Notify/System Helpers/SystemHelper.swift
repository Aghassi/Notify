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
    Checks if an application is currently playing and is not in foreground
    */
    static func checkPlayerStateIsPlayingAndApplicationIsNotInForeground(playerState: String, _ client: Client) -> Bool {
        let foregroundApp: NSRunningApplication = NSWorkspace.sharedWorkspace().frontmostApplication!
        
        // Don't display anything if spotify is in the foreground
        if (foregroundApp.bundleIdentifier == client.rawValue) {
            return false
        }
        
        return (playerState == "Playing")
    }
    
    /*
    Add an observer to an event for an application
    */
    static func addObserver(helper: AnyObject, selector: Selector, client: Client, event: PlaybackChanged) {
        // Set observer to when the application state changes
        NSDistributedNotificationCenter.defaultCenter().addObserver(helper.self,
            selector: selector,
            name: client.rawValue + "." + event.rawValue,
            object: nil,
            suspensionBehavior: NSNotificationSuspensionBehavior.DeliverImmediately)
    }
}