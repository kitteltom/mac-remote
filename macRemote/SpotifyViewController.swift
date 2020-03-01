//
//  SpotifyViewController.swift
//  macRemote
//
//  Created by Thomas Kittel on 24.12.18.
//  Copyright © 2018 Thomas Kittel. All rights reserved.
//

import UIKit

class SpotifyViewController: RemoteViewController {

    //MARK: Outlets
    @IBOutlet weak var previousTrackView: UIView! {
        didSet { setupRecognizer(for: previousTrackView, withID: "previousTrack") }
    }
    @IBOutlet weak var nextTrackView: UIView! {
        didSet { setupRecognizer(for: nextTrackView, withID: "nextTrack") }
    }
    @IBOutlet weak var pausePlayView: UIView! {
        didSet { setupRecognizer(for: pausePlayView, withID: "pausePlay") }
    }
    
    //MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //append all the views
        remoteButtonViews.append(previousTrackView)
        remoteButtonViews.append(nextTrackView)
        remoteButtonViews.append(pausePlayView)
        
        //init and update
        initRemoteButtonViews()
        updateRemoteButtonViews()
    }
}
