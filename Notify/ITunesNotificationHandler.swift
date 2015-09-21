//
//  ITunesNotificationHandler.swift
//  Notify
//
//  Created by Chris Rees on 9/21/15.
//  Copyright © 2015 David Aghassi. All rights reserved.
//

import Foundation
import Cocoa
import Alamofire
import SwiftyJSON

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
        track.name = info["Name"] as! String
        track.artist = info["Album Artist"] as! String
        track.album = info["Album"] as! String
        
        // Get the album art for the track
        let storeUrl = info["Store URL"] as! String
        let albumId = getQueryStringParameter(storeUrl, param: "p")
        if (albumId != nil) {
            let itunesApiUrl = "https://itunes.apple.com/lookup?id=" + albumId!
            Alamofire.request(.GET, itunesApiUrl, parameters: nil)
                .responseJSON { (req, res, result) in
                    if (result.isFailure) {
                        NSLog("Error: \(result.error)")
                    }
                    else {
                        var json = JSON(result.value!)
                        // Get the album art. Size doesn't matter.
                        let albumArtworkUrl: NSURL = NSURL(string: json["results"][0]["artworkUrl100"].stringValue)!
                        let albumArtwork = NSImage(contentsOfURL: albumArtworkUrl)
                        self.track.image = albumArtwork!
                    
                        // Send the notification
                        self.sendNotification()
                    }
            }
        }
        else {
            sendNotification()
        }
    }
    
    func getQueryStringParameter(url: String, param: String) -> String? {
        if let urlComponents = NSURLComponents(string: url), queryItems = (urlComponents.queryItems as [NSURLQueryItem]?) {
            return queryItems.filter({ (item) in item.name == param }).first?.value!
        }
        return nil
    }
}