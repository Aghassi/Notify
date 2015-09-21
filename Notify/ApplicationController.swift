//
//  ApplicationController.swift
//  Notify
//
//  Created by Chris Rees on 9/21/15.
//  Copyright © 2015 David Aghassi. All rights reserved.
//

import Foundation

protocol ApplicationController {
    var application: Application { get }
}

extension ApplicationController {
    // Send a command to an application
    func sendCommand(command: Command) {
        sendCommand(self.application, command)
    }
    
    /**
    Sends a specific command to an application
    @param app The application to which we should send the command (iTunes, Spotify, etc)
    @param command The command to be sent (next, playpause, previous etc.)
    **/
    private func sendCommand(app: Application, _ command: Command) {
        let script = "tell application \"" + app.rawValue + "\"\n" +
                        command.rawValue + " track\n" +
                     "end tell"
        runScript(script)
    }
    
    /**
    Runs an apple script for the string passed in
    @param script A string representing the script to be run
    **/
    private func runScript(script: String) {
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: script) {
            scriptObject.executeAndReturnError(&error)
            if (error != nil) {
                NSLog("error: \(error)")
            }
        }
    }
}