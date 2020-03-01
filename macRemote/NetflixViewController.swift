//
//  netflixViewController.swift
//  macRemote
//
//  Created by Thomas Kittel on 22.12.18.
//  Copyright © 2018 Thomas Kittel. All rights reserved.
//

import UIKit

class NetflixViewController: RemoteViewController {
    
    //MARK: Outlets
    @IBOutlet weak var pausePlayView: UIView! {
        didSet { setupRecognizer(for: pausePlayView, withID: "pausePlay") }
    }
    
    //MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //append all the views
        remoteButtonViews.append(pausePlayView)
        
        //init and update
        initRemoteButtonViews()
        updateRemoteButtonViews()
    }
}
