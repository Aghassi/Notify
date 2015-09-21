//
//  TodayViewController.swift
//  NCWidget
//
//  Created by David Aghassi on 9/21/15.
//  Copyright © 2015 David Aghassi. All rights reserved.
//

import Cocoa
import NotificationCenter

class TodayViewController: NSViewController, NCWidgetProviding {
    @IBOutlet weak var albumCoverImage: NSImageView!

    @IBOutlet weak var songLabel: NSTextField!
    @IBOutlet weak var artistLabel: NSTextField!
    @IBOutlet weak var albumLabel: NSTextField!
    
    
    @IBAction func playButton(sender: NSButton) {
    }
    
    @IBAction func fastForwardButton(sender: NSButton) {
    }
    @IBAction func rewindButton(sender: NSButton) {
    }
    
    override var nibName: String? {
        return "TodayViewController"
    }

    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
        completionHandler(.NoData)
    }
    
    override func viewDidLoad() {
        songLabel.stringValue = ""
        artistLabel.stringValue = ""
        albumLabel.stringValue = ""
    }

}
