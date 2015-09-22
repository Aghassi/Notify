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
    var track = Song()
    let client: Client = .iTunes
    
    /**
    Called when the application changes its playback state
    @param notification, an NSNotification passed in when state changes
    **/
    func iTunesStateChanged(notification: NSNotification) {
        self.stateChanged(notification)
    }
    
    /**********************
    * Getters and Setters *
    **********************/
    func setCurrentTrack(info: NSDictionary) {
        // Reset to no data
        track = Song()
        
        // Set the current track
        track.name = info["Name"] as! String
        if let albumArtist = info["Album Artist"] {
            track.artist = albumArtist as! String
        }
        else if let artist = info["Artist"] {
            track.artist = artist as! String
        }
        
        if let album = info["Album"] {
            track.album = album as! String
        }
        
        // Get the album art for the track
        if (!track.artist.isEmpty && !track.album.isEmpty) {
            let itunesApiUrl = "https://itunes.apple.com/search"
            let parameters = ["term": track.album, "attribute": "albumTerm", "entity": "album"]
            Alamofire.request(.GET, itunesApiUrl, parameters: parameters)
                .responseJSON { (req, res, result) in
                    if (result.isFailure) {
                        NSLog("Error: \(result.error)")
                    }
                    else {
                        var json = JSON(result.value!)
                        if (json["resultCount"].intValue > 0) {
                            for i in 0..<json["results"].count {
                                let albumJson = json["results"][i]
                                if (albumJson["artistName"].stringValue == self.track.artist) {
                                    // Get the album art. Size doesn't matter.
                                    let albumArtworkUrl: NSURL = NSURL(string: albumJson["artworkUrl100"].stringValue)!
                                    let albumArtwork = NSImage(contentsOfURL: albumArtworkUrl)
                                    if (albumArtwork != nil) {
                                        self.track.image = albumArtwork!
                                    }
                                    break
                                }
                            }
                        }
                    }
                    
                    // Send the notification
                    self.sendNotification()
                }
        }
        else {
            sendNotification()
        }
    }
}