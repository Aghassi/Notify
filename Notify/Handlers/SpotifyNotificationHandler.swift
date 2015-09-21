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

class SpotifyNotificationHandler: NSObject, NSUserNotificationCenterDelegate, NotificationHandler {
    let track = Song()
    let client: Client = .Spotify
    
    /**
    Called when the application changes its playback state
    @param notification, an NSNotification passed in when state changes
    **/
    func spotifyStateChanged(notification: NSNotification) {
        self.stateChanged(notification)
    }

    
    /**********************
    * Getters and Setters *
    **********************/
    func setCurrentTrack(info: NSDictionary) {
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