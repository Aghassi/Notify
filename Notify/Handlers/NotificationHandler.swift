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
import Cocoa
import Alamofire
import SwiftyJSON

class NotificationHandler: NSObject, NSUserNotificationCenterDelegate {
    // The current track being played
    var track: Song
    // Previous trackID
    var previousTrackID: String
    
    override init() {
        // Set properties
        track = Song()
        previousTrackID = ""
        
        super.init()
    }
    
    /**
    Called when Spotify changes it's playback state
    @param notification, an NSNotification passed in when state changes
    **/
    func stateChanged(notification: NSNotification) {
        // Assign constant userInfo as type NSDictionary
        let userInfo: NSDictionary = notification.userInfo!
        let stateOfPlayer: String = userInfo["Player State"] as! String
        
        if (SystemHelper.checkPlayerStateIsPlayingAndSpotifyIsNotInForeground(stateOfPlayer)) {
            // Set the current track
            setCurrentTrack(userInfo)
        }
        else {
            // Remove all the notifications we have delivered
            NSUserNotificationCenter.defaultUserNotificationCenter().removeAllDeliveredNotifications()
        }
    }
    
    func sendNotification() {
        // Only send a notification if the "track" is not an ad.
        // This doesn't seem necessary, but it's better to check
        if (!track.album.hasPrefix("http")) {
            let notificationToDeliver: NSUserNotification = NSUserNotification()
            notificationToDeliver.title = track.name
            notificationToDeliver.subtitle = track.album
            notificationToDeliver.informativeText = track.artist
            notificationToDeliver.contentImage = track.image
            notificationToDeliver.hasActionButton = false
            
            //Deliver Notification to user
            NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notificationToDeliver)
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
        
        // We receive values like spotify:track:0QXPKOlwGXrEUId6H1Eyxa. We just need the last section
        let fullId = info["Track ID"] as! String
        track.trackID = fullId.componentsSeparatedByString(":")[2]
        
        // Get the album art for the track
        let spotifyApiUrl = "https://api.spotify.com/v1/tracks/" + track.trackID
        Alamofire.request(.GET, spotifyApiUrl, parameters: nil)
            .responseJSON { (req, res, result) in
                if (result.isFailure) {
                    NSLog("Error: \(result.error)")
                }
                else {
                    var json = JSON(result.value!)
                    // Get the album art. Size doesn't matter.
                    var image = json["album"]["images"][0]
                    let albumArtworkUrl: NSURL = NSURL(string: image["url"].stringValue)!
                    let albumArtwork = NSImage(contentsOfURL: albumArtworkUrl)
                    self.track.image = albumArtwork!
                    
                    // Send the notification
                    self.sendNotification()
                }
        }
    }

}